import { useState, useEffect, useCallback, useRef } from "react";
import {
  MessageSquare, ThumbsUp, ThumbsDown, Reply, Pin, Trash2,
  Send, ChevronDown, ChevronUp, Edit2, X, Check,
} from "lucide-react";
import {
  fetchComments, fetchMyLikes, postComment, editComment,
  deleteComment, toggleLike, togglePin,
  fetchAnswerRating, rateAnswer,
} from "../services/commentService";
import { createNotification } from "../services/notificationService";

function timeAgo(iso) {
  const diff = (Date.now() - new Date(iso)) / 1000;
  if (diff < 60)  return "just now";
  if (diff < 3600) return `${Math.floor(diff / 60)}m ago`;
  if (diff < 86400) return `${Math.floor(diff / 3600)}h ago`;
  return `${Math.floor(diff / 86400)}d ago`;
}

function Avatar({ name, size = 7 }) {
  const initials = (name || "U").split(" ").map(w => w[0]).join("").slice(0, 2).toUpperCase();
  const colors = ["bg-violet-500", "bg-indigo-500", "bg-emerald-500", "bg-amber-500", "bg-rose-500", "bg-cyan-500"];
  const color = colors[initials.charCodeAt(0) % colors.length];
  return (
    <div className={`w-${size} h-${size} rounded-full ${color} flex items-center justify-center text-white font-bold shrink-0`}
      style={{ fontSize: size * 1.8 }}>
      {initials}
    </div>
  );
}

// ── Answer Rating ──────────────────────────────────────────────────────────────
function AnswerRating({ questionId, user, isGuest, onOpenAuth }) {
  const [rating, setRating] = useState({ helpful: 0, total: 0, myRating: null });
  const [loading, setLoading] = useState(false);

  useEffect(() => {
    fetchAnswerRating(questionId).then(setRating).catch(() => {});
  }, [questionId]);

  async function handleRate(val) {
    if (isGuest) { onOpenAuth?.("signup"); return; }
    if (!user) return;
    if (loading) return;
    setLoading(true);
    const newVal = rating.myRating === val ? null : val;
    try {
      if (newVal !== null) {
        await rateAnswer(questionId, user.id, newVal);
      } else {
        // un-rate: upsert with opposite then delete — simplest approach is re-fetch
        await rateAnswer(questionId, user.id, newVal === null ? val : newVal);
      }
      const fresh = await fetchAnswerRating(questionId);
      setRating(fresh);
    } catch { /* ignore */ } finally { setLoading(false); }
  }

  const pct = rating.total > 0 ? Math.round((rating.helpful / rating.total) * 100) : null;

  return (
    <div className="flex items-center gap-3 py-3 border-t border-border">
      <span className="text-xs text-ghost">Was this answer helpful?</span>
      <div className="flex items-center gap-1.5">
        <button onClick={() => handleRate(1)} disabled={loading}
          className={`flex items-center gap-1 h-7 px-2.5 rounded-lg border text-xs font-semibold transition-all cursor-pointer ${
            rating.myRating === 1
              ? "bg-success/15 border-success/40 text-success"
              : "bg-hover border-border text-muted hover:border-success/30 hover:text-success"
          }`}>
          <ThumbsUp size={11} strokeWidth={2} />
          Yes
        </button>
        <button onClick={() => handleRate(-1)} disabled={loading}
          className={`flex items-center gap-1 h-7 px-2.5 rounded-lg border text-xs font-semibold transition-all cursor-pointer ${
            rating.myRating === -1
              ? "bg-danger/15 border-danger/40 text-danger"
              : "bg-hover border-border text-muted hover:border-danger/30 hover:text-danger"
          }`}>
          <ThumbsDown size={11} strokeWidth={2} />
          No
        </button>
      </div>
      {pct !== null && (
        <span className="text-[11px] text-muted ml-1 tabular-nums">
          {pct}% helpful <span className="text-ghost">({rating.total})</span>
        </span>
      )}
    </div>
  );
}

