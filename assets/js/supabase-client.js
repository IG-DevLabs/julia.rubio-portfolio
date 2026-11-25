/**
 * Júlia Rubio Portfolio CMS - Supabase Client
 * Handles client initialization, configuration checks, media URL resolution,
 * and Storage bucket interactions.
 */

// ---------------------------------------------------------------------
// 1. CONFIGURATION
// Insira as credenciais do seu projeto Supabase aqui.
// Elas também podem ser configuradas dinamicamente via localStorage pelo /admin/.
// ---------------------------------------------------------------------
function cleanSupabaseUrl(rawUrl) {
  if (!rawUrl || typeof rawUrl !== "string") return "";
  let clean = rawUrl.trim();
  // Remove /rest/v1 or /rest/v1/ if user pasted API URL
  clean = clean.replace(/\/rest\/v1\/?$/i, "");
  clean = clean.replace(/\/+$/, "");
  return clean;
}

const SUPABASE_CONFIG = {
  url: cleanSupabaseUrl(localStorage.getItem("jr_supabase_url") || "https://fzqkheffrxywxqjevpql.supabase.co"),
  anonKey: (localStorage.getItem("jr_supabase_anon_key") || "").trim()
};

/**
 * Checks if Supabase credentials are validly configured.
 */
function isSupabaseConfigured() {
  const url = cleanSupabaseUrl(SUPABASE_CONFIG.url);
  const key = (SUPABASE_CONFIG.anonKey || "").trim();
  return Boolean(
    url &&
    key &&
    url.startsWith("https://") &&
    !url.includes("your-project-id") &&
    key.length > 20
  );
}

/**
 * Singleton Supabase client instance.
 */
let _supabaseInstance = null;

function getSupabase() {
  if (!isSupabaseConfigured()) {
    return null;
  }
  if (_supabaseInstance) {
    return _supabaseInstance;
  }

  // Ensure supabase-js SDK is available
  const createClientFn = window.supabase?.createClient;
  if (typeof createClientFn !== "function") {
    console.warn("[CMS] Supabase JS SDK not loaded yet.");
    return null;
  }

  try {
    const cleanUrl = cleanSupabaseUrl(SUPABASE_CONFIG.url);
    _supabaseInstance = createClientFn(cleanUrl, SUPABASE_CONFIG.anonKey, {
      auth: {
        persistSession: true,
        autoRefreshToken: true,
        detectSessionInUrl: true,
        storage: window.localStorage
      }
    });
    return _supabaseInstance;
  } catch (err) {
    console.error("[CMS] Error initializing Supabase client:", err);
    return null;
  }
}

/**
 * Updates credentials in localStorage and resets client instance.
 */
function updateSupabaseConfig(url, anonKey) {
  SUPABASE_CONFIG.url = cleanSupabaseUrl(url);
  SUPABASE_CONFIG.anonKey = (anonKey || "").trim();
  if (SUPABASE_CONFIG.url) {
    localStorage.setItem("jr_supabase_url", SUPABASE_CONFIG.url);
  } else {
    localStorage.removeItem("jr_supabase_url");
  }
  if (SUPABASE_CONFIG.anonKey) {
    localStorage.setItem("jr_supabase_anon_key", SUPABASE_CONFIG.anonKey);
  } else {
    localStorage.removeItem("jr_supabase_anon_key");
  }
  _supabaseInstance = null;
  return isSupabaseConfigured();
}

/**
 * Resolves media paths properly for both local legacy files and Supabase Storage URLs.
 * Also accounts for GitHub Pages base URL and whether current page is in /admin/ or /.
 *
 * @param {string} path - URL or local relative path (e.g. "assets/images/projects/p80_0.webp")
 * @param {string} [prefix] - Optional prefix override (e.g. "../" when called from /admin/)
 * @returns {string} - Clean, resolved URL/path
 */
