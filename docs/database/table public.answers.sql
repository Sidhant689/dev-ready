-- ─────────────────────────────────────────────
-- PrepStack — Supabase Schema
-- Paste this in: Supabase Dashboard → SQL Editor → Run
-- ─────────────────────────────────────────────

create table public.answers (
  id          bigserial primary key,
  topic       text        not null,
  section_id  text        not null,
  section_label text      not null,
  sl          integer     not null,
  question    text        not null,
  level       text        not null,
  answer      text,
  created_at  timestamptz default now(),
  updated_at  timestamptz default now(),
  constraint  answers_unique unique (topic, section_id, sl)
);

-- Fast lookups by topic + section + question number
create index idx_answers_lookup on public.answers (topic, section_id, sl);

-- Row Level Security
alter table public.answers enable row level security;

-- Anyone can read (public app)
create policy "Public read"
  on public.answers for select
  to anon, authenticated
  using (true);

-- Allow writes (for seeder — tighten this after seeding is done)
create policy "Public write"
  on public.answers for all
  to anon, authenticated
  using (true)
  with check (true);