// ── Single comment ─────────────────────────────────────────────────────────────
function CommentItem({ comment, isAdmin, user, myLikes, onReply, onLike, onDelete, onPin, onEdit, depth = 0 }) {
  const [editing, setEditing] = useState(false);
  const [editText, setEditText] = useState(comment.content);
  const [saving, setSaving] = useState(false);
  const liked = myLikes.has(comment.id);
  const isOwn = user?.id === comment.user_id;
  const displayName = comment.user?.display_name || "User";

  async function saveEdit() {
    if (!editText.trim()) return;
    setSaving(true);
    try { await onEdit(comment.id, editText); setEditing(false); }
    catch { /* ignore */ } finally { setSaving(false); }
  }

  return (
    <div className={`${depth > 0 ? "ml-8 border-l-2 border-border pl-4" : ""}`}>
      <div className="flex gap-2.5 py-3">
        <Avatar name={displayName} size={7} />
        <div className="flex-1 min-w-0">
          <div className="flex items-center gap-2 mb-1 flex-wrap">
            <span className="text-xs font-semibold text-soft">{displayName}</span>
            {isOwn && <span className="text-[9px] font-bold px-1.5 py-0.5 rounded-md bg-accent/10 text-accent border border-accent/20">You</span>}
            {comment.is_pinned && (
              <span className="text-[9px] font-bold px-1.5 py-0.5 rounded-md bg-warning/10 text-warning border border-warning/20 flex items-center gap-0.5">
                <Pin size={8} strokeWidth={2.5} /> Pinned
              </span>
            )}
            <span className="text-[11px] text-ghost">{timeAgo(comment.created_at)}</span>
            {comment.updated_at !== comment.created_at && (
              <span className="text-[10px] text-ghost italic">edited</span>
            )}
          </div>

          {editing ? (
            <div className="space-y-2">
              <textarea
                value={editText}
                onChange={e => setEditText(e.target.value)}
                rows={3}
                className="w-full bg-hover border border-accent/40 rounded-lg px-3 py-2 text-sm text-primary resize-none outline-none"
                autoFocus
              />
              <div className="flex gap-2">
                <button onClick={saveEdit} disabled={saving || !editText.trim()}
                  className="flex items-center gap-1 h-6 px-2.5 rounded-md bg-accent text-white text-[11px] font-semibold cursor-pointer disabled:opacity-50">
                  <Check size={10} strokeWidth={2.5} /> Save
                </button>
                <button onClick={() => { setEditing(false); setEditText(comment.content); }}
                  className="flex items-center gap-1 h-6 px-2.5 rounded-md bg-hover border border-border text-[11px] text-muted cursor-pointer">
                  <X size={10} strokeWidth={2} /> Cancel
                </button>
              </div>
            </div>
          ) : (
            <p className="text-sm text-primary leading-relaxed whitespace-pre-wrap break-words">{comment.content}</p>
          )}

          {/* Actions */}
          <div className="flex items-center gap-3 mt-2">
            <button onClick={() => onLike(comment.id, liked)}
              className={`flex items-center gap-1 text-[11px] font-semibold transition-colors cursor-pointer ${
                liked ? "text-accent" : "text-ghost hover:text-muted"
              }`}>
              <ThumbsUp size={11} strokeWidth={2} />
              {comment.likes_count > 0 ? comment.likes_count : "Like"}
            </button>

            {depth === 0 && (
              <button onClick={() => onReply(comment)}
                className="flex items-center gap-1 text-[11px] text-ghost hover:text-muted transition-colors cursor-pointer">
                <Reply size={11} strokeWidth={2} />
                Reply
              </button>
            )}

            {(isOwn && !editing) && (
              <button onClick={() => setEditing(true)}
                className="flex items-center gap-1 text-[11px] text-ghost hover:text-muted transition-colors cursor-pointer">
                <Edit2 size={10} strokeWidth={2} />
                Edit
              </button>
            )}

            {(isOwn || isAdmin) && (
              <button onClick={() => onDelete(comment.id)}
                className="flex items-center gap-1 text-[11px] text-ghost hover:text-danger transition-colors cursor-pointer">
                <Trash2 size={10} strokeWidth={2} />
                Delete
              </button>
            )}

            {isAdmin && (
              <button onClick={() => onPin(comment.id, comment.is_pinned)}
                className={`flex items-center gap-1 text-[11px] transition-colors cursor-pointer ${
                  comment.is_pinned ? "text-warning hover:text-warning/70" : "text-ghost hover:text-warning"
                }`}>
                <Pin size={10} strokeWidth={2} />
                {comment.is_pinned ? "Unpin" : "Pin"}
              </button>
            )}
          </div>
        </div>
      </div>
    </div>
  );
}

