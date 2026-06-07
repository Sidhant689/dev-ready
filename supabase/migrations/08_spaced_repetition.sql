-- Spaced repetition fields on user_progress
-- Uses SM-2 algorithm: ease_factor, interval_days, next_review_at

ALTER TABLE user_progress
  ADD COLUMN IF NOT EXISTS ease_factor    NUMERIC(4,2) DEFAULT 2.5,
  ADD COLUMN IF NOT EXISTS interval_days  INTEGER      DEFAULT 1,
  ADD COLUMN IF NOT EXISTS next_review_at TIMESTAMPTZ  DEFAULT NULL,
  ADD COLUMN IF NOT EXISTS repetitions    INTEGER      DEFAULT 0;

-- Index for fetching due reviews efficiently
CREATE INDEX IF NOT EXISTS idx_user_progress_review
  ON user_progress (user_id, next_review_at)
  WHERE next_review_at IS NOT NULL;
