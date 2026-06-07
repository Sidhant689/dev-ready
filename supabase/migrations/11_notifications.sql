-- ── Notifications (per-user) ──────────────────────────────────────────────────
-- type: 'comment_reply' | 'new_comment' | 'broadcast' | 'answer_update' | 'admin_message'
CREATE TABLE IF NOT EXISTS notifications (
  id          BIGSERIAL   PRIMARY KEY,
  user_id     UUID        NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  type        TEXT        NOT NULL,
  title       TEXT        NOT NULL,
  body        TEXT,
  data        JSONB       NOT NULL DEFAULT '{}',
  is_read     BOOLEAN     NOT NULL DEFAULT false,
  created_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_notifications_user      ON notifications (user_id, created_at DESC);
CREATE INDEX IF NOT EXISTS idx_notifications_unread    ON notifications (user_id, is_read) WHERE is_read = false;

-- ── Broadcasts (admin → all users or specific) ────────────────────────────────
CREATE TABLE IF NOT EXISTS broadcasts (
  id               BIGSERIAL   PRIMARY KEY,
  admin_id         UUID        REFERENCES auth.users(id),
  title            TEXT        NOT NULL,
  body             TEXT        NOT NULL,
  target_type      TEXT        NOT NULL DEFAULT 'all' CHECK (target_type IN ('all', 'specific')),
  target_user_ids  UUID[]      NOT NULL DEFAULT '{}',
  created_at       TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Tracks which users have dismissed/read a broadcast
CREATE TABLE IF NOT EXISTS broadcast_reads (
  broadcast_id BIGINT NOT NULL REFERENCES broadcasts(id) ON DELETE CASCADE,
  user_id      UUID   NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  read_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
  PRIMARY KEY (broadcast_id, user_id)
);

CREATE INDEX IF NOT EXISTS idx_broadcast_reads_user ON broadcast_reads (user_id);

-- ── RLS ───────────────────────────────────────────────────────────────────────
ALTER TABLE notifications  ENABLE ROW LEVEL SECURITY;
ALTER TABLE broadcasts     ENABLE ROW LEVEL SECURITY;
ALTER TABLE broadcast_reads ENABLE ROW LEVEL SECURITY;

-- Notifications: own only (+ admin can read all)
CREATE POLICY notif_select ON notifications FOR SELECT TO authenticated USING (auth.uid() = user_id OR is_admin());
CREATE POLICY notif_insert ON notifications FOR INSERT TO authenticated WITH CHECK (true); -- service layer controls this
CREATE POLICY notif_update ON notifications FOR UPDATE TO authenticated USING (auth.uid() = user_id OR is_admin());
CREATE POLICY notif_delete ON notifications FOR DELETE TO authenticated USING (auth.uid() = user_id OR is_admin());

-- Broadcasts: anyone can read; only admin can insert
CREATE POLICY broadcast_select ON broadcasts FOR SELECT TO authenticated USING (true);
CREATE POLICY broadcast_insert ON broadcasts FOR INSERT TO authenticated WITH CHECK (is_admin());

-- Broadcast reads: own only
CREATE POLICY bcast_reads_select ON broadcast_reads FOR SELECT TO authenticated USING (auth.uid() = user_id);
CREATE POLICY bcast_reads_insert ON broadcast_reads FOR INSERT TO authenticated WITH CHECK (auth.uid() = user_id);
