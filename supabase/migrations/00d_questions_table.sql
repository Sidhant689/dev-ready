-- ================================================================
-- 00d_questions_table.sql
-- Individual interview questions, each belonging to a section.
-- Questions are populated via seeds/migrate-data.sql.
--
-- Depends on: 00b_topics_table.sql, 00c_sections_table.sql,
--             00_difficulty_levels_table.sql
-- ================================================================

CREATE TABLE IF NOT EXISTS public.questions (
  id            SERIAL      PRIMARY KEY,
  section_id    INTEGER     NOT NULL REFERENCES public.sections(id)          ON DELETE CASCADE,
  difficulty_id INTEGER     NOT NULL REFERENCES public.difficulty_levels(id),
  serial_number INTEGER     NOT NULL,
  text          TEXT        NOT NULL,
  created_at    TIMESTAMPTZ DEFAULT NOW(),
  updated_at    TIMESTAMPTZ DEFAULT NOW(),

  UNIQUE (section_id, serial_number)
);

CREATE INDEX IF NOT EXISTS idx_questions_section    ON public.questions (section_id);
CREATE INDEX IF NOT EXISTS idx_questions_difficulty ON public.questions (difficulty_id);
CREATE INDEX IF NOT EXISTS idx_questions_lookup     ON public.questions (section_id, serial_number);

-- ── RLS — public read ─────────────────────────────────────────────
ALTER TABLE public.questions ENABLE ROW LEVEL SECURITY;

CREATE POLICY "questions: public read"
  ON public.questions FOR SELECT
  TO anon, authenticated USING (true);
