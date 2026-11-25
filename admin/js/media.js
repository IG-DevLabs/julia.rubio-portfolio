/**
 * Júlia Rubio Portfolio CMS - Media Manager
 * Handles multi-file upload to Supabase Storage ('portfolio' bucket),
 * media reordering, cover selection, and legacy path preservation.
 */

const ADMIN_IMG_PLACEHOLDER = "data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 120 120'%3E%3Crect width='120' height='120' fill='%23f5f4f1'/%3E%3Cpath d='M42 78l14-18 11 14 8-10 13 14H42z' fill='%23d4d1ca'/%3E%3Ccircle cx='50' cy='46' r='6' fill='%23d4d1ca'/%3E%3C/svg%3E";

function normalizeUrlForCompare(u) {
  return (u || "").trim().replace(/^\.\.\//, "").replace(/^\.\//, "").replace(/^\//, "").replace(/#t=.*$/, "");
}

const MediaManager = {
  items: [], // Array of { type: 'i'|'v'|'w', url: string, poster?: string, scrollPct?: number, isCover: boolean, id: string }
  currentSlug: "temp",
  sortableInstance: null,

  /**
   * Initializes dropzone, file input, and Sortable instance.
   */
  init() {
    this.bindDropzone();
  },

  /**
   * Loads media list and cover for an existing or new project.
   *
   * @param {Array} mediaList - Array of tuples [type, url, extra] or objects
   * @param {string} coverUrl - Resolved cover URL or relative path
   * @param {string} projectSlug - Slug used for folder names in Supabase Storage
   */
  setMedia(mediaList, coverUrl, projectSlug = "temp") {
    this.currentSlug = projectSlug || "temp";
    this.items = [];
    const normCover = normalizeUrlForCompare(coverUrl);

    if (Array.isArray(mediaList)) {
      mediaList.forEach((m) => {
        let type = "i";
        let url = "";
        let poster = "";
        let scrollPct = 50;

        if (Array.isArray(m)) {
          // Legacy tuple [type, url, extra]
          type = m[0];
          url = m[1] || "";
          if (type === "w") {
            scrollPct = m[2] || 50;
          } else if (type === "v") {
            poster = m[2] || "";
            if (!/\.(mp4|webm)$/i.test(url) && !url.startsWith("http")) {
              url = url + ".mp4";
            }
          }
        } else if (m && typeof m === "object") {
          type = m.type || "i";
          url = m.url || "";
          poster = m.poster || "";
          scrollPct = m.scrollPct || 50;
        }

        const cleanUrl = url.trim();
        const normUrl = normalizeUrlForCompare(cleanUrl);
        const normPoster = normalizeUrlForCompare(poster);
        const isCover = Boolean(
          normCover && (
            (normUrl && normUrl === normCover && type !== "v") ||
            (normPoster && normPoster === normCover)
          )
        );

        this.items.push({
          id: "m_" + Date.now() + "_" + Math.random().toString(36).substring(2, 7),
          type,
          url: cleanUrl,
          poster,
          scrollPct,
          isCover
        });
      });
    }

    // Ensure exactly one non-video cover exists if items exist
    if (this.items.length > 0 && !this.items.some(it => it.isCover)) {
      const firstImg = this.items.find(it => it.type !== "v") || this.items[0];
      firstImg.isCover = true;
    }

    this.renderGrid();
  },

  /**
   * Returns current media array formatted for database/JSON saving.
   */
  getMedia() {
    return this.items.map(it => {
      if (it.type === "w") {
        return ["w", it.url, it.scrollPct || 50];
      } else if (it.type === "v") {
        const cleanVid = it.url.startsWith("http") ? it.url : it.url.replace(/\.mp4$/i, "");
        return ["v", cleanVid, it.poster || ""];
      } else {
        return ["i", it.url];
      }
    });
  },

  /**
   * Returns URL of currently selected cover (always prefers image/poster over raw video).
   */
  getCoverUrl() {
    const coverItem = this.items.find(it => it.isCover);
    const target = coverItem || this.items.find(it => it.type !== "v") || this.items[0];
    if (!target) return "";
    if (target.type === "v") {
      if (target.poster) return target.poster;
      if (!target.url.startsWith("http")) return target.url.replace(/\.(mp4|webm)$/i, ".webp");
    }
    return target.url;
  },

  /**
   * Binds drag and drop and file input events.
   */
  bindDropzone() {
    const dropzone = document.getElementById("media-dropzone");
    const fileInput = document.getElementById("media-file-input");

    if (!dropzone || !fileInput) return;

    dropzone.addEventListener("click", () => {
      fileInput.click();
    });

    fileInput.addEventListener("change", async (e) => {
      if (e.target.files && e.target.files.length > 0) {
        await this.handleFiles(Array.from(e.target.files));
        fileInput.value = ""; // Reset
      }
    });

    ["dragenter", "dragover"].forEach(eventName => {
      dropzone.addEventListener(eventName, (e) => {
        e.preventDefault();
        e.stopPropagation();
        dropzone.classList.add("dragover");
      });
    });

    ["dragleave", "drop"].forEach(eventName => {
      dropzone.addEventListener(eventName, (e) => {
        e.preventDefault();
        e.stopPropagation();
        dropzone.classList.remove("dragover");
      });
    });

    dropzone.addEventListener("drop", async (e) => {
      if (e.dataTransfer && e.dataTransfer.files && e.dataTransfer.files.length > 0) {
        await this.handleFiles(Array.from(e.dataTransfer.files));
      }
    });
  },

  /**
   * Handles uploading a batch of files to Supabase Storage.
   */
  async handleFiles(files) {
    if (!isSupabaseConfigured()) {
      showToast("Supabase não configurado. As mídias locais existentes serão preservadas, mas novos uploads necessitam do Supabase Storage.", "error");
      return;
    }

    const progressContainer = document.getElementById("media-upload-progress");
    const progressFill = document.getElementById("upload-progress-fill");
    const progressText = document.getElementById("upload-pct-text");
    const statusText = document.getElementById("upload-status-text");

    if (progressContainer) progressContainer.style.display = "block";

    const total = files.length;
    let completed = 0;
    const folder = `projects/${this.currentSlug || "gallery"}`;

    for (const file of files) {
      try {
        if (statusText) statusText.textContent = `Enviando ${file.name} (${completed + 1}/${total})...`;
        
        const uploadResult = await uploadPortfolioMedia(file, folder);
        
        const hasValidImageCover = this.items.some(it => it.isCover && it.type !== "v");
        const shouldBeCover = uploadResult.type !== "v" ? !hasValidImageCover : this.items.length === 0;
        if (shouldBeCover) {
          this.items.forEach(it => { it.isCover = false; });
        }

        this.items.push({
          id: "m_" + Date.now() + "_" + Math.random().toString(36).substring(2, 7),
          type: uploadResult.type,
          url: uploadResult.url,
          isCover: shouldBeCover
        });

        completed++;
        const pct = Math.round((completed / total) * 100);
        if (progressFill) progressFill.style.width = pct + "%";
        if (progressText) progressText.textContent = pct + "%";
      } catch (err) {
        console.error("[MediaManager] File upload error:", err);
        showToast(`Erro ao enviar "${file.name}": ${err.message}`, "error");
      }
    }

    if (progressContainer) {
      setTimeout(() => {
        progressContainer.style.display = "none";
        if (progressFill) progressFill.style.width = "0%";
      }, 800);
    }

    showToast(`${completed} mídia(s) enviada(s) com sucesso!`, "success");
    this.renderGrid();
  },

  /**
   * Renders the media cards in the grid and attaches reorder handles.
   */
  renderGrid() {
    const gridEl = document.getElementById("media-items-grid");
    if (!gridEl) return;

    gridEl.innerHTML = "";

    if (this.items.length === 0) {
      gridEl.innerHTML = `
        <div style="grid-column: 1 / -1; text-align: center; padding: 20px; color: var(--text-subtle); font-size: 13px;">
          Nenhuma mídia adicionada ainda. Arraste arquivos acima para adicionar à galeria deste projeto.
        </div>
      `;
      return;
    }

    this.items.forEach((item, index) => {
      const card = document.createElement("div");
      card.className = `media-item ${item.isCover ? "is-cover" : ""}`;
      card.dataset.index = index;
      card.dataset.id = item.id;

      // Resolve display path
      const displayUrl = resolveMediaPath(item.url);

      let mediaTag = "";
      if (item.type === "v") {
        const posterAttr = item.poster ? `poster="${resolveMediaPath(item.poster)}"` : "";
        mediaTag = `
          <video src="${displayUrl}" ${posterAttr} muted playsinline loop style="width: 100%; height: 100%; object-fit: cover;"></video>
          <div style="position: absolute; top: 6px; right: 6px; background: rgba(0,0,0,0.6); color: #fff; font-size: 9px; padding: 2px 5px; border-radius: 4px; font-weight: bold;">MP4</div>
        `;
      } else {
        mediaTag = `<img src="${displayUrl}" alt="Mídia ${index + 1}" loading="lazy" style="width: 100%; height: 100%; object-fit: cover;" onerror="this.onerror=null;this.src='${ADMIN_IMG_PLACEHOLDER}'">`;
      }

      const canBeCover = item.type !== "v" || Boolean(item.poster) || !item.url.startsWith("http");

      card.innerHTML = `
        ${mediaTag}
        ${item.isCover ? '<span class="media-cover-badge">★ CAPA</span>' : ""}
        <div class="media-actions">
          ${canBeCover ? `
          <button type="button" class="media-action-btn btn-make-cover" title="Definir como Imagem de Capa" data-index="${index}">
            <svg width="12" height="12" viewBox="0 0 24 24" fill="${item.isCover ? 'currentColor' : 'none'}" stroke="currentColor" stroke-width="2">
              <polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"/>
            </svg>
          </button>` : ""}
          <button type="button" class="media-action-btn btn-delete-media" title="Remover Mídia" data-index="${index}" style="color: var(--accent-red);">
            <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
              <polyline points="3 6 5 6 21 6"/>
              <path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"/>
            </svg>
          </button>
        </div>
      `;

      // Make cover listener
      const coverBtn = card.querySelector(".btn-make-cover");
      if (coverBtn) {
        coverBtn.addEventListener("click", (e) => {
          e.stopPropagation();
          this.setCover(index);
        });
      }

      // Delete listener
      const deleteBtn = card.querySelector(".btn-delete-media");
      if (deleteBtn) {
        deleteBtn.addEventListener("click", (e) => {
          e.stopPropagation();
          this.removeMedia(index);
        });
      }

      gridEl.appendChild(card);
    });

    // Initialize SortableJS
    if (window.Sortable && !this.sortableInstance) {
      this.sortableInstance = Sortable.create(gridEl, {
        animation: 180,
        ghostClass: "sortable-ghost",
        onEnd: (evt) => {
          // Reorder items array to match DOM
          const moved = this.items.splice(evt.oldIndex, 1)[0];
          this.items.splice(evt.newIndex, 0, moved);
          this.renderGrid();
        }
      });
    }
  },

  /**
   * Sets a specific item as the project cover.
   */
  setCover(index) {
    const target = this.items[index];
    if (!target) return;
    if (target.type === "v" && !target.poster && target.url.startsWith("http")) {
      showToast("Escolha uma imagem estática para ser a capa do projeto.", "error");
      return;
    }
    this.items.forEach((it, i) => {
      it.isCover = (i === index);
    });
    this.renderGrid();
    showToast("Imagem de capa atualizada! Clique em 'Salvar Projeto' para confirmar.", "info");
  },

  /**
   * Removes a media item from the list.
   */
  async removeMedia(index) {
    const item = this.items[index];
    if (!item) return;

    if (!confirm("Tem certeza que deseja remover esta mídia da galeria?")) {
      return;
    }

    const wasCover = item.isCover;
    this.items.splice(index, 1);

    // If removed item was cover, assign cover to first remaining image
    if (wasCover && this.items.length > 0) {
      const nextImg = this.items.find(it => it.type !== "v") || this.items[0];
      nextImg.isCover = true;
    }

    this.renderGrid();
    showToast("Mídia removida.", "info");
  }
};

window.MediaManager = MediaManager;
