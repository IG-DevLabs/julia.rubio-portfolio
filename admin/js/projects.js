/**
 * Júlia Rubio Portfolio CMS - Projects Manager
 * Handles Project CRUD operations, live filtering, search,
 * category management, slug generation, and creative process (PROC) blocks.
 */

const ADMIN_TABLE_PLACEHOLDER = "data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 120 120'%3E%3Crect width='120' height='120' fill='%23f5f4f1'/%3E%3Cpath d='M42 78l14-18 11 14 8-10 13 14H42z' fill='%23d4d1ca'/%3E%3Ccircle cx='50' cy='46' r='6' fill='%23d4d1ca'/%3E%3C/svg%3E";

const ProjectsManager = {
  allProjects: [],
  categories: [
    { slug: "branding", label: "Branding" },
    { slug: "packaging", label: "Packaging" },
    { slug: "web", label: "Web" },
    { slug: "illustration", label: "Illustration" },
    { slug: "editorial", label: "Editorial" },
    { slug: "social", label: "Social Media" }
  ],
  currentProject: null,
  procBlocks: [],

  /**
   * Resolves a safe image thumbnail URL for a project in admin views.
   */
  getThumbUrl(p) {
    if (!p) return ADMIN_TABLE_PLACEHOLDER;
    let url = p.cover_url || "";
    if (!url || /\.(mp4|webm)(\?.*)?$/i.test(url)) {
      if (Array.isArray(p.media)) {
        const imgItem = p.media.find(m => {
          const ty = Array.isArray(m) ? m[0] : m?.type;
          const u = Array.isArray(m) ? m[1] : m?.url;
          return (ty === "i" || ty === "w") && u;
        });
        if (imgItem) {
          url = Array.isArray(imgItem) ? imgItem[1] : imgItem.url;
        } else {
          const vidItem = p.media.find(m => (Array.isArray(m) ? m[0] : m?.type) === "v");
          if (vidItem) {
            const vUrl = Array.isArray(vidItem) ? vidItem[1] : vidItem.url;
            const vPoster = Array.isArray(vidItem) ? vidItem[2] : vidItem.poster;
            url = vPoster || (vUrl && !vUrl.startsWith("http") ? vUrl.replace(/\.(mp4|webm)$/i, "") + ".webp" : "");
          }
        }
      }
    }
    return url ? resolveMediaPath(url) : ADMIN_TABLE_PLACEHOLDER;
  },

  /**
   * Returns readable label for a category slug/tag.
   */
  getCategoryLabel(tag) {
    const tLow = (tag || "").toLowerCase();
    const found = this.categories.find(c => c.slug.toLowerCase() === tLow || c.label.toLowerCase() === tLow);
    return found ? found.label : tag;
  },

  /**
   * Initializes event listeners and filters.
   */
  init() {
    this.bindEvents();
  },

  /**
   * Binds table search, filters, category creator, and editor events.
   */
  bindEvents() {
    // Search input
    const searchInput = document.getElementById("project-search-input");
    if (searchInput) {
      searchInput.addEventListener("input", () => this.renderTable());
    }

    // Category filter
    const catSelect = document.getElementById("filter-category-select");
    if (catSelect) {
      catSelect.addEventListener("change", () => this.renderTable());
    }

    // Status filter
    const statusSelect = document.getElementById("filter-status-select");
    if (statusSelect) {
      statusSelect.addEventListener("change", () => this.renderTable());
    }

    // Sort select
    const sortSelect = document.getElementById("filter-sort-select");
    if (sortSelect) {
      sortSelect.addEventListener("change", () => this.renderTable());
    }

    // Auto slug generator from name input
    const nameInput = document.getElementById("field-name");
    const slugInput = document.getElementById("field-slug");
    if (nameInput && slugInput) {
      nameInput.addEventListener("input", () => {
        // Only auto-update slug if creating new project or slug was previously empty
        if (!this.currentProject || !this.currentProject.id) {
          slugInput.value = this.slugify(nameInput.value);
        }
      });
    }

    // Status switch label toggle
    const statusSwitch = document.getElementById("field-status");
    const statusLabel = document.getElementById("status-label-text");
    if (statusSwitch && statusLabel) {
      statusSwitch.addEventListener("change", () => {
        if (statusSwitch.checked) {
          statusLabel.textContent = "Publicado no site";
          statusLabel.style.color = "var(--accent-green)";
        } else {
          statusLabel.textContent = "Rascunho (Oculto)";
          statusLabel.style.color = "var(--accent-amber)";
        }
      });
    }

    // Add category button
    const addCatBtn = document.getElementById("btn-add-category");
    const newCatInput = document.getElementById("input-new-category");
    if (addCatBtn && newCatInput) {
      addCatBtn.addEventListener("click", async () => {
        const val = newCatInput.value.trim();
        if (!val) return;
        const slug = this.slugify(val);
        if (slug && !this.categories.some(c => c.slug === slug)) {
          this.categories.push({ slug, label: val });
          // Keep selected checkboxes + add new one checked
          const selected = [...this.getSelectedCategories(), slug];
          this.renderCategoriesList(selected);
          this.populateCategoryFilter();
          newCatInput.value = "";
          // Persist category to Supabase if configured
          if (isSupabaseConfigured() && AdminAuth.isAuthenticated()) {
            try {
              await getSupabase().from("categories").upsert({
                slug,
                name: val,
                name_pt: val,
                name_en: val,
                display_order: this.categories.length
              }, { onConflict: "slug" });
            } catch (e) {
              console.warn("[ProjectsManager] Category save warning:", e);
            }
          }
          showToast(`Categoria "${val}" adicionada.`, "info");
        }
      });
    }

    // Add creative process block button
    const addProcBtn = document.getElementById("btn-add-proc-block");
    if (addProcBtn) {
      addProcBtn.addEventListener("click", () => {
        this.addProcBlock("", "", "", "");
      });
    }

    // Save project button
    const saveBtn = document.getElementById("btn-save-project");
    if (saveBtn) {
      saveBtn.addEventListener("click", () => this.saveProject());
    }
  },

  /**
   * Slugifies a text string safely.
   */
  slugify(text) {
    return (text || "")
      .toString()
      .toLowerCase()
      .normalize("NFD")
      .replace(/[\u0300-\u036f]/g, "") // remove accents
      .replace(/[^a-z0-9 -]/g, "") // remove invalid chars
      .trim()
      .replace(/\s+/g, "-") // collapse whitespace to -
      .replace(/-+/g, "-"); // collapse dashes
  },

  /**
   * Loads all projects from Supabase or fallback JSON.
   */
  async loadProjects() {
    let loaded = false;

    // 1. Try Supabase if configured
    if (isSupabaseConfigured()) {
      const client = getSupabase();
      if (client) {
        try {
          const { data, error } = await client
            .from("projects")
            .select("*")
            .order("display_order", { ascending: true });

          if (!error && Array.isArray(data)) {
            this.allProjects = data;
            loaded = true;
            console.log(`[ProjectsManager] Loaded ${data.length} projects from Supabase.`);
          }

          // Also load dynamic categories (supports name, name_pt, name_en, slug)
          const { data: catData } = await client.from("categories").select("slug, name_pt, name_en, name");
          if (Array.isArray(catData) && catData.length > 0) {
            catData.forEach(c => {
              const s = (c.slug || this.slugify(c.name_en || c.name_pt || c.name)).toLowerCase();
              const lbl = c.name || c.name_en || c.name_pt || s;
              if (s && !this.categories.some(existing => existing.slug === s)) {
                this.categories.push({ slug: s, label: lbl });
              }
            });
          }
        } catch (err) {
          console.warn("[ProjectsManager] Supabase query failed:", err);
        }
      }
    }

    // 2. Fallback to local JSON
    if (!loaded) {
      try {
        const res = await fetch("../data/legacy-projects.json");
        if (res.ok) {
          const json = await res.json();
          this.allProjects = json.projects || [];
          if (Array.isArray(json.categories)) {
            json.categories.forEach(cat => {
              const s = this.slugify(cat);
              if (s && !this.categories.some(existing => existing.slug === s)) {
                this.categories.push({ slug: s, label: cat });
              }
            });
          }
          console.log(`[ProjectsManager] Loaded ${this.allProjects.length} projects from legacy JSON.`);
        }
      } catch (err) {
        console.error("[ProjectsManager] Failed to load local JSON:", err);
      }
    }

    this.populateCategoryFilter();
    this.renderTable();
    this.updateDashboardMetrics();
    return this.allProjects;
  },

  /**
   * Populates category filter dropdown in table toolbar.
   */
  populateCategoryFilter() {
    const select = document.getElementById("filter-category-select");
    if (!select) return;

    const currentVal = select.value;
    select.innerHTML = '<option value="">Todas as Categorias</option>';

    this.categories.forEach(cat => {
      const opt = document.createElement("option");
      opt.value = cat.slug;
      opt.textContent = cat.label;
      select.appendChild(opt);
    });

    select.value = currentVal;
  },

  /**
   * Renders the projects data table according to active search, filters and sort.
   */
  renderTable() {
    const tbody = document.getElementById("projects-table-body");
    if (!tbody) return;

    const query = (document.getElementById("project-search-input")?.value || "").toLowerCase().trim();
    const catFilter = document.getElementById("filter-category-select")?.value || "";
    const statusFilter = document.getElementById("filter-status-select")?.value || "";
    const sortBy = document.getElementById("filter-sort-select")?.value || "order-asc";

    // Filter projects
    let filtered = this.allProjects.filter(p => {
      // Search text in name or slug
      const nameMatch = (p.name || "").toLowerCase().includes(query);
      const slugMatch = (p.slug || "").toLowerCase().includes(query);
      if (query && !nameMatch && !slugMatch) return false;

      // Category filter
      if (catFilter) {
        const tags = Array.isArray(p.tags) ? p.tags : [];
        if (!tags.includes(catFilter)) return false;
      }

      // Status filter
      if (statusFilter) {
        const st = p.status || "published";
        if (st !== statusFilter) return false;
      }

      return true;
    });

    // Sort projects
    filtered.sort((a, b) => {
      if (sortBy === "name-asc") {
        return (a.name || "").localeCompare(b.name || "");
      } else if (sortBy === "year-desc") {
        return Number(b.year || 0) - Number(a.year || 0);
      } else if (sortBy === "updated-desc") {
        return new Date(b.updated_at || 0) - new Date(a.updated_at || 0);
      } else {
        // order-asc (display_order)
        return Number(a.display_order || 0) - Number(b.display_order || 0);
      }
    });

    tbody.innerHTML = "";

    if (filtered.length === 0) {
      tbody.innerHTML = `
        <tr>
          <td colspan="7" style="text-align: center; padding: 40px; color: var(--text-subtle);">
            Nenhum projeto encontrado para os filtros selecionados.
          </td>
        </tr>
      `;
      return;
    }

    filtered.forEach(p => {
      const tr = document.createElement("tr");

      // Cover URL resolution
      const resolvedCover = this.getThumbUrl(p);

      // Category tags pills
      const tagsList = Array.isArray(p.tags) ? p.tags : [];
      const tagsHtml = tagsList.map(t => `<span class="tag-pill">${this.getCategoryLabel(t)}</span>`).join(" ");

      // Status badge
      const isPublished = (p.status || "published") === "published";
      const statusBadge = isPublished
        ? '<span class="badge badge-published">Publicado</span>'
        : '<span class="badge badge-draft">Rascunho</span>';

      // Featured badge
      const featuredBadge = p.featured
        ? `<span class="badge badge-featured">★ Home (#${p.featured_order || 0})</span>`
        : '<span style="color: var(--text-subtle); font-size: 11px;">—</span>';

      tr.innerHTML = `
        <td>
          <img src="${resolvedCover}" class="project-thumb" alt="${p.name}" onerror="this.onerror=null;this.src='${ADMIN_TABLE_PLACEHOLDER}'">
        </td>
        <td>
          <div class="project-info">
            <div class="title">${p.name}</div>
            <div class="slug">/${p.slug}</div>
          </div>
        </td>
        <td>
          <div style="display: flex; flex-wrap: wrap; gap: 4px;">
            ${tagsHtml || '<span style="color: var(--text-subtle); font-size: 11px;">Sem categoria</span>'}
          </div>
        </td>
        <td>
          <span style="font-family: var(--font-mono); font-size: 12px;">${p.year || "—"}</span>
        </td>
        <td>${statusBadge}</td>
        <td>${featuredBadge}</td>
        <td style="text-align: right;">
          <div style="display: inline-flex; gap: 6px;">
            <a href="#project-edit/${p.id || p.slug}" class="btn btn-sm" title="Editar Projeto">
              <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <path d="M12 20h9"/>
                <path d="M16.5 3.5a2.121 2.121 0 0 1 3 3L7 19l-4 1 1-4L16.5 3.5z"/>
              </svg>
              <span>Editar</span>
            </a>
            <button type="button" class="btn btn-sm btn-danger btn-delete-row" data-id="${p.id || p.slug}" title="Excluir Projeto">
              <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <polyline points="3 6 5 6 21 6"/>
                <path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"/>
              </svg>
            </button>
          </div>
        </td>
      `;

      // Delete listener
      const delBtn = tr.querySelector(".btn-delete-row");
      if (delBtn) {
        delBtn.addEventListener("click", (e) => {
          e.stopPropagation();
          this.deleteProject(p);
        });
      }

      tbody.appendChild(tr);
    });
  },

  /**
   * Opens project editor for a new project or an existing one by id/slug.
   */
  openEditor(idOrSlug) {
    const isNew = !idOrSlug || idOrSlug === "new";
    let proj = null;

    if (!isNew) {
      proj = this.allProjects.find(p => String(p.id) === String(idOrSlug) || p.slug === idOrSlug);
    }

    this.currentProject = proj || null;

    // Reset or populate fields
    document.getElementById("edit-project-id").value = proj ? (proj.id || "") : "";
    document.getElementById("edit-project-legacy-id").value = proj ? (proj.legacy_id || "") : "";
    document.getElementById("field-name").value = proj ? (proj.name || "") : "";
    document.getElementById("field-slug").value = proj ? (proj.slug || "") : "";
    document.getElementById("field-web-url").value = proj ? (proj.web_url || proj.web || "") : "";
    document.getElementById("field-year").value = proj ? (proj.year || new Date().getFullYear()) : new Date().getFullYear();
    document.getElementById("field-place").value = proj ? (proj.place || "") : "Buenos Aires";
    document.getElementById("field-display-order").value = proj ? (proj.display_order ?? this.allProjects.length + 1) : this.allProjects.length + 1;
    document.getElementById("field-featured-order").value = proj ? (proj.featured_order ?? 0) : 0;
    document.getElementById("field-caption-pt").value = proj ? (proj.caption_pt || proj.caption || "") : "";
    document.getElementById("field-caption-en").value = proj ? (proj.caption_en || "") : "";

    // Status switch
    const isPublished = proj ? (proj.status === "published" || !proj.status) : true;
    const statusSwitch = document.getElementById("field-status");
    const statusLabel = document.getElementById("status-label-text");
    if (statusSwitch) {
      statusSwitch.checked = isPublished;
      if (statusLabel) {
        statusLabel.textContent = isPublished ? "Publicado no site" : "Rascunho (Oculto)";
        statusLabel.style.color = isPublished ? "var(--accent-green)" : "var(--accent-amber)";
      }
    }

    // Featured switch
    const featuredSwitch = document.getElementById("field-featured");
    if (featuredSwitch) {
      featuredSwitch.checked = Boolean(proj && proj.featured);
    }

    // Initialize Media Gallery
    const mediaList = proj ? (proj.media || []) : [];
    const coverUrl = proj ? (proj.cover_url || "") : "";
    MediaManager.setMedia(mediaList, coverUrl, proj ? proj.slug : "temp");

    // Render Categories checkboxes
    this.renderCategoriesList(proj ? (proj.tags || []) : []);

    // Render Creative Process (PROC) blocks
    this.procBlocks = [];
    if (proj && proj.proc) {
      // Support array format or legacy PROC format
      if (Array.isArray(proj.proc.blocks)) {
        this.procBlocks = [...proj.proc.blocks];
      } else if (proj.proc.t) {
        // Legacy: { t: { "O Desafio": "...", "The Challenge": "..." } }
        const tObj = proj.proc.t;
        const keys = Object.keys(tObj);
        for (let i = 0; i < keys.length; i += 2) {
          this.procBlocks.push({
            title_pt: keys[i] || "Conceito",
            body_pt: tObj[keys[i]] || "",
            title_en: keys[i + 1] || "Concept",
            body_en: tObj[keys[i + 1]] || ""
          });
        }
      }
    }
    this.renderProcBlocks();
  },

  /**
   * Renders category chips in the editor form.
   */
  renderCategoriesList(selectedTags = []) {
    const container = document.getElementById("categories-checkbox-list");
    if (!container) return;

    container.innerHTML = "";

    const normSelected = (selectedTags || []).map(t => typeof t === "string" ? t.toLowerCase() : (t?.slug || ""));

    this.categories.forEach(cat => {
      const isChecked = normSelected.includes(cat.slug.toLowerCase()) || normSelected.includes(cat.label.toLowerCase());
      const label = document.createElement("label");
      label.className = `cat-chip ${isChecked ? "selected" : ""}`;
      label.innerHTML = `
        <input type="checkbox" value="${cat.slug}" ${isChecked ? "checked" : ""}>
        <span>${cat.label}</span>
      `;

      label.addEventListener("change", () => {
        const input = label.querySelector("input");
        if (input.checked) {
          label.classList.add("selected");
        } else {
          label.classList.remove("selected");
        }
      });

      container.appendChild(label);
    });
  },

  /**
   * Returns list of currently selected categories from editor.
   */
  getSelectedCategories() {
    const checked = document.querySelectorAll("#categories-checkbox-list input[type='checkbox']:checked");
    return Array.from(checked).map(c => c.value);
  },

  /**
   * Adds a new PROC block to the list.
   */
  addProcBlock(titlePt = "O Conceito", bodyPt = "", titleEn = "The Concept", bodyEn = "") {
    this.procBlocks.push({
      id: "b_" + Date.now() + "_" + Math.random().toString(36).substring(2, 6),
      title_pt: titlePt,
      body_pt: bodyPt,
      title_en: titleEn,
      body_en: bodyEn
    });
    this.renderProcBlocks();
  },

  /**
   * Renders the creative process blocks in the editor.
   */
  renderProcBlocks() {
    const container = document.getElementById("proc-blocks-container");
    if (!container) return;

    container.innerHTML = "";

    if (this.procBlocks.length === 0) {
      container.innerHTML = `
        <div style="text-align: center; padding: 18px; border: 1px dashed var(--border-medium); border-radius: var(--radius-md); font-size: 12px; color: var(--text-subtle);">
          Nenhum bloco de processo criativo cadastrado. Clique em "Adicionar Seção" acima caso deseje incluir texto detalhado na página individual deste projeto.
        </div>
      `;
      return;
    }

    this.procBlocks.forEach((block, index) => {
      const blockEl = document.createElement("div");
      blockEl.className = "proc-block";
      blockEl.innerHTML = `
        <div class="proc-block-header">
          <span style="font-weight: 700; font-size: 13px;">Seção #${index + 1}</span>
          <button type="button" class="btn btn-sm btn-danger btn-del-proc" data-index="${index}" title="Remover Bloco">
            <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
              <line x1="18" y1="6" x2="6" y2="18"/>
              <line x1="6" y1="6" x2="18" y2="18"/>
            </svg>
            <span>Remover</span>
          </button>
        </div>
        <div class="form-row">
          <div class="form-group">
            <label style="font-size: 11px;">Título (Português)</label>
            <input type="text" class="form-control proc-title-pt" value="${block.title_pt || ""}" placeholder="ex: O Desafio">
          </div>
          <div class="form-group">
            <label style="font-size: 11px;">Título (Inglês)</label>
            <input type="text" class="form-control proc-title-en" value="${block.title_en || ""}" placeholder="ex: The Challenge">
          </div>
        </div>
        <div class="form-row">
          <div class="form-group">
            <label style="font-size: 11px;">Conteúdo (Português)</label>
            <textarea class="form-control proc-body-pt" rows="2" placeholder="Descrição do processo em português...">${block.body_pt || ""}</textarea>
          </div>
          <div class="form-group">
            <label style="font-size: 11px;">Conteúdo (Inglês)</label>
            <textarea class="form-control proc-body-en" rows="2" placeholder="Process description in English...">${block.body_en || ""}</textarea>
          </div>
        </div>
      `;

      // Live update values
      blockEl.querySelector(".proc-title-pt").addEventListener("input", (e) => { block.title_pt = e.target.value; });
      blockEl.querySelector(".proc-title-en").addEventListener("input", (e) => { block.title_en = e.target.value; });
      blockEl.querySelector(".proc-body-pt").addEventListener("input", (e) => { block.body_pt = e.target.value; });
      blockEl.querySelector(".proc-body-en").addEventListener("input", (e) => { block.body_en = e.target.value; });

      // Delete block listener
      blockEl.querySelector(".btn-del-proc").addEventListener("click", () => {
        this.procBlocks.splice(index, 1);
        this.renderProcBlocks();
      });

      container.appendChild(blockEl);
    });
  },

  /**
   * Saves the current project form data to Supabase (or fallback local state).
   */
  async saveProject() {
    const saveBtn = document.getElementById("btn-save-project");
    const name = document.getElementById("field-name").value.trim();
    let slug = document.getElementById("field-slug").value.trim();

    if (!name) {
      showToast("Por favor, informe o nome do projeto.", "error");
      document.getElementById("field-name").focus();
      return;
    }

    if (!slug) {
      slug = this.slugify(name);
      document.getElementById("field-slug").value = slug;
    }

    // Check slug uniqueness
    const currentId = document.getElementById("edit-project-id").value;
    const slugCollision = this.allProjects.find(p => p.slug === slug && String(p.id) !== String(currentId));
    if (slugCollision) {
      showToast(`O slug "${slug}" já está em uso pelo projeto "${slugCollision.name}". Escolha outro slug.`, "error");
      document.getElementById("field-slug").focus();
      return;
    }

    if (saveBtn) {
      saveBtn.disabled = true;
      saveBtn.textContent = "Salvando...";
    }

    const legacyId = document.getElementById("edit-project-legacy-id").value;
    const webUrl = document.getElementById("field-web-url").value.trim();
    const year = document.getElementById("field-year").value.trim();
    const place = document.getElementById("field-place").value.trim();
    const displayOrder = parseInt(document.getElementById("field-display-order").value, 10) || 0;
    const featuredOrder = parseInt(document.getElementById("field-featured-order").value, 10) || 0;
    const captionPt = document.getElementById("field-caption-pt").value.trim();
    const captionEn = document.getElementById("field-caption-en").value.trim();
    const status = document.getElementById("field-status").checked ? "published" : "draft";
    const featured = document.getElementById("field-featured").checked;
    const tags = this.getSelectedCategories();
    const media = MediaManager.getMedia();
    const coverUrl = MediaManager.getCoverUrl();

    // Prepare PROC data
    const procData = {
      blocks: this.procBlocks.filter(b => b.title_pt || b.body_pt)
    };

    // If existing project had brandbook boards (bb), preserve them
    if (this.currentProject && this.currentProject.proc && this.currentProject.proc.bb) {
      procData.bb = this.currentProject.proc.bb;
    }

    const payload = {
      name,
      slug,
      year,
      place,
      place_pt: place,
      place_en: place,
      web_url: webUrl,
      display_order: displayOrder,
      featured_order: featuredOrder,
      caption_pt: captionPt,
      caption_en: captionEn,
      status,
      featured,
      tags,
      media,
      cover_url: coverUrl,
      proc: procData,
      updated_at: new Date().toISOString()
    };

    if (currentId) {
      payload.id = currentId;
    }
    if (legacyId) {
      payload.legacy_id = parseInt(legacyId, 10);
    }

    let success = false;

    // 1. Persist to Supabase if available
    if (isSupabaseConfigured() && AdminAuth.isAuthenticated()) {
      try {
        const client = getSupabase();
        const { data, error } = await client
          .from("projects")
          .upsert(payload)
          .select()
          .single();

        if (error) throw error;

        // Update local item
        const existingIdx = this.allProjects.findIndex(p => 
          (data.id && p.id === data.id) || 
          p.slug === data.slug || 
          (currentId && (String(p.id) === String(currentId) || p.slug === currentId))
        );
        if (existingIdx >= 0) {
          this.allProjects[existingIdx] = data;
        } else {
          this.allProjects.unshift(data);
        }
        success = true;
      } catch (err) {
        console.error("[ProjectsManager] Supabase save error:", err);
        showToast(`Erro ao salvar no banco: ${err.message}`, "error");
      }
    } else {
      // Local fallback mode
      if (currentId) {
        const idx = this.allProjects.findIndex(p => String(p.id) === String(currentId));
        if (idx >= 0) this.allProjects[idx] = { ...this.allProjects[idx], ...payload };
      } else {
        payload.id = "local_" + Date.now();
        this.allProjects.unshift(payload);
      }
      success = true;
      showToast("Projeto salvo localmente (Supabase não conectado).", "info");
    }

    if (saveBtn) {
      saveBtn.disabled = false;
      saveBtn.textContent = "Salvar Projeto";
    }

    if (success) {
      try { localStorage.removeItem("jr_portfolio_cache_v2"); } catch (_) {}
      showToast("Projeto salvo com sucesso!", "success");
      this.updateDashboardMetrics();
      window.location.hash = "#projects";
    }
  },

  /**
   * Deletes a project with confirmation.
   */
  async deleteProject(proj) {
    if (!confirm(`Tem certeza que deseja excluir permanentemente o projeto "${proj.name}"?`)) {
      return;
    }

    let success = false;

    if (isSupabaseConfigured() && AdminAuth.isAuthenticated()) {
      try {
        const client = getSupabase();
        const { error } = await client
          .from("projects")
          .delete()
          .eq("id", proj.id);

        if (error) throw error;
        success = true;
      } catch (err) {
        console.error("[ProjectsManager] Delete error:", err);
        showToast(`Erro ao excluir: ${err.message}`, "error");
      }
    } else {
      success = true;
    }

    if (success) {
      try { localStorage.removeItem("jr_portfolio_cache_v2"); } catch (_) {}
      this.allProjects = this.allProjects.filter(p => p.id !== proj.id && p.slug !== proj.slug);
      this.renderTable();
      this.updateDashboardMetrics();
      showToast(`Projeto "${proj.name}" excluído.`, "info");
    }
  },

  /**
   * Updates dashboard metrics cards based on current projects.
   */
  updateDashboardMetrics() {
    const totalEl = document.getElementById("stat-total-projects");
    const pubEl = document.getElementById("stat-published-projects");
    const draftEl = document.getElementById("stat-draft-projects");
    const featEl = document.getElementById("stat-featured-projects");
    const heroEl = document.getElementById("stat-hero-projects");

    const total = this.allProjects.length;
    const published = this.allProjects.filter(p => (p.status || "published") === "published").length;
    const drafts = this.allProjects.filter(p => p.status === "draft").length;
    const featured = this.allProjects.filter(p => p.featured).length;

    if (totalEl) totalEl.textContent = total;
    if (pubEl) pubEl.textContent = published;
    if (draftEl) draftEl.textContent = drafts;
    if (featEl) featEl.textContent = featured;
    if (heroEl) heroEl.textContent = published;

    // Render recent projects table on dashboard
    const recentContainer = document.getElementById("dashboard-recent-projects");
    if (recentContainer) {
      const recents = [...this.allProjects].slice(0, 5);
      let html = '<table class="projects-table"><tbody>';
      recents.forEach(p => {
        const cover = this.getThumbUrl(p);
        html += `
          <tr>
            <td style="width: 50px;"><img src="${cover}" class="project-thumb" alt="${p.name}" onerror="this.onerror=null;this.src='${ADMIN_TABLE_PLACEHOLDER}'"></td>
            <td><strong>${p.name}</strong><div style="font-size: 11px; color: var(--text-subtle);">${p.slug}</div></td>
            <td><span class="badge ${p.status === 'draft' ? 'badge-draft' : 'badge-published'}">${p.status || 'published'}</span></td>
            <td style="text-align: right;"><a href="#project-edit/${p.id || p.slug}" class="btn btn-sm">Editar</a></td>
          </tr>
        `;
      });
      html += '</tbody></table>';
      recentContainer.innerHTML = html;
    }
  }
};

window.ProjectsManager = ProjectsManager;
