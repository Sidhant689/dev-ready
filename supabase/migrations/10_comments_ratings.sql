-- ── Comments ──────────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS comments (
  id          BIGSERIAL PRIMARY KEY,
  question_id BIGINT       NOT NULL REFERENCES questions(id)  ON DELETE CASCADE,
  user_id     UUID         NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  parent_id   BIGINT       REFERENCES comments(id)            ON DELETE CASCADE,
  content     TEXT         NOT NULL CHECK (char_length(content) BETWEEN 1 AND 2000),
  is_pinned   BOOLEAN      NOT NULL DEFAULT false,
  is_deleted  BOOLEAN      NOT NULL DEFAULT false,
  created_at  TIMESTAMPTZ  NOT NULL DEFAULT now(),
  updated_at  TIMESTAMPTZ  NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_comments_question ON comments (question_id, created_at);
CREATE INDEX IF NOT EXISTS idx_comments_parent   ON comments (parent_id)   WHERE parent_id IS NOT NULL;
CREATE INDEX IF NOT EXISTS idx_comments_user     ON comments (user_id);

-- ── Comment likes ─────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS comment_likes (
  comment_id  BIGINT NOT NULL REFERENCES comments(id) ON DELETE CASCADE,
  user_id     UUID   NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  created_at  TIMESTAMPTZ NOT NULL DEFAULT now(),
  PRIMARY KEY (comment_id, user_id)
);

-- ── Answer ratings ────────────────────────────────────────────────────────────
-- rating: 1 = helpful, -1 = not helpful
CREATE TABLE IF NOT EXISTS answer_ratings (
  question_id BIGINT   NOT NULL REFERENCES questions(id)  ON DELETE CASCADE,
  user_id     UUID     NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  rating      SMALLINT NOT NULL CHECK (rating IN (1, -1)),
  created_at  TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at  TIMESTAMPTZ NOT NULL DEFAULT now(),
  PRIMARY KEY (question_id, user_id)
);

CREATE INDEX IF NOT EXISTS idx_answer_ratings_question ON answer_ratings (question_id);

-- ── RLS ───────────────────────────────────────────────────────────────────────
ALTER TABLE comments       ENABLE ROW LEVEL SECURITY;
ALTER TABLE comment_likes  ENABLE ROW LEVEL SECURITY;
ALTER TABLE answer_ratings ENABLE ROW LEVEL SECURITY;

-- Comments: anyone authenticated can read; only owner or admin can modify
CREATE POLICY comments_select ON comments FOR SELECT TO authenticated USING (true);
CREATE POLICY comments_insert ON comments FOR INSERT TO authenticated WITH CHECK (auth.uid() = user_id);
CREATE POLICY comments_update ON comments FOR UPDATE TO authenticated USING (auth.uid() = user_id OR is_admin());
CREATE POLICY comments_delete ON comments FOR DELETE TO authenticated USING (auth.uid() = user_id OR is_admin());

-- Comment likes: own rows only
CREATE POLICY comment_likes_select ON comment_likes FOR SELECT TO authenticated USING (true);
CREATE POLICY comment_likes_insert ON comment_likes FOR INSERT TO authenticated WITH CHECK (auth.uid() = user_id);
CREATE POLICY comment_likes_delete ON comment_likes FOR DELETE TO authenticated USING (auth.uid() = user_id);

-- Answer ratings: read all, write own
CREATE POLICY answer_ratings_select ON answer_ratings FOR SELECT TO authenticated USING (true);
CREATE POLICY answer_ratings_insert ON answer_ratings FOR INSERT TO authenticated WITH CHECK (auth.uid() = user_id);
CREATE POLICY answer_ratings_update ON answer_ratings FOR UPDATE TO authenticated USING (auth.uid() = user_id);
CREATE POLICY answer_ratings_delete ON answer_ratings FOR DELETE TO authenticated USING (auth.uid() = user_id);
