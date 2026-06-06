-- ================================================================
-- 02_user_progress_table.sql
-- Tracks each user's status per question.
-- One row per (user_id, question_id) pair.
--
-- Depends on: 01_users_table.sql
-- ================================================================

CREATE TABLE IF NOT EXISTS public.user_progress (
  id          BIGSERIAL   PRIMARY KEY,
  user_id     UUID        NOT NULL REFERENCES public.users(id)     ON DELETE CASCADE,
  question_id BIGINT      NOT NULL REFERENCES public.questions(id) ON DELETE CASCADE,
  status      TEXT        NOT NULL DEFAULT 'To Do'
                CHECK (status IN ('To Do', 'In Progress', 'Done')),
  updated_at  TIMESTAMPTZ NOT NULL DEFAULT NOW(),

  -- Prevents duplicate rows — also required for upsert (ON CONFLICT)
  UNIQUE (user_id, question_id)
);

-- Fast lookup: "give me all progress rows for user X"
CREATE INDEX IF NOT EXISTS idx_user_progress_user_id
  ON public.user_progress (user_id);

-- Fast lookup: "how many users answered question X"
CREATE INDEX IF NOT EXISTS idx_user_progress_question_id
  ON public.user_progress (question_id);

-- ── Auto-update updated_at on every change ────────────────────────
CREATE OR REPLACE FUNCTION public.set_updated_at()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS trg_user_progress_updated_at ON public.user_progress;
CREATE TRIGGER trg_user_progress_updated_at
  BEFORE UPDATE ON public.user_progress
  FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();

-- ── Row Level Security ────────────────────────────────────────────
ALTER TABLE public.user_progress ENABLE ROW LEVEL SECURITY;

CREATE POLICY "progress: select own"
  ON public.user_progress
  FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "progress: insert own"
  ON public.user_progress
  FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "progress: update own"
  ON public.user_progress
  FOR UPDATE
  USING (auth.uid() = user_id);

CREATE POLICY "progress: delete own"
  ON public.user_progress
  FOR DELETE
  USING (auth.uid() = user_id);
