-- ================================================================
-- 00c_sections_table.sql
-- Sections within each topic (e.g. "C# Basics", "ASP.NET Core").
-- Sections are populated via seeds/migrate-data.sql.
--
-- Depends on: 00b_topics_table.sql
-- ================================================================

CREATE TABLE IF NOT EXISTS public.sections (
  id            SERIAL      PRIMARY KEY,
  topic_id      INTEGER     NOT NULL REFERENCES public.topics(id) ON DELETE CASCADE,
  slug          TEXT        NOT NULL,
  label         TEXT        NOT NULL,
  display_order INTEGER     NOT NULL,
  created_at    TIMESTAMPTZ DEFAULT NOW(),

  UNIQUE (topic_id, slug)
);

CREATE INDEX IF NOT EXISTS idx_sections_topic  ON public.sections (topic_id);
CREATE INDEX IF NOT EXISTS idx_sections_lookup ON public.sections (topic_id, display_order);

-- ── RLS — public read ─────────────────────────────────────────────
ALTER TABLE public.sections ENABLE ROW LEVEL SECURITY;

CREATE POLICY "sections: public read"
  ON public.sections FOR SELECT
  TO anon, authenticated USING (true);
