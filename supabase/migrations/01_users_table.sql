-- ================================================================
-- 01_users_table.sql
-- Public profiles table — one row per registered user.
-- Mirrors auth.users so your app can safely query user info.
--
-- Run this FIRST before any other migration.
-- ================================================================

CREATE TABLE IF NOT EXISTS public.users (
  id          UUID        PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  email       TEXT        NOT NULL,
  full_name   TEXT,
  avatar_url  TEXT,
  provider    TEXT,         -- 'email' | 'google' | 'github'
  created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at  TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ── Row Level Security ────────────────────────────────────────────
ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;

-- Read own profile
CREATE POLICY "users: select own"
  ON public.users
  FOR SELECT
  USING (auth.uid() = id);

-- Insert own profile (used as client-side fallback if trigger misses)
CREATE POLICY "users: insert own"
  ON public.users
  FOR INSERT
  WITH CHECK (auth.uid() = id);

-- Update own profile
CREATE POLICY "users: update own"
  ON public.users
  FOR UPDATE
  USING (auth.uid() = id);
