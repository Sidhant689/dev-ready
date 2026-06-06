# Supabase Migrations

Run these files **in order** from the Supabase SQL Editor.

## Order

| File | What it creates |
|---|---|
| `01_users_table.sql` | `public.users` profile table + RLS |
| `02_user_progress_table.sql` | `public.user_progress` table + RLS + indexes |
| `03_auto_create_profile_trigger.sql` | Trigger that auto-creates a profile on every signup |

## How to run

1. Open your Supabase project → **SQL Editor** → **New query**
2. Paste the contents of each file one at a time
3. Click **Run**
4. Repeat for the next file in order

## What each table stores

### `public.users`
| Column | Type | Notes |
|---|---|---|
| `id` | UUID | Same as `auth.users.id` — the user's Supabase UID |
| `email` | TEXT | Email address |
| `full_name` | TEXT | From Google/GitHub OAuth metadata |
| `avatar_url` | TEXT | Profile picture URL from OAuth provider |
| `provider` | TEXT | `email`, `google`, or `github` |
| `created_at` | TIMESTAMPTZ | Account creation time |
| `updated_at` | TIMESTAMPTZ | Last profile update |

### `public.user_progress`
| Column | Type | Notes |
|---|---|---|
| `id` | BIGSERIAL | Auto-increment primary key |
| `user_id` | UUID | References `public.users.id` |
| `question_id` | BIGINT | References `public.questions.id` |
| `status` | TEXT | `To Do`, `In Progress`, or `Done` |
| `updated_at` | TIMESTAMPTZ | Last status change |
