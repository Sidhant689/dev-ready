-- ================================================================
-- 03_auto_create_profile_trigger.sql
-- Automatically creates a row in public.users whenever a new user
-- signs up — via email, Google, or GitHub.
--
-- Uses EXCEPTION handling so that even if the INSERT fails
-- (e.g. during initial setup), the auth signup still succeeds.
-- The profile row can be created lazily on first sign-in instead.
--
-- Depends on: 01_users_table.sql
-- ================================================================

CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  INSERT INTO public.users (
    id,
    email,
    full_name,
    avatar_url,
    provider
  )
  VALUES (
    NEW.id,
    NEW.email,
    NEW.raw_user_meta_data  ->> 'full_name',
    NEW.raw_user_meta_data  ->> 'avatar_url',
    NEW.raw_app_meta_data   ->> 'provider'
  )
  ON CONFLICT (id) DO UPDATE SET
    email      = EXCLUDED.email,
    full_name  = COALESCE(EXCLUDED.full_name,  public.users.full_name),
    avatar_url = COALESCE(EXCLUDED.avatar_url, public.users.avatar_url),
    provider   = COALESCE(EXCLUDED.provider,   public.users.provider),
    updated_at = NOW();

  RETURN NEW;

EXCEPTION WHEN OTHERS THEN
  -- Never block auth signup because of a profile insert failure.
  -- The profile will be created on the client side after signup.
  RAISE WARNING 'handle_new_user failed for user %: %', NEW.id, SQLERRM;
  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
  AFTER INSERT OR UPDATE ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();
