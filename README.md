# Júlia Rubio — Portfolio & CMS

Portfólio profissional e editorial da designer gráfica **Júlia Rubio** (Sorocaba, SP — Brasil), acompanhado de um CMS estático integrado ao **Supabase** e pronto para deploy gratuito no **GitHub Pages**.

---

## 🌟 Destaques do Projeto

- **Frontend Editorial de Alta Performance**: Desenvolvido em HTML5, CSS3 moderno e Vanilla JavaScript, com animações fluidas, carrossel de capa interativo, suporte bilíngue (Português / Inglês) e design responsivo.
- **CMS Integrado (`/admin/`)**: Painel administrativo minimalista com design moderno inspirado em Linear, Notion e Apple para gerenciar projetos, fazer upload de mídias e reordenar destaques da página inicial.
- **Backend Serverless com Supabase**:
  - **Supabase Auth**: Login administrativo seguro.
  - **PostgreSQL Database**: Armazenamento relacional com suporte a JSONB para mídias e blocos de processo criativo.
  - **Supabase Storage**: Bucket `portfolio` para armazenamento de imagens e vídeos MP4 em alta resolução.
  - **Row Level Security (RLS)**: Leitura pública para projetos publicados; permissões de criação, alteração e exclusão estritamente restritas a administradores autenticados.
- **Resiliência & Fallback Automático**: O site nunca fica fora do ar ou em branco. Caso o Supabase não esteja configurado ou sem conexão, o sistema consome instantaneamente `data/legacy-projects.json`.

---

## 📁 Estrutura do Repositório

```text
julia.rubio-portfolio/
├── admin/                     # Painel Administrativo CMS
│   ├── css/
│   │   └── admin.css          # Design system minimalista
│   ├── js/
│   │   ├── admin.js           # Router hash, dashboard e configurações
│   │   ├── auth.js            # Autenticação e sessão com Supabase Auth
│   │   ├── media.js           # Drag-and-drop upload e galeria de mídias
│   │   └── projects.js        # CRUD completo de projetos e blocos PROC
│   └── index.html             # Shell da interface do painel
│
├── assets/                    # Recursos públicos do portfólio
│   ├── css/                   # Estilos globais e fontes
│   ├── icons/                 # Favicons e ícones
│   ├── images/                # Imagens dos projetos originais
│   ├── js/
│   │   ├── portfolio-data.js  # Camada de dados e sincronização
│   │   └── supabase-client.js # Cliente singleton do Supabase e Storage
│   └── media/                 # Vídeos MP4 e posters originais
│
├── data/
│   └── legacy-projects.json   # Backup completo e normalizado de todos os 36 projetos
│
├── supabase/
│   ├── complete_setup.sql            # Script unificado (schema + seed em 1 clique)
│   ├── migrations/
│   │   └── 01_create_cms_schema.sql  # Schema SQL (tabelas, RLS, triggers, bucket)
│   └── seed/
│       └── seed.sql                  # Importação de todos os 36 projetos no banco
│
├── index.html                 # Página principal do portfólio público
├── SUPABASE_SETUP.md          # Manual de configuração do Supabase passo a passo
└── README.md                  # Documentação do projeto
```

---

## 🚀 Como Executar Localmente

Você não precisa de Node.js, compilação ou bundlers (como Vite ou Webpack) para rodar este projeto. É 100% estático.

1. Clone o repositório:
   ```bash
   git clone https://github.com/seu-usuario/julia.rubio-portfolio.git
   cd julia.rubio-portfolio
   ```

2. Inicie qualquer servidor HTTP estático local, por exemplo com Python ou Node:
   ```bash
   # Com Python:
   python -m http.server 3000

   # Ou com npx serve:
   npx serve .
   ```

3. Abra no navegador:
   - **Portfólio**: [http://localhost:3000/](http://localhost:3000/)
   - **Painel CMS**: [http://localhost:3000/admin/](http://localhost:3000/admin/)

---

## ⚙️ Configuração do Supabase

Para conectar o CMS ao seu projeto Supabase, siga o guia detalhado em **[`SUPABASE_SETUP.md`](SUPABASE_SETUP.md)**.

Em resumo:
1. Crie o projeto em [supabase.com](https://supabase.com).
2. Execute o SQL de [`supabase/migrations/01_create_cms_schema.sql`](supabase/migrations/01_create_cms_schema.sql).
3. Execute o SQL de [`supabase/seed/seed.sql`](supabase/seed/seed.sql).
4. Crie o usuário da Júlia em **Authentication** > **Users**.
5. Insira a **Project URL** e a **Anon Key** no painel `/admin/#settings`.

---

## 🌐 Publicação no GitHub Pages

1. Envie suas alterações para o repositório:
   ```bash
   git add .
   git commit -m "feat: portfolio and cms setup"
   git push origin main
   ```
2. No repositório GitHub, acesse **Settings** > **Pages**.
3. Selecione a branch `main` e a pasta `/ (root)`.
4. Em instantes o site estará publicado e acessível globalmente.