function resolveMediaPath(path, prefix) {
  if (!path || typeof path !== "string") return "";

  // Absolute or data/blob URLs are returned as-is
  if (path.startsWith("http://") || path.startsWith("https://") || path.startsWith("data:") || path.startsWith("blob:")) {
    return path;
  }

  // Strip any existing ../ or ./ or / so we start with a clean canonical relative path
  const cleanPath = path.replace(/^\.\.\//, "").replace(/^\.\//, "").replace(/^\//, "");

  // Determine if caller is running from /admin/
  const isInAdmin = window.location.pathname.includes("/admin");
  const defaultPrefix = isInAdmin ? "../" : "";
  const appliedPrefix = typeof prefix === "string" ? prefix : defaultPrefix;

  return appliedPrefix + cleanPath;
}

/**
 * Uploads a file (image or video) to Supabase Storage 'portfolio' bucket.
 * Returns public URL upon successful upload.
 *
 * @param {File} file - Browser File object
 * @param {string} [folder] - Subfolder inside bucket (e.g. "projects/slug")
 * @param {function} [onProgress] - Optional progress callback
 * @returns {Promise<{ url: string, path: string, type: 'i'|'v' }>}
 */
async function uploadPortfolioMedia(file, folder = "projects") {
  const client = getSupabase();
  if (!client) {
    throw new Error("Supabase não configurado. Adicione a URL e a Chave Anon nas Configurações.");
  }

  // Generate safe unique filename
  const ext = file.name.split(".").pop().toLowerCase();
  const cleanName = file.name
    .replace(/\.[^/.]+$/, "")
    .toLowerCase()
    .replace(/[^a-z0-9_-]/g, "_")
    .slice(0, 32);
  const randomId = Math.random().toString(36).substring(2, 8);
  const fileName = `${folder}/${cleanName}_${Date.now()}_${randomId}.${ext}`;

  const { data, error } = await client.storage
    .from("portfolio")
    .upload(fileName, file, {
      cacheControl: "31536000",
      upsert: false
    });

  if (error) {
    console.error("[CMS] Upload error:", error);
    throw error;
  }

  // Get public URL
  const { data: urlData } = client.storage
    .from("portfolio")
    .getPublicUrl(data.path);

  const isVideo = file.type.startsWith("video/") || ext === "mp4" || ext === "webm";

  return {
    url: urlData.publicUrl,
    path: data.path,
    type: isVideo ? "v" : "i",
    name: file.name
  };
}

/**
 * Removes a file from Supabase Storage 'portfolio' bucket.
 *
 * @param {string} pathOrUrl - File storage path or full public URL
 */
async function deletePortfolioMedia(pathOrUrl) {
  const client = getSupabase();
  if (!client || !pathOrUrl) return;

  // If full URL, extract path after /portfolio/
  let filePath = pathOrUrl;
  if (pathOrUrl.includes("/storage/v1/object/public/portfolio/")) {
    filePath = pathOrUrl.split("/storage/v1/object/public/portfolio/")[1];
  } else if (pathOrUrl.startsWith("portfolio/")) {
    filePath = pathOrUrl.replace("portfolio/", "");
  }

  // Do not attempt to delete local assets
  if (filePath.startsWith("assets/") || filePath.startsWith("../assets/")) {
    return;
  }

  try {
    const { error } = await client.storage
      .from("portfolio")
      .remove([filePath]);
    if (error) {
      console.warn("[CMS] Failed to delete remote file:", error.message);
    }
  } catch (err) {
    console.warn("[CMS] Delete media exception:", err);
  }
}

// Export functions to global scope
window.SUPABASE_CONFIG = SUPABASE_CONFIG;
window.isSupabaseConfigured = isSupabaseConfigured;
window.getSupabase = getSupabase;
window.updateSupabaseConfig = updateSupabaseConfig;
window.resolveMediaPath = resolveMediaPath;
window.uploadPortfolioMedia = uploadPortfolioMedia;
window.deletePortfolioMedia = deletePortfolioMedia;
