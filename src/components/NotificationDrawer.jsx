import { useEffect } from "react";
import {
  Bell, X, CheckCheck, MessageSquare, Reply,
  Megaphone, Info, ChevronRight,
} from "lucide-react";

function timeAgo(iso) {
  const diff = (Date.now() - new Date(iso)) / 1000;
  if (diff < 60)   return "just now";
  if (diff < 3600) return `${Math.floor(diff / 60)}m ago`;
  if (diff < 86400) return `${Math.floor(diff / 3600)}h ago`;
  if (diff < 604800) return `${Math.floor(diff / 86400)}d ago`;
  return new Date(iso).toLocaleDateString();
}

const TYPE_CFG = {
  comment_reply:  { Icon: Reply,        color: "text-accent",   bg: "bg-accent/10",   label: "Reply" },
  new_comment:    { Icon: MessageSquare, color: "text-indigo-400", bg: "bg-indigo-400/10", label: "Comment" },
  broadcast:      { Icon: Megaphone,    color: "text-warning",  bg: "bg-warning/10",  label: "Announcement" },
  admin_message:  { Icon: Info,         color: "text-cyan-400", bg: "bg-cyan-400/10", label: "Admin" },
  answer_update:  { Icon: CheckCheck,   color: "text-success",  bg: "bg-success/10",  label: "Update" },
};

function NotifItem({ n, onRead }) {
  const cfg = TYPE_CFG[n.type] || TYPE_CFG.admin_message;
  const { Icon, color, bg, label } = cfg;

  return (
    <button
      onClick={() => onRead(n)}
      className={`w-full flex items-start gap-3 px-4 py-3.5 hover:bg-hover transition-colors cursor-pointer text-left border-b border-border/50 ${
        !n.is_read ? "bg-accent/3" : ""
      }`}
    >
      <div className={`w-8 h-8 rounded-lg ${bg} flex items-center justify-center shrink-0 mt-0.5`}>
        <Icon size={14} strokeWidth={1.8} className={color} />
      </div>
      <div className="flex-1 min-w-0">
        <div className="flex items-start justify-between gap-2">
          <div>
            <span className={`text-[10px] font-bold uppercase tracking-wide ${color}`}>{label}</span>
            <p className={`text-xs font-semibold mt-0.5 ${n.is_read ? "text-muted" : "text-primary"}`}>
              {n.title}
            </p>
          </div>
          {!n.is_read && (
            <div className="w-2 h-2 rounded-full bg-accent shrink-0 mt-1" />
          )}
        </div>
        {n.body && (
          <p className="text-[11px] text-ghost mt-0.5 line-clamp-2 leading-relaxed">{n.body}</p>
        )}
        <p className="text-[10px] text-ghost/60 mt-1">{timeAgo(n.created_at)}</p>
      </div>
    </button>
  );
}

export default function NotificationDrawer({ open, onClose, notifications, loading, onMarkRead, onMarkAllRead, unreadCount, onLoad }) {
  // Load notifications when drawer opens
  useEffect(() => { if (open) onLoad(); }, [open]);

  // Close on Escape
  useEffect(() => {
    if (!open) return;
    const h = (e) => { if (e.key === "Escape") onClose(); };
    window.addEventListener("keydown", h);
    return () => window.removeEventListener("keydown", h);
  }, [open, onClose]);

  return (
    <>
      {/* Backdrop */}
      {open && (
        <div className="fixed inset-0 z-40 bg-black/30 backdrop-blur-[2px]" onClick={onClose} />
      )}

      {/* Drawer */}
      <div className={`fixed top-0 right-0 h-full w-full max-w-sm z-50 bg-panel border-l border-border flex flex-col transition-transform duration-300 ${
        open ? "translate-x-0" : "translate-x-full"
      }`} style={{ boxShadow: "-8px 0 40px rgba(0,0,0,0.3)" }}>

        {/* Header */}
        <div className="flex items-center justify-between px-4 py-4 border-b border-border shrink-0">
          <div className="flex items-center gap-2">
            <Bell size={16} strokeWidth={1.8} className="text-muted" />
            <h2 className="text-sm font-bold text-heading">Notifications</h2>
            {unreadCount > 0 && (
              <span className="text-[10px] font-bold px-1.5 py-0.5 rounded-full bg-accent text-white tabular-nums">
                {unreadCount > 99 ? "99+" : unreadCount}
              </span>
            )}
          </div>
          <div className="flex items-center gap-2">
            {unreadCount > 0 && (
              <button onClick={onMarkAllRead}
                className="text-[11px] text-accent hover:underline cursor-pointer font-medium flex items-center gap-1">
                <CheckCheck size={12} strokeWidth={2} />
                Mark all read
              </button>
            )}
            <button onClick={onClose}
              className="w-7 h-7 rounded-md text-ghost hover:text-muted hover:bg-hover flex items-center justify-center cursor-pointer transition-colors">
              <X size={14} strokeWidth={2} />
            </button>
          </div>
        </div>

        {/* List */}
        <div className="flex-1 overflow-y-auto">
          {loading ? (
            <div className="flex items-center justify-center py-16 gap-2">
              <div className="w-4 h-4 rounded-full border-2 border-border border-t-accent" style={{ animation: "spin 0.8s linear infinite" }} />
              <span className="text-xs text-muted">Loading…</span>
            </div>
          ) : notifications.length === 0 ? (
            <div className="flex flex-col items-center justify-center py-20 text-center px-6">
              <div className="w-14 h-14 rounded-2xl bg-hover border border-border flex items-center justify-center mb-4">
                <Bell size={22} strokeWidth={1.3} className="text-ghost" />
              </div>
              <p className="text-sm font-semibold text-soft mb-1">All caught up</p>
              <p className="text-xs text-muted">No notifications yet — activity will appear here.</p>
            </div>
          ) : (
            notifications.map(n => (
              <NotifItem key={n.id} n={n} onRead={onMarkRead} />
            ))
          )}
        </div>

        {/* Footer hint */}
        <div className="px-4 py-3 border-t border-border shrink-0">
          <p className="text-[10px] text-ghost text-center">Replies and announcements appear here in real-time</p>
        </div>
      </div>
    </>
  );
}
