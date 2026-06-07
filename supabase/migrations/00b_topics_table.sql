-- ================================================================
-- 00b_topics_table.sql
-- Top-level interview topics (e.g. .NET, React, SQL).
-- Topics are populated via seeds/migrate-data.sql.
--
-- Depends on: nothing
-- ================================================================

CREATE TABLE IF NOT EXISTS public.topics (
  id            SERIAL      PRIMARY KEY,
  slug          TEXT        UNIQUE NOT NULL,
  label         TEXT        NOT NULL,
  description   TEXT,
  color_hex     TEXT        DEFAULT '#818cf8',
  icon_emoji    TEXT        DEFAULT '🔹',
  display_order INTEGER,
  total_count   INTEGER     DEFAULT 0,
  created_at    TIMESTAMPTZ DEFAULT NOW(),
  updated_at    TIMESTAMPTZ DEFAULT NOW()
);

CREATE UNIQUE INDEX IF NOT EXISTS idx_topics_slug  ON public.topics (slug);
CREATE INDEX        IF NOT EXISTS idx_topics_order ON public.topics (display_order);

-- ── RLS — public read ─────────────────────────────────────────────
ALTER TABLE public.topics ENABLE ROW LEVEL SECURITY;

CREATE POLICY "topics: public read"
  ON public.topics FOR SELECT
  TO anon, authenticated USING (true);
