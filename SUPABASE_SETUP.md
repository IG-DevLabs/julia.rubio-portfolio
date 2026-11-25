# Guia de Configuração do Supabase & CMS — Portfólio Júlia Rubio

Este guia fornece o passo a passo completo e descomplicado para configurar o backend do CMS no **Supabase** e colocá-lo em funcionamento integrado ao portfólio no **GitHub Pages**.

---

## 1. Visão Geral da Arquitetura

- **Frontend Público (`/`)**: Portfólio editorial estático em HTML, CSS e JavaScript puro, hospedado gratuitamente no GitHub Pages.
- **Painel Administrativo (`/admin/`)**: Interface independente de gerenciamento inspirada em Linear, Notion e Apple, com autenticação, listagem de projetos, upload de mídias por drag-and-drop, ordenação dos destaques e configurações.
- **Backend (Supabase Gratuito)**:
  - **Auth**: Autenticação segura por e-mail e senha.
  - **PostgreSQL**: Banco relacional para projetos, categorias e configurações.
  - **Storage**: Armazenamento em nuvem no bucket `portfolio` para fotos e vídeos enviados.
  - **Row Level Security (RLS)**: Proteção onde visitantes anônimos só conseguem **ler** projetos publicados (`published`), enquanto apenas usuários autenticados têm permissão total de escrita, edição e exclusão.
- **Resiliência Total (Offline/Fallback)**: Se o Supabase estiver fora do ar ou ainda não configurado, o site público carrega instantaneamente todos os 36 projetos a partir do arquivo local `data/legacy-projects.json`.

---

## 2. Passo a Passo de Configuração

