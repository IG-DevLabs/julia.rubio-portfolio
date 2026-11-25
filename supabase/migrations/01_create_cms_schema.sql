-- =====================================================================
-- JÚLIA RUBIO PORTFOLIO CMS - DATABASE SCHEMA & SECURITY POLICIES
-- =====================================================================

-- Enable pgcrypto for UUIDs if not already enabled
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- ---------------------------------------------------------------------
-- 1. TABLE: categories
-- ---------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.categories (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    slug TEXT UNIQUE NOT NULL,
    name TEXT NOT NULL DEFAULT '',
    name_pt TEXT NOT NULL DEFAULT '',
    name_en TEXT NOT NULL DEFAULT '',
    display_order INTEGER NOT NULL DEFAULT 0,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- ---------------------------------------------------------------------
-- 2. TABLE: projects
-- ---------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.projects (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    legacy_id INTEGER,
    slug TEXT UNIQUE NOT NULL,
    name TEXT NOT NULL,
    year TEXT DEFAULT '',
    place TEXT DEFAULT '',
    place_pt TEXT DEFAULT '',
    tags TEXT[] DEFAULT '{}'::text[],
    cover_url TEXT DEFAULT '',
    caption_pt TEXT DEFAULT '',
    caption_en TEXT DEFAULT '',
    web_url TEXT DEFAULT '',
    status TEXT NOT NULL DEFAULT 'published' CHECK (status IN ('published', 'draft')),
    featured BOOLEAN NOT NULL DEFAULT false,
    featured_order INTEGER DEFAULT 0,
    display_order INTEGER NOT NULL DEFAULT 0,
    media JSONB NOT NULL DEFAULT '[]'::jsonb,
    proc JSONB,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- ---------------------------------------------------------------------
-- 3. TABLE: site_settings
-- ---------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.site_settings (
    key TEXT PRIMARY KEY,
    value JSONB NOT NULL,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- ---------------------------------------------------------------------
-- 4. INDEXES FOR HIGH-PERFORMANCE QUERIES
-- ---------------------------------------------------------------------
CREATE INDEX IF NOT EXISTS idx_projects_slug ON public.projects(slug);
CREATE INDEX IF NOT EXISTS idx_projects_status ON public.projects(status);
CREATE INDEX IF NOT EXISTS idx_projects_featured ON public.projects(featured) WHERE featured = true;
CREATE INDEX IF NOT EXISTS idx_projects_display_order ON public.projects(display_order);
CREATE INDEX IF NOT EXISTS idx_projects_featured_order ON public.projects(featured_order);
CREATE INDEX IF NOT EXISTS idx_categories_display_order ON public.categories(display_order);

-- ---------------------------------------------------------------------
-- 5. AUTOMATIC updated_at TRIGGER
-- ---------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.handle_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS set_projects_updated_at ON public.projects;
CREATE TRIGGER set_projects_updated_at
BEFORE UPDATE ON public.projects
FOR EACH ROW
EXECUTE FUNCTION public.handle_updated_at();

-- ---------------------------------------------------------------------
-- 6. ROW LEVEL SECURITY (RLS) POLICIES
-- ---------------------------------------------------------------------
-- Enable RLS on all tables
ALTER TABLE public.projects ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.site_settings ENABLE ROW LEVEL SECURITY;

-- PROJECTS POLICIES
-- 1) Public users can ONLY read published projects
DROP POLICY IF EXISTS "Public read published projects" ON public.projects;
CREATE POLICY "Public read published projects"
ON public.projects FOR SELECT
USING (status = 'published');

-- 2) Authenticated users (admin) have full CRUD access
DROP POLICY IF EXISTS "Admins have full access to projects" ON public.projects;
CREATE POLICY "Admins have full access to projects"
ON public.projects FOR ALL
TO authenticated
USING (true)
WITH CHECK (true);

-- CATEGORIES POLICIES
DROP POLICY IF EXISTS "Public read categories" ON public.categories;
CREATE POLICY "Public read categories"
ON public.categories FOR SELECT
USING (true);

DROP POLICY IF EXISTS "Admins have full access to categories" ON public.categories;
CREATE POLICY "Admins have full access to categories"
ON public.categories FOR ALL
TO authenticated
USING (true)
WITH CHECK (true);

-- SITE SETTINGS POLICIES
DROP POLICY IF EXISTS "Public read site_settings" ON public.site_settings;
CREATE POLICY "Public read site_settings"
ON public.site_settings FOR SELECT
USING (true);

DROP POLICY IF EXISTS "Admins have full access to site_settings" ON public.site_settings;
CREATE POLICY "Admins have full access to site_settings"
ON public.site_settings FOR ALL
TO authenticated
USING (true)
WITH CHECK (true);

-- ---------------------------------------------------------------------
-- 7. STORAGE BUCKET CONFIGURATION & POLICIES
-- ---------------------------------------------------------------------
-- Create public storage bucket named 'portfolio'
INSERT INTO storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
VALUES (
    'portfolio',
    'portfolio',
    true,
    52428800, -- 50MB per file
    ARRAY['image/jpeg', 'image/png', 'image/webp', 'image/gif', 'image/svg+xml', 'video/mp4', 'video/webm']
)
ON CONFLICT (id) DO UPDATE SET
    public = true,
    file_size_limit = 52428800,
    allowed_mime_types = ARRAY['image/jpeg', 'image/png', 'image/webp', 'image/gif', 'image/svg+xml', 'video/mp4', 'video/webm'];

-- Storage RLS: Public READ
DROP POLICY IF EXISTS "Public can view portfolio assets" ON storage.objects;
CREATE POLICY "Public can view portfolio assets"
ON storage.objects FOR SELECT
USING (bucket_id = 'portfolio');

-- Storage RLS: Admin INSERT
DROP POLICY IF EXISTS "Admins can upload portfolio assets" ON storage.objects;
CREATE POLICY "Admins can upload portfolio assets"
ON storage.objects FOR INSERT
TO authenticated
WITH CHECK (bucket_id = 'portfolio');

-- Storage RLS: Admin UPDATE
DROP POLICY IF EXISTS "Admins can update portfolio assets" ON storage.objects;
CREATE POLICY "Admins can update portfolio assets"
ON storage.objects FOR UPDATE
TO authenticated
USING (bucket_id = 'portfolio');

-- Storage RLS: Admin DELETE
DROP POLICY IF EXISTS "Admins can delete portfolio assets" ON storage.objects;
CREATE POLICY "Admins can delete portfolio assets"
ON storage.objects FOR DELETE
TO authenticated
USING (bucket_id = 'portfolio');
