-- ================================================================
-- 07_user_settings_table.sql
-- Per-user preferences stored in the database.
-- Covers: weekly goal, theme, and any future user preferences.
-- ================================================================

CREATE TABLE IF NOT EXISTS public.user_settings (
  user_id      UUID        PRIMARY KEY REFERENCES public.users(id) ON DELETE CASCADE,
  weekly_goal  INT         NOT NULL DEFAULT 20,
  theme        TEXT        NOT NULL DEFAULT 'dark' CHECK (theme IN ('dark', 'light')),
  updated_at   TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

ALTER TABLE public.user_settings ENABLE ROW LEVEL SECURITY;

CREATE POLICY "user_settings: select own"
  ON public.user_settings FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "user_settings: insert own"
  ON public.user_settings FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "user_settings: update own"
  ON public.user_settings FOR UPDATE
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);
