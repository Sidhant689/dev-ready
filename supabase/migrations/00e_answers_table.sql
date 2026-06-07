-- ================================================================
-- 00e_answers_table.sql
-- Markdown answer content, one row per question.
-- Answers are populated via seeds/answerseed2.sql.
--
-- Depends on: 00d_questions_table.sql
-- ================================================================

CREATE TABLE IF NOT EXISTS public.answers (
  id          SERIAL      PRIMARY KEY,
  question_id INTEGER     NOT NULL UNIQUE REFERENCES public.questions(id) ON DELETE CASCADE,
  content     TEXT,
  is_verified BOOLEAN     DEFAULT FALSE,
  source_url  TEXT,
  created_at  TIMESTAMPTZ DEFAULT NOW(),
  updated_at  TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_answers_question ON public.answers (question_id);

-- ── RLS — public read ─────────────────────────────────────────────
ALTER TABLE public.answers ENABLE ROW LEVEL SECURITY;

CREATE POLICY "answers: public read"
  ON public.answers FOR SELECT
  TO anon, authenticated USING (true);