### Passo 1: Criar o Projeto no Supabase
1. Acesse [supabase.com](https://supabase.com) e crie uma conta gratuita (ou faça login com o GitHub).
2. Clique em **"New Project"**.
3. Preencha as informações:
   - **Name**: `julia-rubio-portfolio` (ou o nome que preferir)
   - **Database Password**: Escolha uma senha segura e guarde-a.
   - **Region**: Selecione uma região próxima (ex: `South America (São Paulo)` ou `East US`).
4. Clique em **"Create new project"** e aguarde cerca de 1 a 2 minutos até que o provisionamento finalize.

---

### Passo 2: Executar o Script de Configuração Completa (Recomendado - 1 Clique)

Para facilitar e evitar qualquer erro de ordem de execução ou tabelas não encontradas, preparamos o arquivo unificado **[`supabase/complete_setup.sql`](supabase/complete_setup.sql)**, que executa a criação de todas as tabelas, índices, regras de segurança RLS, Storage e a carga inicial de todos os 36 projetos em um único clique:

1. No menu lateral esquerdo do Supabase, clique em **SQL Editor** (ícone `>_`).
2. Clique em **"New Query"**.
3. Abra o arquivo [`supabase/complete_setup.sql`](supabase/complete_setup.sql) deste repositório, copie todo o seu conteúdo e cole no editor do Supabase.
4. Certifique-se de que **nenhum texto esteja selecionado** (para que o script inteiro seja executado) e clique no botão **"Run"** (ou aperte `Ctrl + Enter`).
5. Você verá a mensagem de sucesso `Success. No rows returned`.

> 💡 **Nota sobre o erro `relation "public.categories" does not exist`:**
> Esse erro ocorre se o arquivo de dados `seed.sql` for executado antes de criar a estrutura de tabelas, ou se apenas parte do texto foi selecionada no editor. Ao utilizar o script unificado `complete_setup.sql`, as tabelas são criadas primeiro e os dados são inseridos na sequência correta automaticamente.

---

### Passo 3: Verificar o Bucket de Mídias (Storage)
1. No menu lateral esquerdo, clique em **Storage**.
2. Verifique se o bucket chamado `portfolio` está listado.
3. O script do Passo 2 já configura o bucket como **Public**. Se porventura precisar criar manualmente:
   - Clique em **"New bucket"**.
   - Nome: `portfolio`.
   - Marque a opção **"Public bucket"**.
   - Salve.

---

### Passo 4: Criar o Usuário Administrador da Júlia
Para que apenas a Júlia (ou você) consiga acessar o painel `/admin/`:
1. No menu lateral esquerdo, clique em **Authentication** > **Users**.
2. Clique em **"Add user"** > **"Create user"**.
3. Preencha:
   - **User Email**: O e-mail que será usado para login (ex: `juliacrubio51@gmail.com`).
   - **Password**: Uma senha segura.
   - **Auto Confirm User**: Marque esta opção como **Ativada (Yes)** para não precisar de confirmação por e-mail.
4. Clique em **"Create user"**.

---

### Passo 5: Obter as Chaves de Acesso e Conectar ao CMS
1. No Supabase, clique na engrenagem **Project Settings** (canto inferior esquerdo) > **API**.
2. Copie:
   - **Project URL** (ex: `https://xyzcompany.supabase.co`)
   - **Project API Keys** > chave **`anon` `public`** (começa com `eyJhbGci...`)
   > ⚠️ **ATENÇÃO:** NUNCA utilize ou exponha a chave `service_role`. Utilize **apenas** a chave pública `anon`.

3. Abra o painel administrativo no seu navegador:
   - Localmente: `http://localhost:3000/admin/` (ou abra `admin/index.html`).
   - Ou direto na URL do GitHub Pages: `https://seu-usuario.github.io/julia.rubio-portfolio/admin/`.
4. Clique em **Configurações**:
   - Cole o **Project URL**.
   - Cole a **Anon Key**.
   - Clique em **"Salvar Credenciais"**.
   - Clique em **"Testar Conexão"** para validar.
5. Pronto! Agora volte para a tela inicial do `/admin/`, faça login com o e-mail e senha criados no Passo 5 e comece a gerenciar os projetos!

---

## 3. Opcional: Pré-configurar as Credenciais no Código

Se quiser que qualquer pessoa que abra o painel já encontre as chaves preenchidas sem precisar digitá-las na tela de configurações, basta editar as linhas 14 e 17 do arquivo [`assets/js/supabase-client.js`](assets/js/supabase-client.js):

```javascript
const SUPABASE_CONFIG = {
  // Substitua pela URL do seu projeto Supabase:
  url: localStorage.getItem("jr_supabase_url") || "https://SEU-PROJETO.supabase.co",

  // Substitua pela Anon Public Key do seu projeto:
  anonKey: localStorage.getItem("jr_supabase_anon_key") || "eyJhbGciOiJIUzI1NiIsInR5cCI6..."
};
```
*Nota: A chave `anon` é segura para ficar pública, pois as regras de Row Level Security (RLS) no PostgreSQL garantem que apenas quem fizer login com e-mail e senha de administrador conseguirá editar ou apagar dados.*

---

## 4. Recursos do Painel Administrativo (`/admin/`)

- **Dashboard**: Visão geral com métricas em tempo real (Total de projetos, Publicados, Rascunhos, Destaques) e lista dos últimos projetos editados.
- **Projetos**: Tabela completa com pesquisa em tempo real por nome/slug, filtro por categoria, filtro por status (Publicado/Rascunho) e ordenação.
- **Cadastro e Edição de Projetos**:
  - Geração automática de slug limpo e único.
  - Campos bilíngues (Português e Inglês) para descrição e detalhes.
  - Multi-seleção de categorias com adição de novas categorias dinamicamente.
  - Upload de imagens e vídeos com drag-and-drop direto para o Supabase Storage.
  - Seleção visual da imagem de capa com um clique (estrela).
  - Reordenação de imagens por arrastar e soltar.
  - Blocos opcionais de **Processo Criativo** (O Desafio, O Conceito, O Sistema Visual).
- **Destaques da Home**: Interface visual de arrastar e soltar (drag-and-drop) para definir a ordem exata em que os projetos aparecem no carrossel e na seção "Selected Works" da página inicial.
- **Backup em 1 Clique**: Botão para exportar e baixar todo o banco de projetos em arquivo `.json`.

---

## 5. Hospedagem no GitHub Pages

1. Faça o commit e push de todos os arquivos para o repositório no GitHub:
   ```bash
   git add .
   git commit -m "feat: complete CMS implementation with Supabase"
   git push origin main
   ```
2. No repositório no GitHub:
   - Acesse **Settings** > **Pages**.
   - Em **Source**, selecione **Deploy from a branch**.
   - Em **Branch**, selecione `main` e a pasta `/ (root)`.
   - Clique em **Save**.
3. O portfólio estará online em `https://<seu-usuario>.github.io/<nome-do-repositorio>/`.
4. O painel administrativo estará acessível em `https://<seu-usuario>.github.io/<nome-do-repositorio>/admin/`.
