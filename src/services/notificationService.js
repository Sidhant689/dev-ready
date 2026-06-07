import { supabase } from "../config/supabaseClient";

// ── Fetch notifications for current user ──────────────────────────────────────
export async function fetchNotifications(userId, { limit = 30 } = {}) {
  const [{ data: notifs }, { data: bcasts }, { data: myReads }] = await Promise.all([
    supabase
      .from("notifications")
      .select("*")
      .eq("user_id", userId)
      .order("created_at", { ascending: false })
      .limit(limit),
    supabase
      .from("broadcasts")
      .select("*")
      .order("created_at", { ascending: false })
      .limit(20),
    supabase
      .from("broadcast_reads")
      .select("broadcast_id")
      .eq("user_id", userId),
  ]);

  const readBcastIds = new Set((myReads || []).map(r => r.broadcast_id));

  // Merge broadcasts as notification-like objects
  const bcastNotifs = (bcasts || [])
    .filter(b => b.target_type === "all" || (b.target_user_ids || []).includes(userId))
    .map(b => ({
      id: `bcast_${b.id}`,
      _bcast_id: b.id,
      type: "broadcast",
      title: b.title,
      body: b.body,
      data: {},
      is_read: readBcastIds.has(b.id),
      created_at: b.created_at,
    }));

  const all = [...(notifs || []), ...bcastNotifs]
    .sort((a, b) => new Date(b.created_at) - new Date(a.created_at))
    .slice(0, limit);

  return all;
}

// ── Unread count ──────────────────────────────────────────────────────────────
export async function fetchUnreadCount(userId) {
  const [{ count: notifCount }, { data: bcasts }, { data: myReads }] = await Promise.all([
    supabase
      .from("notifications")
      .select("*", { count: "exact", head: true })
      .eq("user_id", userId)
      .eq("is_read", false),
    supabase
      .from("broadcasts")
      .select("id, target_type, target_user_ids"),
    supabase
      .from("broadcast_reads")
      .select("broadcast_id")
      .eq("user_id", userId),
  ]);

  const readBcastIds = new Set((myReads || []).map(r => r.broadcast_id));
  const unreadBcasts = (bcasts || []).filter(b =>
    !readBcastIds.has(b.id) &&
    (b.target_type === "all" || (b.target_user_ids || []).includes(userId))
  ).length;

  return (notifCount || 0) + unreadBcasts;
}

// ── Mark notification as read ─────────────────────────────────────────────────
export async function markRead(notificationId) {
  await supabase.from("notifications").update({ is_read: true }).eq("id", notificationId);
}

// ── Mark broadcast as read ────────────────────────────────────────────────────
export async function markBroadcastRead(broadcastId, userId) {
  await supabase.from("broadcast_reads").upsert({ broadcast_id: broadcastId, user_id: userId });
}

// ── Mark all as read ──────────────────────────────────────────────────────────
export async function markAllRead(userId) {
  await supabase.from("notifications").update({ is_read: true }).eq("user_id", userId).eq("is_read", false);
}

// ── Create a notification (internal — called after comment/reply) ─────────────
export async function createNotification(userId, type, title, body = "", data = {}) {
  const { error } = await supabase.from("notifications").insert({ user_id: userId, type, title, body, data });
  if (error) console.warn("createNotification error:", error.message);
}

// ── Admin: send broadcast ─────────────────────────────────────────────────────
export async function sendBroadcast(adminId, { title, body, targetType = "all", targetUserIds = [] }) {
  const { data, error } = await supabase
    .from("broadcasts")
    .insert({
      admin_id: adminId,
      title,
      body,
      target_type: targetType,
      target_user_ids: targetType === "specific" ? targetUserIds : [],
    })
    .select()
    .single();
  if (error) throw new Error(error.message);
  return data;
}

// ── Admin: fetch all broadcasts ────────────────────────────────────────────────
export async function fetchBroadcasts() {
  const { data, error } = await supabase
    .from("broadcasts")
    .select("*")
    .order("created_at", { ascending: false })
    .limit(50);
  if (error) throw new Error(error.message);
  return data || [];
}

// ── Admin: fetch all notifications (for moderation) ───────────────────────────
export async function fetchAllNotifications({ limit = 50 } = {}) {
  const { data, error } = await supabase
    .from("notifications")
    .select("*")
    .order("created_at", { ascending: false })
    .limit(limit);
  if (error) throw new Error(error.message);
  return data || [];
}

// ── Subscribe to real-time new notifications for a user ───────────────────────
export function subscribeToNotifications(userId, onNew) {
  const channel = supabase
    .channel(`notifs:${userId}`)
    .on("postgres_changes", {
      event: "INSERT",
      schema: "public",
      table: "notifications",
      filter: `user_id=eq.${userId}`,
    }, payload => onNew(payload.new))
    .subscribe();
  return () => supabase.removeChannel(channel);
}
