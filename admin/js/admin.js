/**
 * Júlia Rubio Portfolio CMS - Admin Core Controller
 * Orchestrates router, featured projects reordering, settings tester,
 * mobile drawer, and toast notifications.
 */

/**
 * Toast Notification Helper
 */
function showToast(message, type = "info") {
  const container = document.getElementById("toast-container");
  if (!container) return;

  const toast = document.createElement("div");
  toast.className = `toast toast-${type}`;

  let iconSvg = "";
  if (type === "success") {
    iconSvg = '<svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="#22c55e" stroke-width="2.5"><polyline points="20 6 9 17 4 12"/></svg>';
  } else if (type === "error") {
    iconSvg = '<svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="#ef4444" stroke-width="2.5"><circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/></svg>';
  } else {
    iconSvg = '<svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="#3b82f6" stroke-width="2.5"><circle cx="12" cy="12" r="10"/><line x1="12" y1="16" x2="12" y2="12"/><line x1="12" y1="8" x2="12.01" y2="8"/></svg>';
  }

  toast.innerHTML = `
    ${iconSvg}
    <span>${message}</span>
  `;

  container.appendChild(toast);

  setTimeout(() => {
    toast.style.opacity = "0";
    toast.style.transform = "translateY(10px)";
    toast.style.transition = "all 0.3s ease";
    setTimeout(() => toast.remove(), 300);
  }, 3500);
}
window.showToast = showToast;

