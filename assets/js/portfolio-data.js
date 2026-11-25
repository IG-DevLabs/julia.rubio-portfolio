/**
 * Júlia Rubio Portfolio CMS - Portfolio Data Layer
 * Handles loading published projects from Supabase with instant local fallback
 * from data/legacy-projects.json.
 */

const PortfolioData = {
  projects: [],
  procMap: {},
  featuredSlugs: [],
  categories: [],
  isLoaded: false,
  source: "initial", // "supabase" | "legacy-json" | "inline"

  /**
   * Attempts to load cached projects from localStorage for instantaneous 0ms render.
   */
  loadFromCache() {
    try {
      const cached = localStorage.getItem("jr_portfolio_cache_v2");
      if (cached) {
        const parsed = JSON.parse(cached);
        if (Array.isArray(parsed) && parsed.length > 0) {
          this.processProjects(parsed);
          this.source = "cache";
          this.isLoaded = true;
          return true;
        }
      }
    } catch (e) {
      console.warn("[CMS] Cache load error:", e);
    }
    return false;
  },

  /**
   * Initializes data fetching.
   * Calls onReady callback when finished.
   */
  async init(onReady) {
    let loaded = false;

    // 0. Instant render from local cache if not already loaded
    if (!this.isLoaded) {
      this.loadFromCache();
    }

    // 1. Fetch live data from Supabase
    if (typeof isSupabaseConfigured === "function" && isSupabaseConfigured()) {
      try {
        const client = getSupabase();
        if (client) {
          const { data: dbProjects, error } = await client
            .from("projects")
            .select("*")
            .eq("status", "published")
            .order("display_order", { ascending: true });

          if (!error && Array.isArray(dbProjects) && dbProjects.length > 0) {
            this.processProjects(dbProjects);
            this.source = "supabase";
            this.isLoaded = true;
            loaded = true;
            try {
              localStorage.setItem("jr_portfolio_cache_v2", JSON.stringify(dbProjects));
            } catch (_) {}
            console.log(`[CMS] Loaded ${dbProjects.length} projects from Supabase.`);
          }
        }
      } catch (err) {
        console.warn("[CMS] Supabase fetch failed:", err.message);
      }
    }

    // 2. If Supabase didn't load and no cache exists, try local JSON fallback
    if (!loaded && !this.isLoaded) {
      try {
        const isInAdmin = window.location.pathname.includes("/admin");
        const jsonPath = isInAdmin ? "../data/legacy-projects.json" : "data/legacy-projects.json";
        const response = await fetch(jsonPath);
        if (response.ok) {
          const legacy = await response.json();
          if (legacy && Array.isArray(legacy.projects)) {
            this.processProjects(legacy.projects);
            this.categories = legacy.categories || [];
            this.source = "legacy-json";
            this.isLoaded = true;
            loaded = true;
            console.log(`[CMS] Loaded ${legacy.projects.length} projects from local JSON fallback.`);
          }
        }
      } catch (err) {
        console.warn("[CMS] Local JSON fetch failed:", err.message);
      }
    }

    // 3. If neither loaded, use inline legacy fallback if available
    if (!loaded && window.__INLINE_PROJECTS__) {
      this.projects = window.__INLINE_PROJECTS__;
      this.procMap = window.__INLINE_PROC__ || {};
      this.featuredSlugs = window.__INLINE_FEATURED__ || [];
      this.source = "inline";
      this.isLoaded = true;
      console.log("[CMS] Loaded from inline backup data.");
    }

    if (typeof onReady === "function") {
      onReady(this);
    }

    document.dispatchEvent(new CustomEvent("cms:data-loaded", {
      detail: {
        source: this.source,
        projectsCount: this.projects.length,
        featuredCount: this.featuredSlugs.length
      }
    }));

    return this;
  },

  /**
   * Normalizes database / JSON records into the structure expected by the portfolio renderer.
   */
  processProjects(rawList) {
    this.projects = [];
    this.procMap = {};
    const featuredItems = [];

    rawList.forEach((raw, index) => {
      // Normalize media array into [[type, url, ...]] format expected by legacy renderer
      const mediaTuples = [];
      if (Array.isArray(raw.media)) {
        raw.media.forEach(m => {
          if (Array.isArray(m)) {
            // Already a tuple [type, url, extra]
            const resolvedUrl = resolveMediaPath(m[1]);
            const resolvedExtra = (m[0] === "v" && m[2]) ? resolveMediaPath(m[2]) : m[2];
            mediaTuples.push([m[0], resolvedUrl, resolvedExtra]);
          } else if (m && typeof m === "object") {
            // Object format { type, url, poster, scrollPct }
            const resolvedUrl = resolveMediaPath(m.url);
            if (m.type === "w") {
              mediaTuples.push(["w", resolvedUrl, m.scrollPct || 50]);
            } else if (m.type === "v") {
              const videoUrl = resolvedUrl.startsWith("http") ? resolvedUrl : resolvedUrl.replace(/\.mp4$/i, "");
              mediaTuples.push(["v", videoUrl, m.poster ? resolveMediaPath(m.poster) : ""]);
            } else {
              mediaTuples.push(["i", resolvedUrl]);
            }
          }
        });
      }

      // Determine cover path (never pick an .mp4 stream as an <img> cover)
      let coverResolved = "";
      const isVideoUrl = u => /\.(mp4|webm)(\?.*)?$/i.test(u || "");
      if (raw.cover_url && !isVideoUrl(raw.cover_url)) {
        coverResolved = resolveMediaPath(raw.cover_url);
      } else if (mediaTuples.length > 0) {
        const firstImg = mediaTuples.find(m => (m[0] === "i" || m[0] === "w") && m[1]);
        if (firstImg) {
          coverResolved = firstImg[1];
        } else {
          const firstVid = mediaTuples.find(m => m[0] === "v");
          if (firstVid) {
            coverResolved = firstVid[2] || (firstVid[1] && !firstVid[1].startsWith("http") ? firstVid[1].replace(/\.mp4$/i, "") + ".webp" : "");
          }
        }
      }

      // Legacy numeric ID (keep null for new CMS projects so it never collides with p1_0..p84_0)
      const idVal = raw.legacy_id || null;

      const hasExplicitFeaturedOrder = raw.featured_order !== null && raw.featured_order !== undefined && raw.featured_order !== "";
      const featuredOrderVal = hasExplicitFeaturedOrder ? Number(raw.featured_order) : 999;

      // Compute matching cover index in mediaTuples
      let coverIdx = 0;
      if (coverResolved && mediaTuples.length > 0) {
        const found = mediaTuples.findIndex(m => m[1] === coverResolved || (m[0] === "v" && m[2] === coverResolved));
        if (found >= 0) coverIdx = found;
      }

      // Construct normalized project object compatible with all index.html functions
      const proj = {
        id: idVal,
        uuid: raw.id || null,
        slug: raw.slug,
        name: raw.name,
        year: String(raw.year || ""),
        place: raw.place || "",
        place_es: raw.place_pt || raw.place || "",
        tags: Array.isArray(raw.tags) ? raw.tags : [],
        media: mediaTuples,
        cover: coverIdx,
        cover_url: coverResolved,
        caption: raw.caption_pt || raw.caption_en || "",
        caption_pt: raw.caption_pt || "",
        caption_en: raw.caption_en || "",
        web: raw.web_url || "",
        featured: Boolean(raw.featured),
        featured_order: featuredOrderVal,
        display_order: Number(raw.display_order || index + 1)
      };

      this.projects.push(proj);

      // Collect featured items
      if (proj.featured) {
        featuredItems.push({
          slug: proj.slug,
          order: featuredOrderVal
        });
      }

      // Creative process (PROC) - only populate if it has real content
      if (raw.proc && typeof raw.proc === "object") {
        const procItem = { ...raw.proc };
        if (Array.isArray(procItem.bb)) {
          procItem.bb = procItem.bb.filter(Boolean).map(b => resolveMediaPath(b));
        }
        const hasBlocks = Array.isArray(procItem.blocks) && procItem.blocks.length > 0;
        const hasBb = Array.isArray(procItem.bb) && procItem.bb.length > 0;
        const hasLegacyText = Boolean(procItem.en || procItem.pt || procItem.es);
        if (hasBlocks || hasBb || hasLegacyText) {
          this.procMap[raw.slug] = procItem;
        }
      }
    });

    // Sort featured items by featured_order
    featuredItems.sort((a, b) => a.order - b.order);
    this.featuredSlugs = featuredItems.map(f => f.slug);
  },

  /**
   * Helper to get project by slug.
   */
  getBySlug(slug) {
    return this.projects.find(p => p.slug === slug) || null;
  },

  /**
   * Helper to get featured project objects.
   */
  getFeatured() {
    return this.featuredSlugs
      .map(s => this.getBySlug(s))
      .filter(Boolean);
  },

  /**
   * Helper to get all projects suitable for hero display.
   */
  getHeroProjects() {
    return this.projects;
  }
};

window.PortfolioData = PortfolioData;
