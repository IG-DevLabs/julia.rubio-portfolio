/**
 * Júlia Rubio Portfolio CMS - Admin Auth Module
 * Handles Supabase Authentication, user sessions, login/logout,
 * and interface visibility protection.
 */

const AdminAuth = {
  currentUser: null,
  currentSession: null,

  /**
   * Initializes auth state, attaches listeners and verifies active session.
   */
  async init() {
    this.bindEvents();

    // Check if Supabase client is configured
    if (!isSupabaseConfigured()) {
      console.warn("[AdminAuth] Supabase is not configured yet. Prompting configuration or login.");
      // If no credentials exist, allow navigation to #settings view so user can configure it
      if (window.location.hash !== "#settings") {
        this.showLoginView("Supabase não configurado. Insira suas credenciais em Configurações para conectar o CMS.");
      }
      return false;
    }

    const client = getSupabase();
    if (!client) {
      this.showLoginView("Não foi possível inicializar o cliente Supabase.");
      return false;
    }

    try {
      // 1. Get current session
      const { data: sessionData, error: sessionErr } = await client.auth.getSession();
      if (sessionErr) throw sessionErr;

      if (sessionData && sessionData.session) {
        this.setSession(sessionData.session);
      } else {
        this.setSession(null);
      }

      // 2. Listen to auth state changes (LOGIN, LOGOUT, TOKEN_REFRESHED)
      client.auth.onAuthStateChange((event, session) => {
        console.log(`[AdminAuth] Auth state changed: ${event}`);
        if (event === "SIGNED_IN" || event === "TOKEN_REFRESHED") {
          this.setSession(session);
        } else if (event === "SIGNED_OUT") {
          this.setSession(null);
        }
      });

      return Boolean(this.currentUser);
    } catch (err) {
      console.error("[AdminAuth] Error checking session:", err);
      this.setSession(null);
      return false;
    }
  },

  /**
   * Binds UI events for login form and logout button.
   */
  bindEvents() {
    const loginForm = document.getElementById("form-login");
    const logoutBtn = document.getElementById("btn-logout");
    const settingsLink = document.getElementById("link-login-settings");

    if (loginForm) {
      loginForm.addEventListener("submit", async (e) => {
        e.preventDefault();
        const email = document.getElementById("login-email").value.trim();
        const password = document.getElementById("login-password").value;
        await this.login(email, password);
      });
    }

    if (logoutBtn) {
      logoutBtn.addEventListener("click", async () => {
        await this.logout();
      });
    }

    if (settingsLink) {
      settingsLink.addEventListener("click", () => {
        this.hideLoginView();
        window.location.hash = "#settings";
      });
    }
  },

  /**
   * Updates internal session state and toggles UI.
   */
  setSession(session) {
    this.currentSession = session;
    this.currentUser = session ? session.user : null;

    if (this.currentUser) {
      this.hideLoginView();
      this.updateUserUI(this.currentUser);
    } else {
      this.showLoginView();
    }

    // Dispatch global event for other admin modules
    document.dispatchEvent(new CustomEvent("admin:auth-changed", {
      detail: {
        isAuthenticated: Boolean(this.currentUser),
        user: this.currentUser,
        session: this.currentSession
      }
    }));
  },

  /**
   * Performs login with email and password via Supabase Auth.
   */
  async login(email, password) {
    const errorEl = document.getElementById("login-error");
    const submitBtn = document.getElementById("btn-login-submit");

    if (errorEl) errorEl.style.display = "none";
    if (submitBtn) {
      submitBtn.disabled = true;
      submitBtn.textContent = "Autenticando...";
    }

    const client = getSupabase();
    if (!client) {
      this.showLoginError("Supabase não configurado. Adicione URL e Anon Key em Configurações.");
      if (submitBtn) {
        submitBtn.disabled = false;
        submitBtn.textContent = "Entrar no Painel";
      }
      return;
    }

    try {
      const { data, error } = await client.auth.signInWithPassword({
        email: email,
        password: password
      });

      if (error) throw error;

      if (data && data.user) {
        this.setSession(data.session);
        if (typeof showToast === "function") {
          showToast("Login realizado com sucesso!", "success");
        }
      }
    } catch (err) {
      console.error("[AdminAuth] Login error:", err);
      let msg = "Credenciais inválidas. Verifique seu e-mail e senha.";
      if (err.message && err.message.includes("Email not confirmed")) {
        msg = "E-mail não confirmado no Supabase. Confirme o usuário nas configurações de Auth.";
      } else if (err.message) {
        msg = err.message;
      }
      this.showLoginError(msg);
    } finally {
      if (submitBtn) {
        submitBtn.disabled = false;
        submitBtn.textContent = "Entrar no Painel";
      }
    }
  },

  /**
   * Signs the current user out.
   */
  async logout() {
    const client = getSupabase();
    if (client) {
      try {
        await client.auth.signOut();
      } catch (err) {
        console.warn("[AdminAuth] Logout error:", err);
      }
    }
    this.setSession(null);
    if (typeof showToast === "function") {
      showToast("Você saiu do painel.", "info");
    }
  },

  /**
   * Displays the login modal/overlay.
   */
  showLoginView(warningMsg) {
    const view = document.getElementById("view-login");
    const errorEl = document.getElementById("login-error");
    if (view) view.style.display = "flex";
    if (warningMsg && errorEl) {
      errorEl.textContent = warningMsg;
      errorEl.style.display = "block";
    }
  },

  /**
   * Hides the login modal/overlay.
   */
  hideLoginView() {
    const view = document.getElementById("view-login");
    if (view) view.style.display = "none";
  },

  /**
   * Displays an error message inside login form.
   */
  showLoginError(msg) {
    const errorEl = document.getElementById("login-error");
    if (errorEl) {
      errorEl.textContent = msg;
      errorEl.style.display = "block";
    }
  },

  /**
   * Updates sidebar user info with current user metadata.
   */
  updateUserUI(user) {
    const nameEl = document.getElementById("user-display-name");
    const emailEl = document.getElementById("user-email-display");
    const avatarEl = document.getElementById("user-avatar");

    const email = user.email || "admin@juliarubio.com";
    const name = user.user_metadata?.full_name || email.split("@")[0] || "Administradora";

    if (nameEl) nameEl.textContent = name;
    if (emailEl) emailEl.textContent = email;
    if (avatarEl) {
      avatarEl.textContent = name.slice(0, 2).toUpperCase();
    }
  },

  /**
   * Returns whether a user is currently authenticated.
   */
  isAuthenticated() {
    return Boolean(this.currentUser);
  }
};

window.AdminAuth = AdminAuth;