// ── Compose box ────────────────────────────────────────────────────────────────
function ComposeBox({ onSubmit, placeholder = "Write a comment…", replyTo, onCancelReply, autoFocus }) {
  const [text, setText] = useState("");
  const [loading, setLoading] = useState(false);
  const taRef = useRef(null);

  useEffect(() => { if (autoFocus && taRef.current) taRef.current.focus(); }, [autoFocus]);

  async function submit() {
    if (!text.trim() || loading) return;
    setLoading(true);
    try { await onSubmit(text.trim()); setText(""); }
    catch { /* ignore */ } finally { setLoading(false); }
  }

  return (
    <div className="space-y-2">
      {replyTo && (
        <div className="flex items-center gap-2 text-xs text-muted bg-hover border border-border rounded-lg px-3 py-1.5">
          <Reply size={11} strokeWidth={2} className="text-accent" />
          Replying to <span className="font-semibold text-soft">{replyTo.user?.display_name || "User"}</span>
          <button onClick={onCancelReply} className="ml-auto text-ghost hover:text-muted cursor-pointer">
            <X size={12} strokeWidth={2} />
          </button>
        </div>
      )}
      <div className="flex gap-2 items-end">
        <textarea
          ref={taRef}
          value={text}
          onChange={e => setText(e.target.value)}
          onKeyDown={e => { if (e.key === "Enter" && (e.metaKey || e.ctrlKey)) submit(); }}
          placeholder={placeholder}
          rows={2}
          maxLength={2000}
          className="flex-1 bg-hover border border-border focus:border-accent/50 rounded-xl px-4 py-3 text-sm text-primary resize-none outline-none transition-colors placeholder:text-ghost"
        />
        <button onClick={submit} disabled={!text.trim() || loading}
          className="w-9 h-9 rounded-xl bg-accent hover:bg-accent-hover text-white flex items-center justify-center cursor-pointer disabled:opacity-40 transition-all shrink-0 mb-0.5"
          style={{ boxShadow: text.trim() ? "0 0 12px rgba(99,102,241,0.3)" : "none" }}>
          <Send size={14} strokeWidth={2} />
        </button>
      </div>
      <p className="text-[10px] text-ghost text-right">{text.length}/2000 · Ctrl+Enter to send</p>
    </div>
  );
}

