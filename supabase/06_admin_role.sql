-- ================================================================
-- 06_admin_role.sql
-- Adds role column to public.users and admin-access RLS policies.
--
-- After running this, set yourself as admin:
--   UPDATE public.users SET role = 'admin' WHERE email = 'your@email.com';
-- ================================================================

-- Add role column (default 'user')
ALTER TABLE public.users
  ADD COLUMN IF NOT EXISTS role TEXT NOT NULL DEFAULT 'user'
  CHECK (role IN ('user', 'admin'));

-- Helper function: is the calling user an admin?
CREATE OR REPLACE FUNCTION public.is_admin()
RETURNS BOOLEAN
LANGUAGE sql STABLE SECURITY DEFINER
AS $$
  SELECT EXISTS (
    SELECT 1 FROM public.users
    WHERE id = auth.uid() AND role = 'admin'
  );
$$;

-- ── Admin can read ALL users ──────────────────────────────────
CREATE POLICY "admin: select all users"
  ON public.users FOR SELECT
  USING (public.is_admin());

-- ── Admin can read ALL user_progress ─────────────────────────
CREATE POLICY "admin: select all progress"
  ON public.user_progress FOR SELECT
  USING (public.is_admin());

-- ── Admin can read ALL notes ──────────────────────────────────
CREATE POLICY "admin: select all notes"
  ON public.user_notes FOR SELECT
  USING (public.is_admin());

-- ── After running, set your account as admin: ─────────────────
-- UPDATE public.users SET role = 'admin' WHERE email = 'your@email.com';
