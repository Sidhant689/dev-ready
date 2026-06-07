-- Add companies tag array to questions
ALTER TABLE questions
  ADD COLUMN IF NOT EXISTS companies TEXT[] DEFAULT '{}';

-- GIN index for fast array containment queries
CREATE INDEX IF NOT EXISTS idx_questions_companies
  ON questions USING GIN (companies);
