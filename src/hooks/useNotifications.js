import { useState, useEffect, useCallback } from "react";
import {
  fetchNotifications, fetchUnreadCount,
  markRead, markBroadcastRead, markAllRead,
  subscribeToNotifications,
} from "../services/notificationService";

export function useNotifications(user) {
  const [notifications, setNotifications] = useState([]);
  const [unreadCount, setUnreadCount] = useState(0);
  const [loading, setLoading] = useState(false);

  const loadUnread = useCallback(async () => {
    if (!user?.id) return;
    try { setUnreadCount(await fetchUnreadCount(user.id)); }
    catch { /* ignore */ }
  }, [user?.id]);

  const loadAll = useCallback(async () => {
    if (!user?.id) return;
    setLoading(true);
    try {
      const data = await fetchNotifications(user.id);
      setNotifications(data);
      setUnreadCount(data.filter(n => !n.is_read).length);
    } catch { /* ignore */ } finally { setLoading(false); }
  }, [user?.id]);

  // Initial load of unread count
  useEffect(() => { loadUnread(); }, [loadUnread]);

  // Real-time subscription
  useEffect(() => {
    if (!user?.id) return;
    const unsub = subscribeToNotifications(user.id, (newNotif) => {
      setNotifications(prev => [newNotif, ...prev]);
      setUnreadCount(c => c + 1);
    });
    return unsub;
  }, [user?.id]);

  const handleMarkRead = useCallback(async (n) => {
    if (n.is_read) return;
    if (typeof n.id === "string" && n.id.startsWith("bcast_")) {
      await markBroadcastRead(n._bcast_id, user.id);
    } else {
      await markRead(n.id);
    }
    setNotifications(prev => prev.map(x => x.id === n.id ? { ...x, is_read: true } : x));
    setUnreadCount(c => Math.max(0, c - 1));
  }, [user?.id]);

  const handleMarkAllRead = useCallback(async () => {
    if (!user?.id) return;
    await markAllRead(user.id);
    setNotifications(prev => prev.map(n => ({ ...n, is_read: true })));
    setUnreadCount(0);
  }, [user?.id]);

  return { notifications, unreadCount, loading, loadAll, markRead: handleMarkRead, markAllRead: handleMarkAllRead };
}
