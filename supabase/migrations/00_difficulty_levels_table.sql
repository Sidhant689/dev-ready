-- ================================================================
-- 00_difficulty_levels_table.sql
-- Lookup table for question difficulty levels.
-- Must run FIRST — referenced by questions table.
-- ================================================================

CREATE TABLE IF NOT EXISTS public.difficulty_levels (
  id            SERIAL      PRIMARY KEY,
  slug          TEXT        UNIQUE NOT NULL,
  label         TEXT        NOT NULL,
  bg_color      TEXT        NOT NULL,
  text_color    TEXT        NOT NULL,
  display_order INTEGER,
  created_at    TIMESTAMPTZ DEFAULT NOW()
);

-- ── Seed difficulty levels ────────────────────────────────────────
INSERT INTO public.difficulty_levels (slug, label, bg_color, text_color, display_order) VALUES
  ('basic',        'Basic',        '#dbeafe', '#1e40af', 1),
  ('intermediate', 'Intermediate', '#fef3c7', '#92400e', 2),
  ('advanced',     'Advanced',     '#fee2e2', '#991b1b', 3),
  ('coding',       'Coding',       '#ede9fe', '#5b21b6', 4),
  ('scenario',     'Scenario',     '#d1fae5', '#065f46', 5)
ON CONFLICT (slug) DO NOTHING;

-- ── RLS — public read, no write ───────────────────────────────────
ALTER TABLE public.difficulty_levels ENABLE ROW LEVEL SECURITY;

CREATE POLICY "difficulty_levels: public read"
  ON public.difficulty_levels FOR SELECT
  TO anon, authenticated USING (true);
