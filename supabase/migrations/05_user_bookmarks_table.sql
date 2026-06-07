-- ================================================================
-- 05_user_bookmarks_table.sql
-- Bookmarked questions per user. Stores denormalized labels so the
-- sidebar can display bookmarks without extra joins.
-- One row per (user_id, question_id) pair.
--
-- Depends on: 01_users_table.sql
-- ================================================================

CREATE TABLE IF NOT EXISTS public.user_bookmarks (
  id          BIGSERIAL PRIMARY KEY,
  user_id     UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
  question_id BIGINT NOT NULL,
  question_text TEXT NOT NULL DEFAULT '',
  section_label TEXT NOT NULL DEFAULT '',
  topic_label   TEXT NOT NULL DEFAULT '',
  created_at  TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE (user_id, question_id)
);

CREATE INDEX IF NOT EXISTS user_bookmarks_user_id_idx ON public.user_bookmarks(user_id);

ALTER TABLE public.user_bookmarks ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users read own bookmarks"
  ON public.user_bookmarks FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users insert own bookmarks"
  ON public.user_bookmarks FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users delete own bookmarks"
  ON public.user_bookmarks FOR DELETE USING (auth.uid() = user_id);