const AdminApp = {
  featuredSortable: null,

  /**
   * Main App Initialization
   */
  async init() {
    this.bindNavigation();
    this.bindSettings();
    this.bindFeatured();
    this.bindMobileMenu();

    // Initialize modules
    MediaManager.init();
    ProjectsManager.init();

    // Check auth
    await AdminAuth.init();

    // Load projects into memory
    await ProjectsManager.loadProjects();

    // Listen for hash routing
    window.addEventListener("hashchange", () => this.handleRoute());

    // Initial route
    this.handleRoute();

    console.log("[AdminApp] CMS Admin initialized successfully.");
  },

  /**
   * Client-side Hash Router
   */
  handleRoute() {
    const rawHash = window.location.hash.slice(1) || "dashboard";
    const [route, param] = rawHash.split("/");

    // Update active nav styling
    document.querySelectorAll(".sidebar-nav .nav-item").forEach(item => {
      const targetNav = item.getAttribute("data-nav");
      if (targetNav === route || (route.startsWith("project-") && targetNav === "projects")) {
        item.classList.add("active");
      } else {
        item.classList.remove("active");
      }
    });

    // Hide all views
    document.querySelectorAll(".content-view").forEach(v => {
      v.style.display = "none";
    });

    // Close mobile drawer on route change
    const sidebar = document.getElementById("admin-sidebar");
    if (sidebar) sidebar.classList.remove("open");

    const headerTitle = document.getElementById("header-title");
    const headerActions = document.getElementById("header-actions");
    if (headerActions) headerActions.innerHTML = "";

    // Route view rendering
    switch (route) {
      case "dashboard":
        document.getElementById("view-dashboard").style.display = "block";
        if (headerTitle) headerTitle.textContent = "Dashboard";
        ProjectsManager.updateDashboardMetrics();
        break;

      case "projects":
        document.getElementById("view-projects").style.display = "block";
        if (headerTitle) headerTitle.textContent = "Projetos";
        ProjectsManager.renderTable();
        break;

      case "project-new":
        document.getElementById("view-project-editor").style.display = "block";
        if (headerTitle) headerTitle.textContent = "Novo Projeto";
        ProjectsManager.openEditor("new");
        break;

      case "project-edit":
        document.getElementById("view-project-editor").style.display = "block";
        if (headerTitle) headerTitle.textContent = "Editar Projeto";
        ProjectsManager.openEditor(param);
        break;

      case "featured":
        document.getElementById("view-featured").style.display = "block";
        if (headerTitle) headerTitle.textContent = "Destaques da Home";
        this.renderFeaturedList();
        break;

      case "settings":
        document.getElementById("view-settings").style.display = "block";
        if (headerTitle) headerTitle.textContent = "Configurações do Sistema";
        this.renderSettingsView();
        break;

      default:
        document.getElementById("view-dashboard").style.display = "block";
        if (headerTitle) headerTitle.textContent = "Dashboard";
        break;
    }
  },

  /**
   * Binds navigation sidebar items
   */
  bindNavigation() {
    // Already controlled via standard <a href="#route"> tags
  },

  /**
   * Binds mobile hamburger toggle
   */
  bindMobileMenu() {
    const toggleBtn = document.getElementById("btn-mobile-toggle");
    const sidebar = document.getElementById("admin-sidebar");

    if (toggleBtn && sidebar) {
      toggleBtn.style.display = "inline-flex";
      toggleBtn.addEventListener("click", () => {
        sidebar.classList.toggle("open");
      });
    }
  },

  /**
   * Renders and binds the Featured Projects list for reordering
   */
  renderFeaturedList() {
    const container = document.getElementById("featured-sortable-list");
    if (!container) return;

    // Filter featured items
    const featuredProjects = ProjectsManager.allProjects
      .filter(p => p.featured)
      .sort((a, b) => Number(a.featured_order || 0) - Number(b.featured_order || 0));

    container.innerHTML = "";

    if (featuredProjects.length === 0) {
      container.innerHTML = `
        <div style="text-align: center; padding: 40px; color: var(--text-subtle);">
          Nenhum projeto marcado como destaque. Para adicionar um projeto aos destaques, edite-o e ative a opção "Destaque na Home".
        </div>
      `;
      return;
    }

    featuredProjects.forEach((p, index) => {
      const card = document.createElement("div");
      card.className = "featured-sortable-item";
      card.dataset.id = p.id || p.slug;
      card.dataset.slug = p.slug;

      const coverUrl = window.ProjectsManager ? ProjectsManager.getThumbUrl(p) : resolveMediaPath(p.cover_url || (p.media && p.media[0] ? p.media[0][1] : ""));
      const catTags = (Array.isArray(p.tags) ? p.tags : []).join(", ");

      card.style.cssText = `
        display: flex;
        align-items: center;
        justify-content: space-between;
        padding: 14px 18px;
        background: var(--bg-surface);
        border: 1px solid var(--border-light);
        border-radius: var(--radius-md);
        box-shadow: var(--shadow-sm);
        cursor: grab;
      `;

      card.innerHTML = `
        <div style="display: flex; align-items: center; gap: 14px;">
          <div style="color: var(--text-subtle); font-family: var(--font-mono); font-weight: 700; width: 24px;">#${index + 1}</div>
          <img src="${coverUrl}" style="width: 44px; height: 44px; border-radius: var(--radius-sm); object-fit: cover;" onerror="this.onerror=null;this.src='${window.ADMIN_IMG_PLACEHOLDER || ''}'">
          <div>
            <div style="font-weight: 700; font-size: 14px;">${p.name}</div>
            <div style="font-size: 11px; color: var(--text-subtle);">${catTags || p.slug}</div>
          </div>
        </div>
        <div style="display: flex; align-items: center; gap: 10px;">
          <a href="#project-edit/${p.id || p.slug}" class="btn btn-sm">Editar</a>
          <div style="color: var(--text-subtle); cursor: grab;">
            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
              <line x1="8" y1="6" x2="16" y2="6"/>
              <line x1="8" y1="12" x2="16" y2="12"/>
              <line x1="8" y1="18" x2="16" y2="18"/>
            </svg>
          </div>
        </div>
      `;

      container.appendChild(card);
    });

    // Initialize SortableJS
    if (window.Sortable && !this.featuredSortable) {
      this.featuredSortable = Sortable.create(container, {
        animation: 150,
        ghostClass: "sortable-ghost",
        handle: ".featured-sortable-item"
      });
    }
  },

  /**
   * Binds save button for featured ordering
   */
  bindFeatured() {
    const saveBtn = document.getElementById("btn-save-featured-order");
    if (!saveBtn) return;

    saveBtn.addEventListener("click", async () => {
      saveBtn.disabled = true;
      saveBtn.textContent = "Salvando ordem...";

      const items = document.querySelectorAll("#featured-sortable-list .featured-sortable-item");
      const updates = [];

      items.forEach((item, index) => {
        const idOrSlug = item.dataset.id;
        const proj = ProjectsManager.allProjects.find(p => String(p.id) === idOrSlug || p.slug === idOrSlug);
        if (proj) {
          proj.featured_order = index + 1;
          updates.push(proj);
        }
      });

      // If connected to Supabase, update database
      if (isSupabaseConfigured() && AdminAuth.isAuthenticated()) {
        try {
          const client = getSupabase();
          for (const proj of updates) {
            await client
              .from("projects")
              .update({ featured_order: proj.featured_order })
              .eq("id", proj.id);
          }
          showToast("Ordem dos destaques salva no banco!", "success");
        } catch (err) {
          console.error("[AdminApp] Error saving featured order:", err);
          showToast(`Erro ao salvar ordem: ${err.message}`, "error");
        }
      } else {
        showToast("Ordem dos destaques atualizada localmente.", "info");
      }

      saveBtn.disabled = false;
      saveBtn.textContent = "Salvar Ordem dos Destaques";
      this.renderFeaturedList();
    });
  },

  /**
   * Populates and binds Settings view
   */
  renderSettingsView() {
    const urlInput = document.getElementById("settings-supabase-url");
    const keyInput = document.getElementById("settings-supabase-anon-key");
    const badge = document.getElementById("settings-data-source-badge");

    if (urlInput) urlInput.value = SUPABASE_CONFIG.url || "";
    if (keyInput) keyInput.value = SUPABASE_CONFIG.anonKey || "";

    if (badge) {
      if (isSupabaseConfigured()) {
        badge.className = "badge badge-published";
        badge.textContent = "✓ Supabase Conectado";
      } else {
        badge.className = "badge badge-draft";
        badge.textContent = "Modo Fallback Local (data/legacy-projects.json)";
      }
    }
  },

  /**
   * Binds settings events: save credentials, test connection, export backup
   */
  bindSettings() {
    const saveBtn = document.getElementById("btn-save-settings");
    const testBtn = document.getElementById("btn-test-connection");
    const exportBtn = document.getElementById("btn-export-backup");
    const statusBox = document.getElementById("settings-connection-status");

    if (saveBtn) {
      saveBtn.addEventListener("click", () => {
        const url = document.getElementById("settings-supabase-url").value.trim();
        const anonKey = document.getElementById("settings-supabase-anon-key").value.trim();

        if (!url || !anonKey) {
          showToast("Preencha ambos os campos: URL do Projeto e Chave Anon.", "error");
          return;
        }

        updateSupabaseConfig(url, anonKey);
        showToast("Configurações salvas no navegador!", "success");
        this.renderSettingsView();
      });
    }

    if (testBtn) {
      testBtn.addEventListener("click", async () => {
        testBtn.disabled = true;
        testBtn.textContent = "Testando...";
        if (statusBox) statusBox.style.display = "none";

        const url = document.getElementById("settings-supabase-url").value.trim();
        const anonKey = document.getElementById("settings-supabase-anon-key").value.trim();
        updateSupabaseConfig(url, anonKey);

        const client = getSupabase();
        if (!client) {
          this.showStatusResult(false, "Credenciais inválidas. Verifique o formato da URL e da Anon Key.");
          testBtn.disabled = false;
          testBtn.textContent = "Testar Conexão";
          return;
        }

        try {
          const { count, error } = await client
            .from("projects")
            .select("*", { count: "exact", head: true });

          if (error) throw error;

          this.showStatusResult(true, `Conexão bem-sucedida! Tabela 'projects' acessível (${count ?? 0} projetos encontrados).`);
          showToast("Conexão com o Supabase estabelecida com sucesso!", "success");
        } catch (err) {
          console.error("[AdminApp] Connection test failed:", err);
          this.showStatusResult(false, `Falha na conexão: ${err.message}`);
          showToast("Erro ao conectar ao Supabase.", "error");
        } finally {
          testBtn.disabled = false;
          testBtn.textContent = "Testar Conexão";
        }
      });
    }

    if (exportBtn) {
      exportBtn.addEventListener("click", () => {
        const dataStr = "data:text/json;charset=utf-8," + encodeURIComponent(JSON.stringify({
          exported_at: new Date().toISOString(),
          projects: ProjectsManager.allProjects,
          categories: ProjectsManager.categories
        }, null, 2));

        const downloadAnchor = document.createElement("a");
        downloadAnchor.setAttribute("href", dataStr);
        downloadAnchor.setAttribute("download", `portfolio-backup-${new Date().toISOString().slice(0, 10)}.json`);
        document.body.appendChild(downloadAnchor);
        downloadAnchor.click();
        downloadAnchor.remove();
        showToast("Backup JSON exportado com sucesso!", "success");
      });
    }
  },

  /**
   * Displays status box in settings
   */
  showStatusResult(success, message) {
    const statusBox = document.getElementById("settings-connection-status");
    if (!statusBox) return;

    statusBox.style.display = "block";
    if (success) {
      statusBox.style.background = "var(--accent-green-bg)";
      statusBox.style.color = "var(--accent-green)";
      statusBox.style.border = "1px solid var(--accent-green-border)";
    } else {
      statusBox.style.background = "var(--accent-red-bg)";
      statusBox.style.color = "var(--accent-red)";
      statusBox.style.border = "1px solid var(--accent-red-border)";
    }
    statusBox.textContent = message;
  }
};

// Start app when DOM is ready
document.addEventListener("DOMContentLoaded", () => {
  AdminApp.init();
});

window.AdminApp = AdminApp;
