# Supabase SQL Files

## Folder Structure

```
supabase/
├── migrations/   ← DDL: run once in order to build the schema
├── seeds/        ← Data: run to populate topics, questions, and answers
└── archive/      ← Old/superseded files kept for reference only
```

---

## Migrations

Run these files **in order** from the Supabase SQL Editor.  
All files are idempotent (`CREATE IF NOT EXISTS`, `ON CONFLICT DO NOTHING`) — safe to re-run.

### Core Content Tables (run first)

| File | What it creates |
|---|---|
| `00_difficulty_levels_table.sql` | `difficulty_levels` lookup table + seed rows (basic/intermediate/advanced/coding/scenario) |
| `00b_topics_table.sql` | `topics` table (e.g. .NET, React, SQL) |
| `00c_sections_table.sql` | `sections` table (chapters within each topic) |
| `00d_questions_table.sql` | `questions` table (individual interview questions) |
| `00e_answers_table.sql` | `answers` table (markdown answer content per question) |

### User Tables (run after core content)

| File | What it creates |
|---|---|
| `01_users_table.sql` | `public.users` profile table + RLS |
| `02_user_progress_table.sql` | `user_progress` (question status per user) + indexes + RLS |
| `03_auto_create_profile_trigger.sql` | Trigger: auto-creates a profile row on every new signup |
| `04_user_notes_table.sql` | `user_notes` (per-question notes, auto-saved) + RLS |
| `05_user_bookmarks_table.sql` | `user_bookmarks` (starred questions with labels) + RLS |
| `06_admin_role.sql` | Adds `role` column to users + `is_admin()` function + admin RLS |
| `07_user_settings_table.sql` | `user_settings` (theme, weekly_goal per user) + RLS |

### After running 06 — promote your admin account

```sql
UPDATE public.users SET role = 'admin' WHERE email = 'your@email.com';
```

---

## Seeds

Seed files insert data. Safe to re-run (`ON CONFLICT DO NOTHING`).  
Run **after all migrations** are complete.

| File | What it seeds |
|---|---|
| `seeds/migrate-data.sql` | All topics, sections, and questions across every topic |
| `seeds/answerseed2.sql` | Answer content for 396 questions (markdown, dollar-quoted) |

**Seed order:** `migrate-data.sql` first (topics → sections → questions), then `answerseed2.sql` (answers reference question IDs).

---

## Schema Overview

| Table | Purpose |
|---|---|
| `difficulty_levels` | Difficulty enum: basic / intermediate / advanced / coding / scenario |
| `topics` | Interview topics (e.g. .NET, React, SQL, DSA) |
| `sections` | Sections within each topic |
| `questions` | Individual interview questions |
| `answers` | Markdown answer content per question |
| `public.users` | User profiles mirroring `auth.users` |
| `user_progress` | Per-user question status: `To Do` / `In Progress` / `Done` |
| `user_notes` | Per-user freeform notes per question |
| `user_bookmarks` | Starred questions with denormalized labels for fast display |
| `user_settings` | User preferences: `theme`, `weekly_goal` |