// ── Main CommentsPanel ─────────────────────────────────────────────────────────
export default function CommentsPanel({ questionId, questionText, user, isGuest, onOpenAuth, isAdmin }) {
  const [comments, setComments] = useState([]);
  const [myLikes, setMyLikes] = useState(new Set());
  const [loading, setLoading] = useState(true);
  const [collapsed, setCollapsed] = useState(false);
  const [replyTo, setReplyTo] = useState(null);

  const load = useCallback(async () => {
    if (!questionId) return;
    setLoading(true);
    try {
      const [c, l] = await Promise.all([
        fetchComments(questionId),
        fetchMyLikes(questionId, user?.id),
      ]);
      setComments(c);
      setMyLikes(l);
    } catch (e) { console.error("CommentsPanel load error:", e); } finally { setLoading(false); }
  }, [questionId, user?.id]);

  useEffect(() => { load(); }, [load]);

  async function handlePost(content) {
    if (isGuest) { onOpenAuth?.("signup"); return; }
    const parentId = replyTo?.id ?? null;
    await postComment(questionId, user.id, content, parentId);

    // Notify parent comment author on reply
    if (parentId && replyTo?.user_id && replyTo.user_id !== user.id) {
      await createNotification(
        replyTo.user_id, "comment_reply",
        "Someone replied to your comment",
        `"${content.slice(0, 80)}${content.length > 80 ? "…" : ""}"`,
        { question_id: questionId }
      ).catch(() => {});
    }

    setReplyTo(null);
    await load();
  }

  async function handleLike(commentId, liked) {
    if (isGuest) { onOpenAuth?.("signup"); return; }
    await toggleLike(commentId, user.id, liked);
    setMyLikes(prev => {
      const next = new Set(prev);
      liked ? next.delete(commentId) : next.add(commentId);
      return next;
    });
    setComments(prev => prev.map(c =>
      c.id === commentId ? { ...c, likes_count: c.likes_count + (liked ? -1 : 1) } : c
    ));
  }

  async function handleDelete(commentId) {
    if (!confirm("Delete this comment?")) return;
    await deleteComment(commentId);
    await load();
  }

  async function handlePin(commentId, isPinned) {
    await togglePin(commentId, isPinned);
    await load();
  }

  async function handleEdit(commentId, content) {
    await editComment(commentId, content);
    await load();
  }

  // Separate top-level and replies
  const topLevel = comments.filter(c => !c.parent_id);
  const replies = (parentId) => comments.filter(c => c.parent_id === parentId);
  const totalCount = comments.length;

  return (
    <div className="border-t border-border mt-6">
      {/* Header */}
      <button onClick={() => setCollapsed(v => !v)}
        className="w-full flex items-center justify-between px-0 py-4 cursor-pointer group">
        <div className="flex items-center gap-2">
          <MessageSquare size={15} strokeWidth={1.8} className="text-muted" />
          <span className="text-sm font-semibold text-soft">
            Discussion
            {totalCount > 0 && (
              <span className="ml-2 text-[11px] font-bold px-1.5 py-0.5 rounded-md bg-accent/10 text-accent border border-accent/20">
                {totalCount}
              </span>
            )}
          </span>
        </div>
        {collapsed
          ? <ChevronDown size={14} strokeWidth={2} className="text-ghost group-hover:text-muted transition-colors" />
          : <ChevronUp size={14} strokeWidth={2} className="text-ghost group-hover:text-muted transition-colors" />}
      </button>

      {!collapsed && (
        <div className="space-y-1 pb-6">
          {/* Compose */}
          {!isGuest ? (
            <div className="mb-4">
              <ComposeBox
                onSubmit={handlePost}
                replyTo={replyTo}
                onCancelReply={() => setReplyTo(null)}
              />
            </div>
          ) : (
            <div className="mb-4 flex items-center gap-2 p-3 rounded-xl bg-hover border border-border">
              <MessageSquare size={13} strokeWidth={1.8} className="text-muted shrink-0" />
              <p className="text-xs text-muted">
                <button onClick={() => onOpenAuth?.("signup")} className="text-accent hover:underline cursor-pointer font-semibold">
                  Sign in
                </button>
                {" "}to join the discussion.
              </p>
            </div>
          )}

          {/* Comments list */}
          {loading ? (
            <div className="flex items-center gap-2 py-8 justify-center">
              <div className="w-4 h-4 rounded-full border-2 border-border border-t-accent" style={{ animation: "spin 0.8s linear infinite" }} />
              <span className="text-xs text-muted">Loading discussion…</span>
            </div>
          ) : topLevel.length === 0 ? (
            <div className="py-8 text-center">
              <MessageSquare size={28} strokeWidth={1.2} className="text-ghost mx-auto mb-2" />
              <p className="text-sm text-muted">No comments yet — be the first!</p>
            </div>
          ) : (
            <div className="divide-y divide-border/50">
              {topLevel.map(c => (
                <div key={c.id}>
                  <CommentItem
                    comment={c}
                    isAdmin={isAdmin}
                    user={user}
                    myLikes={myLikes}
                    onReply={setReplyTo}
                    onLike={handleLike}
                    onDelete={handleDelete}
                    onPin={handlePin}
                    onEdit={handleEdit}
                    depth={0}
                  />
                  {/* Replies */}
                  {replies(c.id).map(r => (
                    <CommentItem
                      key={r.id}
                      comment={r}
                      isAdmin={isAdmin}
                      user={user}
                      myLikes={myLikes}
                      onReply={setReplyTo}
                      onLike={handleLike}
                      onDelete={handleDelete}
                      onPin={handlePin}
                      onEdit={handleEdit}
                      depth={1}
                    />
                  ))}
                  {/* Reply compose inline */}
                  {replyTo?.id === c.id && !replyTo.parent_id && (
                    <div className="ml-8 pl-4 border-l-2 border-accent/30 pb-3">
                      <ComposeBox
                        onSubmit={handlePost}
                        placeholder={`Reply to ${c.user?.display_name || "User"}…`}
                        replyTo={replyTo}
                        onCancelReply={() => setReplyTo(null)}
                        autoFocus
                      />
                    </div>
                  )}
                </div>
              ))}
            </div>
          )}
        </div>
      )}
    </div>
  );
}

export { AnswerRating };
