-- ════════════════════════════════════════════════════════════════
-- DEVREADY DATABASE SCHEMA
-- Run this in: Supabase Dashboard → SQL Editor → Copy & Paste & Run
-- ════════════════════════════════════════════════════════════════

-- 1. DROP old tables if exists (optional - only if migrating)
DROP TABLE IF EXISTS public.user_progress CASCADE;
DROP TABLE IF EXISTS public.answers CASCADE;
DROP TABLE IF EXISTS public.questions CASCADE;
DROP TABLE IF EXISTS public.sections CASCADE;
DROP TABLE IF EXISTS public.difficulty_levels CASCADE;
DROP TABLE IF EXISTS public.topics CASCADE;

-- ════════════════════════════════════════════════════════════════
-- Table 1: DIFFICULTY LEVELS (Metadata)
-- ════════════════════════════════════════════════════════════════
CREATE TABLE IF NOT EXISTS public.difficulty_levels (
  id SERIAL PRIMARY KEY,
  slug TEXT UNIQUE NOT NULL,
  label TEXT NOT NULL,
  bg_color TEXT NOT NULL,
  text_color TEXT NOT NULL,
  display_order INTEGER,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

INSERT INTO public.difficulty_levels (slug, label, bg_color, text_color, display_order) VALUES
  ('basic', 'Basic', '#dbeafe', '#1e40af', 1),
  ('intermediate', 'Intermediate', '#fef3c7', '#92400e', 2),
  ('advanced', 'Advanced', '#fee2e2', '#991b1b', 3),
  ('coding', 'Coding', '#ede9fe', '#5b21b6', 4),
  ('scenario', 'Scenario', '#d1fae5', '#065f46', 5)
ON CONFLICT (slug) DO NOTHING;

-- ════════════════════════════════════════════════════════════════
-- Table 2: TOPICS
-- ════════════════════════════════════════════════════════════════
CREATE TABLE IF NOT EXISTS public.topics (
  id SERIAL PRIMARY KEY,
  slug TEXT UNIQUE NOT NULL,
  label TEXT NOT NULL,
  description TEXT,
  color_hex TEXT DEFAULT '#818cf8',
  icon_emoji TEXT DEFAULT '🔹',
  display_order INTEGER,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE UNIQUE INDEX IF NOT EXISTS idx_topics_slug ON public.topics(slug);
CREATE INDEX IF NOT EXISTS idx_topics_order ON public.topics(display_order);

-- ════════════════════════════════════════════════════════════════
-- Table 3: SECTIONS
-- ════════════════════════════════════════════════════════════════
CREATE TABLE IF NOT EXISTS public.sections (
  id SERIAL PRIMARY KEY,
  topic_id INTEGER NOT NULL REFERENCES public.topics(id) ON DELETE CASCADE,
  slug TEXT NOT NULL,
  label TEXT NOT NULL,
  display_order INTEGER NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(topic_id, slug)
);

CREATE INDEX IF NOT EXISTS idx_sections_topic ON public.sections(topic_id);
CREATE INDEX IF NOT EXISTS idx_sections_lookup ON public.sections(topic_id, display_order);

-- ════════════════════════════════════════════════════════════════
-- Table 4: QUESTIONS
-- ════════════════════════════════════════════════════════════════
CREATE TABLE IF NOT EXISTS public.questions (
  id SERIAL PRIMARY KEY,
  section_id INTEGER NOT NULL REFERENCES public.sections(id) ON DELETE CASCADE,
  difficulty_id INTEGER NOT NULL REFERENCES public.difficulty_levels(id),
  serial_number INTEGER NOT NULL,
  text TEXT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(section_id, serial_number)
);

CREATE INDEX IF NOT EXISTS idx_questions_section ON public.questions(section_id);
CREATE INDEX IF NOT EXISTS idx_questions_difficulty ON public.questions(difficulty_id);
CREATE INDEX IF NOT EXISTS idx_questions_lookup ON public.questions(section_id, serial_number);

-- ════════════════════════════════════════════════════════════════
-- Table 5: ANSWERS
-- ════════════════════════════════════════════════════════════════
CREATE TABLE IF NOT EXISTS public.answers (
  id SERIAL PRIMARY KEY,
  question_id INTEGER NOT NULL UNIQUE REFERENCES public.questions(id) ON DELETE CASCADE,
  content TEXT,
  is_verified BOOLEAN DEFAULT FALSE,
  source_url TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_answers_question ON public.answers(question_id);

-- ════════════════════════════════════════════════════════════════
-- Table 6: USER PROGRESS
-- ════════════════════════════════════════════════════════════════
CREATE TABLE IF NOT EXISTS public.user_progress (
  id SERIAL PRIMARY KEY,
  user_id TEXT NOT NULL,
  question_id INTEGER NOT NULL REFERENCES public.questions(id) ON DELETE CASCADE,
  status TEXT DEFAULT 'To Do',
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(user_id, question_id)
);

CREATE INDEX IF NOT EXISTS idx_progress_user ON public.user_progress(user_id);
CREATE INDEX IF NOT EXISTS idx_progress_lookup ON public.user_progress(user_id, status);

-- ════════════════════════════════════════════════════════════════
-- ROW LEVEL SECURITY (RLS)
-- ════════════════════════════════════════════════════════════════

-- Enable RLS
ALTER TABLE public.topics ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.sections ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.difficulty_levels ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.questions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.answers ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.user_progress ENABLE ROW LEVEL SECURITY;

-- Public read policies (everyone can read)
CREATE POLICY "Public read topics" ON public.topics FOR SELECT TO anon, authenticated USING (true);
CREATE POLICY "Public read sections" ON public.sections FOR SELECT TO anon, authenticated USING (true);
CREATE POLICY "Public read difficulty" ON public.difficulty_levels FOR SELECT TO anon, authenticated USING (true);
CREATE POLICY "Public read questions" ON public.questions FOR SELECT TO anon, authenticated USING (true);
CREATE POLICY "Public read answers" ON public.answers FOR SELECT TO anon, authenticated USING (true);

-- User progress policies
-- TODO: When Supabase Auth/OAuth is added, replace these temporary public
-- policies with auth.uid()-based policies and change user_id to UUID if needed.
CREATE POLICY "Public read progress temporary" ON public.user_progress FOR SELECT TO anon, authenticated 
  USING (true);

CREATE POLICY "Public insert progress temporary" ON public.user_progress FOR INSERT TO anon, authenticated 
  WITH CHECK (true);

CREATE POLICY "Public update progress temporary" ON public.user_progress FOR UPDATE TO anon, authenticated 
  USING (true)
  WITH CHECK (true);

-- ════════════════════════════════════════════════════════════════
-- SCHEMA READY FOR DATA MIGRATION
-- ════════════════════════════════════════════════════════════════
-- Next: Run migration script to insert all topics/sections/questions
