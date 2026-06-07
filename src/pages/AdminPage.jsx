import { useState, useEffect, useRef } from "react";
import { useTheme } from "../hooks/useTheme";
import { useAdminAuth } from "../hooks/useAdminAuth";
import { supabase } from "../config/supabaseClient";
import { renderMarkdown } from "../utils/markdown";
import {
  LayoutDashboard, BookOpen, Users, ArrowLeft,
  Layers, HelpCircle, FileText, CheckCircle, AlertCircle,
  TrendingUp, Shield, Zap, Database,
  Plus, Pencil, Trash2, ChevronRight, Search,
  UserCircle, Crown, X, Eye,
  Upload, Download, Table2, AlertTriangle,
  Bell, MessageSquare, Megaphone, Send, Pin, ThumbsUp,
  Map, Star, Check,
} from "lucide-react";
import { fetchAllComments, deleteComment, togglePin } from "../services/commentService";
import { sendBroadcast, fetchBroadcasts, fetchAllNotifications } from "../services/notificationService";
import {
  getAdminStats, getRecentUsers, getEngagementStats,
  adminGetTopics, adminCreateTopic, adminUpdateTopic, adminDeleteTopic,
  adminGetSections, adminCreateSection, adminUpdateSection, adminDeleteSection,
  adminGetQuestions, adminCreateQuestion, adminUpdateQuestion, adminDeleteQuestion,
  adminGetAnswer, adminUpsertAnswer,
  adminGetUsers, adminGetUserStats, adminSetUserRole,
  adminGetDifficultyLevels,
  getContentHealth, getTopicPerformance,
  adminBulkCreateQuestions,
} from "../services/adminService";

/* ── Tiny shared UI ──────────────────────────────────────────── */
function Btn({ children, onClick, variant = "ghost", disabled, className = "" }) {
  const base = "inline-flex items-center gap-1.5 h-8 px-3 rounded-lg text-xs font-medium transition-colors cursor-pointer disabled:opacity-40 disabled:cursor-not-allowed";
  const variants = {
    primary: "bg-accent hover:bg-accent-hover text-white",
    danger:  "bg-danger/10 hover:bg-danger/20 text-danger border border-danger/30",
    ghost:   "bg-hover hover:bg-border text-muted hover:text-primary border border-border",
  };
  return (
    <button className={`${base} ${variants[variant]} ${className}`} onClick={onClick} disabled={disabled}>
      {children}
    </button>
  );
}

function Input({ label, value, onChange, placeholder, type = "text", required }) {
  return (
    <label className="flex flex-col gap-1">
      {label && <span className="text-xs font-medium text-soft">{label}{required && <span className="text-danger ml-0.5">*</span>}</span>}
      <input
        type={type}
        value={value}
        onChange={(e) => onChange(e.target.value)}
        placeholder={placeholder}
        className="h-9 px-3 rounded-lg bg-surface border border-border text-primary text-sm outline-none focus:border-accent transition-colors placeholder:text-ghost"
      />
    </label>
  );
}

function Modal({ title, onClose, children, wide }) {
  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center p-4" style={{ background: "rgba(0,0,0,0.7)" }}>
      <div className={`bg-panel border border-border rounded-2xl flex flex-col ${wide ? "w-full max-w-4xl max-h-[90vh]" : "w-full max-w-lg"}`}>
        <div className="flex items-center justify-between px-5 py-4 border-b border-border shrink-0">
          <h2 className="text-sm font-semibold text-bright">{title}</h2>
          <button onClick={onClose} className="text-ghost hover:text-muted text-lg cursor-pointer">✕</button>
        </div>
        <div className="overflow-y-auto flex-1">{children}</div>
      </div>
    </div>
  );
}

function ConfirmModal({ message, onConfirm, onClose }) {
  return (
    <Modal title="Confirm" onClose={onClose}>
      <div className="px-5 py-6">
        <p className="text-sm text-muted mb-5">{message}</p>
        <div className="flex gap-2 justify-end">
          <Btn onClick={onClose}>Cancel</Btn>
          <Btn variant="danger" onClick={onConfirm}>Delete</Btn>
        </div>
      </div>
    </Modal>
  );
}

/* ── Admin Dashboard ─────────────────────────────────────────── */
function AdminDashboard() {
  const [stats, setStats] = useState(null);
  const [health, setHealth] = useState(null);
  const [topicPerf, setTopicPerf] = useState([]);
  const [recent, setRecent] = useState([]);
  const [engagement, setEngagement] = useState(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    Promise.all([
      getAdminStats(),
      getContentHealth(),
      getTopicPerformance(),
      getRecentUsers(6),
      getEngagementStats(),
    ]).then(([s, h, tp, r, e]) => {
      setStats(s); setHealth(h); setTopicPerf(tp); setRecent(r); setEngagement(e);
      setLoading(false);
    }).catch(() => setLoading(false));
  }, []);

  const KPI_DEFS = [
    { label: "Topics",    key: "topics",    Icon: Layers,      cls: "text-accent    bg-accent/10    border-accent/20"    },
    { label: "Sections",  key: "sections",  Icon: Database,    cls: "text-blue-400  bg-blue-500/10  border-blue-500/20"  },
    { label: "Questions", key: "questions", Icon: HelpCircle,  cls: "text-violet-400 bg-violet-500/10 border-violet-500/20" },
    { label: "Answers",   key: "answers",   Icon: FileText,    cls: "text-success   bg-success/10   border-success/20"   },
    { label: "Users",     key: "users",     Icon: Users,       cls: "text-warning   bg-warning/10   border-warning/20"   },
  ];

  function Skeleton() {
    return <div className="h-6 w-16 bg-hover rounded animate-pulse" />;
  }

  function CoverageBar({ pct, label, color = "var(--color-accent)" }) {
    return (
      <div>
        <div className="flex items-center justify-between mb-1">
          <span className="text-[11px] text-muted">{label}</span>
          <span className="text-[11px] font-semibold text-soft tabular-nums">{pct}%</span>
        </div>
        <div className="h-1.5 bg-hover rounded-full overflow-hidden">
          <div className="h-full rounded-full transition-all duration-700" style={{ width: `${pct}%`, background: color }} />
        </div>
      </div>
    );
  }

  return (
    <div className="p-6 space-y-6 overflow-y-auto h-full">

      {/* Header */}
      <div className="flex items-start justify-between">
        <div>
          <h1 className="text-xl font-bold text-heading">Command Center</h1>
          <p className="text-sm text-muted mt-0.5">Real-time platform overview</p>
        </div>
        <div className="flex items-center gap-2">
          <div className="w-2 h-2 rounded-full bg-success animate-pulse" />
          <span className="text-[11px] text-success font-medium">Live</span>
        </div>
      </div>

      {/* KPI Row */}
      <div className="grid grid-cols-2 lg:grid-cols-5 gap-3">
        {KPI_DEFS.map(({ label, key, Icon, cls }) => (
          <div key={key} className="bg-panel border border-border rounded-xl p-4 flex items-center gap-3">
            <div className={`w-9 h-9 rounded-lg border flex items-center justify-center shrink-0 ${cls}`}>
              <Icon size={16} strokeWidth={1.7} />
            </div>
            <div>
              {loading ? <Skeleton /> : (
                <p className="text-2xl font-bold text-heading tabular-nums leading-none">{stats?.[key] ?? 0}</p>
              )}
              <p className="text-xs text-muted font-medium mt-0.5">{label}</p>
            </div>
          </div>
        ))}
      </div>

      {/* Content Health + Quick Actions */}
      <div className="grid grid-cols-1 lg:grid-cols-3 gap-5">

        {/* Content Health */}
        <div className="lg:col-span-2 bg-panel border border-border rounded-xl p-5">
          <div className="flex items-center gap-2 mb-4">
            <div className="w-7 h-7 rounded-lg bg-success/10 border border-success/20 text-success flex items-center justify-center">
              <Shield size={13} strokeWidth={1.8} />
            </div>
            <p className="text-sm font-semibold text-soft">Content Health</p>
          </div>

          {loading ? (
            <div className="space-y-3">{[1,2,3].map(i => <div key={i} className="h-6 bg-hover rounded animate-pulse" />)}</div>
          ) : (
            <div className="space-y-4">
              <div className="grid grid-cols-3 gap-3">
                {[
                  { label: "Coverage", value: `${health?.coverage ?? 0}%`, cls: "text-success", sub: "Questions with answers" },
                  { label: "Answered",  value: health?.withAnswers ?? 0,   cls: "text-accent",  sub: "Questions answered"      },
                  { label: "Missing",   value: health?.withoutAnswers ?? 0, cls: health?.withoutAnswers > 0 ? "text-danger" : "text-success", sub: "Need answers" },
                ].map(({ label, value, cls, sub }) => (
                  <div key={label} className="bg-hover/40 rounded-lg p-3 text-center">
                    <p className={`text-xl font-bold tabular-nums ${cls}`}>{value}</p>
                    <p className="text-[10px] font-semibold text-soft mt-0.5">{label}</p>
                    <p className="text-[10px] text-muted">{sub}</p>
                  </div>
                ))}
              </div>
              <CoverageBar pct={health?.coverage ?? 0} label="Answer Coverage"
                color={health?.coverage >= 90 ? "var(--color-success)" : health?.coverage >= 60 ? "var(--color-accent)" : "#ef4444"} />
              {health?.withoutAnswers > 0 && (
                <div className="flex items-start gap-2 p-3 rounded-lg bg-danger/5 border border-danger/20">
                  <AlertCircle size={13} className="text-danger shrink-0 mt-0.5" strokeWidth={2} />
                  <p className="text-[11px] text-soft">
                    <strong className="text-danger">{health.withoutAnswers} questions</strong> are missing answers and will show a blank response to users.
                  </p>
                </div>
              )}
            </div>
          )}
        </div>

        {/* Quick Actions */}
        <div className="bg-panel border border-border rounded-xl p-5">
          <div className="flex items-center gap-2 mb-4">
            <div className="w-7 h-7 rounded-lg bg-accent/10 border border-accent/20 text-accent flex items-center justify-center">
              <Zap size={13} strokeWidth={1.8} />
            </div>
            <p className="text-sm font-semibold text-soft">Quick Actions</p>
          </div>
          <div className="space-y-2">
            {[
              { label: "Manage Content",   sub: "Topics, sections, questions", color: "text-accent",   tab: "content" },
              { label: "Manage Users",     sub: "Roles, activity, access",     color: "text-blue-400", tab: "users"   },
              { label: "Back to App",      sub: "Return to user-facing app",   color: "text-success",  href: "/"      },
            ].map(({ label, sub, color, tab, href }) => (
              href ? (
                <a key={label} href={href}
                  className="flex items-center gap-3 px-3 py-2.5 rounded-lg bg-hover/40 hover:bg-hover border border-border hover:border-accent/30 transition-all group cursor-pointer">
                  <div className={`w-1.5 h-1.5 rounded-full shrink-0 ${color.replace("text-", "bg-")}`} />
                  <div>
                    <p className={`text-xs font-semibold ${color}`}>{label}</p>
                    <p className="text-[10px] text-muted">{sub}</p>
                  </div>
                  <ArrowLeft size={11} className="text-ghost ml-auto rotate-180 group-hover:translate-x-0.5 transition-transform" />
                </a>
              ) : (
                <div key={label}
                  className="flex items-center gap-3 px-3 py-2.5 rounded-lg bg-hover/40 hover:bg-hover border border-border hover:border-accent/30 transition-all group cursor-pointer">
                  <div className={`w-1.5 h-1.5 rounded-full shrink-0 ${color.replace("text-", "bg-")}`} />
                  <div>
                    <p className={`text-xs font-semibold ${color}`}>{label}</p>
                    <p className="text-[10px] text-muted">{sub}</p>
                  </div>
                  <ArrowLeft size={11} className="text-ghost ml-auto rotate-180 group-hover:translate-x-0.5 transition-transform" />
                </div>
              )
            ))}
          </div>
        </div>
      </div>

      {/* Engagement Stats */}
      <div className="grid grid-cols-2 lg:grid-cols-5 gap-3">
        {[
          { label: "Comments",     key: "comments",    icon: <MessageSquare size={15} strokeWidth={1.7} />, cls: "text-indigo-400 bg-indigo-500/10 border-indigo-500/20",  nav: "notifs" },
          { label: "Pinned",       key: "pinned",      icon: <Pin           size={15} strokeWidth={1.7} />, cls: "text-warning   bg-warning/10   border-warning/20",        nav: "notifs" },
          { label: "Announcements",key: "broadcasts",  icon: <Megaphone     size={15} strokeWidth={1.7} />, cls: "text-violet-400 bg-violet-500/10 border-violet-500/20",  nav: "notifs" },
          { label: "Ratings",      key: "ratings",     icon: <ThumbsUp      size={15} strokeWidth={1.7} />, cls: "text-success   bg-success/10   border-success/20",        nav: null     },
          { label: "New Today",    key: "activeToday", icon: <Bell          size={15} strokeWidth={1.7} />, cls: "text-cyan-400  bg-cyan-500/10  border-cyan-500/20",       nav: "notifs" },
        ].map(({ label, key, icon, cls }) => (
          <div key={key} className="bg-panel border border-border rounded-xl p-4 flex items-center gap-3">
            <div className={`w-9 h-9 rounded-lg border flex items-center justify-center shrink-0 ${cls}`}>
              {icon}
            </div>
            <div>
              {loading ? <div className="h-6 w-10 bg-hover rounded animate-pulse" /> : (
                <p className="text-2xl font-bold text-heading tabular-nums leading-none">{engagement?.[key] ?? 0}</p>
              )}
              <p className="text-xs text-muted font-medium mt-0.5">{label}</p>
            </div>
          </div>
        ))}
      </div>

      {/* Topic Performance */}
      <div className="bg-panel border border-border rounded-xl overflow-hidden">
        <div className="flex items-center gap-3 px-5 py-3.5 border-b border-border">
          <div className="w-7 h-7 rounded-lg bg-violet-500/10 border border-violet-500/20 text-violet-400 flex items-center justify-center">
            <TrendingUp size={13} strokeWidth={1.8} />
          </div>
          <p className="text-sm font-semibold text-soft">Topic Performance</p>
        </div>
        <table className="w-full text-sm">
          <thead>
            <tr className="border-b border-border/60">
              <th className="text-left px-5 py-2.5 text-[11px] font-semibold text-ghost uppercase tracking-wide">Topic</th>
              <th className="text-center px-4 py-2.5 text-[11px] font-semibold text-ghost uppercase tracking-wide">Sections</th>
              <th className="text-center px-4 py-2.5 text-[11px] font-semibold text-ghost uppercase tracking-wide">Questions</th>
              <th className="text-center px-4 py-2.5 text-[11px] font-semibold text-ghost uppercase tracking-wide">Answers</th>
              <th className="text-left px-5 py-2.5 text-[11px] font-semibold text-ghost uppercase tracking-wide w-40">Coverage</th>
            </tr>
          </thead>
          <tbody>
            {loading ? (
              [1,2,3,4].map(i => (
                <tr key={i} className="border-b border-border/40">
                  <td colSpan={5} className="px-5 py-3"><div className="h-4 bg-hover rounded animate-pulse" /></td>
                </tr>
              ))
            ) : topicPerf.map((t) => (
              <tr key={t.id} className="border-b border-border/40 hover:bg-hover/30 transition-colors">
                <td className="px-5 py-3">
                  <span className="text-xs font-semibold text-primary">{t.label}</span>
                </td>
                <td className="px-4 py-3 text-center">
                  <span className="text-xs font-semibold text-soft tabular-nums">{t.sections}</span>
                </td>
                <td className="px-4 py-3 text-center">
                  <span className="text-xs font-semibold text-soft tabular-nums">{t.questions}</span>
                </td>
                <td className="px-4 py-3 text-center">
                  <span className={`text-xs font-semibold tabular-nums ${t.answers === t.questions && t.questions > 0 ? "text-success" : t.answers > 0 ? "text-warning" : "text-danger"}`}>
                    {t.answers}
                  </span>
                </td>
                <td className="px-5 py-3">
                  <div className="flex items-center gap-2">
                    <div className="flex-1 h-1.5 bg-hover rounded-full overflow-hidden">
                      <div className="h-full rounded-full transition-all duration-500"
                        style={{
                          width: `${t.coverage}%`,
                          background: t.coverage === 100 ? "var(--color-success)" : t.coverage >= 60 ? "var(--color-accent)" : "#ef4444",
                        }} />
                    </div>
                    <span className="text-[10px] font-semibold text-muted tabular-nums w-8">{t.coverage}%</span>
                  </div>
                </td>
              </tr>
            ))}
            {!loading && topicPerf.length === 0 && (
              <tr><td colSpan={5} className="text-center py-8 text-xs text-ghost">No topics found</td></tr>
            )}
          </tbody>
        </table>
      </div>

      {/* Recent Users */}
      <div className="bg-panel border border-border rounded-xl overflow-hidden">
        <div className="flex items-center gap-3 px-5 py-3.5 border-b border-border">
          <div className="w-7 h-7 rounded-lg bg-blue-500/10 border border-blue-500/20 text-blue-400 flex items-center justify-center">
            <Users size={13} strokeWidth={1.8} />
          </div>
          <p className="text-sm font-semibold text-soft">Recent Registrations</p>
        </div>
        <table className="w-full text-sm">
          <thead>
            <tr className="border-b border-border/60">
              <th className="text-left px-5 py-2.5 text-[11px] font-semibold text-ghost uppercase tracking-wide">User</th>
              <th className="text-left px-4 py-2.5 text-[11px] font-semibold text-ghost uppercase tracking-wide">Name</th>
              <th className="text-left px-4 py-2.5 text-[11px] font-semibold text-ghost uppercase tracking-wide">Role</th>
              <th className="text-left px-4 py-2.5 text-[11px] font-semibold text-ghost uppercase tracking-wide">Joined</th>
            </tr>
          </thead>
          <tbody>
            {recent.map((u) => (
              <tr key={u.id} className="border-b border-border/40 hover:bg-hover/30 transition-colors">
                <td className="px-5 py-3 text-xs text-primary font-medium">{u.email}</td>
                <td className="px-4 py-3 text-xs text-muted">{u.full_name || "—"}</td>
                <td className="px-4 py-3">
                  <span className={`text-[10px] font-semibold px-2 py-0.5 rounded-md ${
                    u.role === "admin" ? "bg-accent/15 text-accent border border-accent/20" : "bg-hover text-muted border border-border"
                  }`}>
                    {u.role}
                  </span>
                </td>
                <td className="px-4 py-3 text-xs text-muted tabular-nums">
                  {new Date(u.created_at).toLocaleDateString("en", { month: "short", day: "numeric", year: "numeric" })}
                </td>
              </tr>
            ))}
            {recent.length === 0 && !loading && (
              <tr><td colSpan={4} className="text-center py-8 text-xs text-ghost">No users yet</td></tr>
            )}
          </tbody>
        </table>
      </div>

    </div>
  );
}

/* ── Answer Editor ───────────────────────────────────────────── */
function AnswerEditor({ questionId, questionText, onClose }) {
  const [content, setContent] = useState("");
  const [loading, setLoading] = useState(true);
  const [saving, setSaving] = useState(false);
  const [saved, setSaved] = useState(false);
  const [tab, setTab] = useState("write");

  useEffect(() => {
    setLoading(true);
    adminGetAnswer(questionId).then((data) => {
      setContent(data?.content || "");
      setLoading(false);
    }).catch(() => setLoading(false));
  }, [questionId]);

  async function save() {
    setSaving(true);
    setSaved(false);
    try {
      await adminUpsertAnswer(questionId, content);
      setSaved(true);
    } catch (e) {
      alert("Save failed: " + e.message);
    }
    setSaving(false);
  }

  return (
    <Modal title={`Answer: ${questionText.slice(0, 60)}…`} onClose={onClose} wide>
      <div className="flex flex-col h-full">
        {/* Tab bar */}
        <div className="flex items-center gap-1 px-5 py-2 border-b border-border bg-surface/50 shrink-0">
          {["write", "preview"].map((t) => (
            <button
              key={t}
              className={`h-7 px-3 rounded-md text-xs font-medium transition-colors cursor-pointer capitalize ${tab === t ? "bg-panel text-primary border border-border" : "text-ghost hover:text-muted"}`}
              onClick={() => setTab(t)}
            >
              {t}
            </button>
          ))}
          <div className="ml-auto flex items-center gap-2">
            <span className="text-[10px] text-ghost">{saving ? "Saving…" : saved ? "✓ Saved" : ""}</span>
            <Btn variant="primary" onClick={save} disabled={saving}>
              {saving ? "Saving…" : "Save Answer"}
            </Btn>
          </div>
        </div>

        {loading ? (
          <div className="flex items-center justify-center py-20"><div className="w-5 h-5 rounded-full border-2 border-border border-t-accent" style={{ animation: "spin 0.8s linear infinite" }} /></div>
        ) : tab === "write" ? (
          <textarea
            className="flex-1 p-5 bg-surface text-primary text-sm font-mono resize-none outline-none border-none leading-relaxed"
            style={{ minHeight: "400px" }}
            value={content}
            onChange={(e) => { setContent(e.target.value); setSaved(false); }}
            placeholder="Write the answer in Markdown…"
            spellCheck={false}
          />
        ) : (
          <div className="flex-1 overflow-y-auto p-5">
            {content ? (
              <div className="prose-answer" dangerouslySetInnerHTML={{ __html: renderMarkdown(content) }} />
            ) : (
              <p className="text-sm text-ghost text-center py-8">Nothing to preview yet</p>
            )}
          </div>
        )}
      </div>
    </Modal>
  );
}

/* ── Topic Form ──────────────────────────────────────────────── */
function TopicForm({ initial, onSave, onClose }) {
  const [label, setLabel] = useState(initial?.label || "");
  const [emoji, setEmoji] = useState(initial?.icon_emoji || "");
  const [color, setColor] = useState(initial?.color_hex || "#6366f1");
  const [order, setOrder] = useState(String(initial?.display_order ?? ""));
  const [saving, setSaving] = useState(false);

  async function submit(e) {
    e.preventDefault();
    if (!label.trim()) return;
    setSaving(true);
    try {
      const payload = { label: label.trim(), icon_emoji: emoji.trim() || null, color_hex: color, display_order: Number(order) || 0 };
      await onSave(payload);
      onClose();
    } catch (err) { alert(err.message); }
    setSaving(false);
  }

  return (
    <Modal title={initial ? "Edit Topic" : "New Topic"} onClose={onClose}>
      <form onSubmit={submit} className="p-5 space-y-4">
        <Input label="Topic Name" value={label} onChange={setLabel} placeholder="e.g. React" required />
        <Input label="Emoji Icon" value={emoji} onChange={setEmoji} placeholder="e.g. ⚛️" />
        <label className="flex flex-col gap-1">
          <span className="text-xs font-medium text-soft">Color</span>
          <div className="flex items-center gap-2">
            <input type="color" value={color} onChange={(e) => setColor(e.target.value)} className="w-9 h-9 rounded cursor-pointer border border-border bg-transparent" />
            <span className="text-xs text-muted font-mono">{color}</span>
          </div>
        </label>
        <Input label="Display Order" value={order} onChange={setOrder} type="number" placeholder="0" />
        <div className="flex gap-2 justify-end pt-2">
          <Btn onClick={onClose}>Cancel</Btn>
          <Btn variant="primary" disabled={saving}>{saving ? "Saving…" : "Save"}</Btn>
        </div>
      </form>
    </Modal>
  );
}

/* ── Section Form ────────────────────────────────────────────── */
function SectionForm({ topicId, initial, onSave, onClose }) {
  const [label, setLabel] = useState(initial?.label || "");
  const [order, setOrder] = useState(String(initial?.display_order ?? ""));
  const [saving, setSaving] = useState(false);

  async function submit(e) {
    e.preventDefault();
    if (!label.trim()) return;
    setSaving(true);
    try {
      await onSave({ label: label.trim(), display_order: Number(order) || 0, topic_id: topicId });
      onClose();
    } catch (err) { alert(err.message); }
    setSaving(false);
  }

  return (
    <Modal title={initial ? "Edit Section" : "New Section"} onClose={onClose}>
      <form onSubmit={submit} className="p-5 space-y-4">
        <Input label="Section Name" value={label} onChange={setLabel} placeholder="e.g. Hooks" required />
        <Input label="Display Order" value={order} onChange={setOrder} type="number" placeholder="0" />
        <div className="flex gap-2 justify-end pt-2">
          <Btn onClick={onClose}>Cancel</Btn>
          <Btn variant="primary" disabled={saving}>{saving ? "Saving…" : "Save"}</Btn>
        </div>
      </form>
    </Modal>
  );
}

/* ── Question Form ───────────────────────────────────────────── */
function QuestionForm({ sectionId, initial, onSave, onClose }) {
  const [text, setText] = useState(initial?.text || "");
  const [diffId, setDiffId] = useState(String(initial?.difficulty_id || ""));
  const [serial, setSerial] = useState(String(initial?.serial_number ?? ""));
  const [levels, setLevels] = useState([]);
  const [saving, setSaving] = useState(false);

  useEffect(() => {
    adminGetDifficultyLevels().then(setLevels).catch(console.error);
  }, []);

  async function submit(e) {
    e.preventDefault();
    if (!text.trim()) return;
    setSaving(true);
    try {
      await onSave({
        text: text.trim(),
        difficulty_id: diffId ? Number(diffId) : null,
        serial_number: Number(serial) || 0,
        section_id: sectionId,
      });
      onClose();
    } catch (err) { alert(err.message); }
    setSaving(false);
  }

  return (
    <Modal title={initial ? "Edit Question" : "New Question"} onClose={onClose}>
      <form onSubmit={submit} className="p-5 space-y-4">
        <label className="flex flex-col gap-1">
          <span className="text-xs font-medium text-soft">Question Text<span className="text-danger ml-0.5">*</span></span>
          <textarea
            value={text}
            onChange={(e) => setText(e.target.value)}
            placeholder="What is…?"
            rows={3}
            className="px-3 py-2 rounded-lg bg-surface border border-border text-primary text-sm outline-none focus:border-accent transition-colors resize-none"
          />
        </label>
        <label className="flex flex-col gap-1">
          <span className="text-xs font-medium text-soft">Difficulty</span>
          <select
            value={diffId}
            onChange={(e) => setDiffId(e.target.value)}
            className="h-9 px-3 rounded-lg bg-surface border border-border text-primary text-sm outline-none focus:border-accent cursor-pointer"
          >
            <option value="">— Select —</option>
            {levels.map((l) => <option key={l.id} value={l.id}>{l.label}</option>)}
          </select>
        </label>
        <Input label="Serial Number" value={serial} onChange={setSerial} type="number" placeholder="1" />
        <div className="flex gap-2 justify-end pt-2">
          <Btn onClick={onClose}>Cancel</Btn>
          <Btn variant="primary" disabled={saving}>{saving ? "Saving…" : "Save"}</Btn>
        </div>
      </form>
    </Modal>
  );
}

/* ── Content Management (Topics → Sections → Questions) ─────── */
function AdminContent() {
  const [topics, setTopics] = useState([]);
  const [activeTopic, setActiveTopic] = useState(null);
  const [sections, setSections] = useState([]);
  const [activeSection, setActiveSection] = useState(null);
  const [questions, setQuestions] = useState([]);
  const [loading, setLoading] = useState(false);

  const [topicForm, setTopicForm] = useState(null);
  const [sectionForm, setSectionForm] = useState(null);
  const [questionForm, setQuestionForm] = useState(null);
  const [answerEditor, setAnswerEditor] = useState(null);
  const [confirmDel, setConfirmDel] = useState(null);

  useEffect(() => {
    setLoading(true);
    adminGetTopics().then((data) => { setTopics(data); setLoading(false); }).catch(console.error);
  }, []);

  useEffect(() => {
    if (!activeTopic) { setSections([]); setActiveSection(null); return; }
    adminGetSections(activeTopic.id).then(setSections).catch(console.error);
    setActiveSection(null);
  }, [activeTopic?.id]);

  useEffect(() => {
    if (!activeSection) { setQuestions([]); return; }
    adminGetQuestions(activeSection.id).then(setQuestions).catch(console.error);
  }, [activeSection?.id]);

  function refreshTopics() { adminGetTopics().then(setTopics); }
  function refreshSections() { adminGetSections(activeTopic.id).then(setSections); }
  function refreshQuestions() { adminGetQuestions(activeSection.id).then(setQuestions); }

  async function handleDelete() {
    const { type, id } = confirmDel;
    try {
      if (type === "topic")    { await adminDeleteTopic(id);    refreshTopics(); setActiveTopic(null); }
      if (type === "section")  { await adminDeleteSection(id);  refreshSections(); setActiveSection(null); }
      if (type === "question") { await adminDeleteQuestion(id); refreshQuestions(); }
    } catch (e) { alert(e.message); }
    setConfirmDel(null);
  }

  function ColHeader({ icon: Icon, label, count, onAdd, addLabel }) {
    return (
      <div className="flex items-center justify-between px-4 py-3 border-b border-border bg-panel/80 shrink-0">
        <div className="flex items-center gap-2">
          <Icon size={13} strokeWidth={1.8} className="text-ghost" />
          <span className="text-[11px] font-bold tracking-widest uppercase text-ghost">{label}</span>
          {count != null && (
            <span className="text-[10px] font-semibold text-ghost bg-hover px-1.5 py-0.5 rounded-md tabular-nums">{count}</span>
          )}
        </div>
        {onAdd && (
          <button
            onClick={onAdd}
            title={addLabel}
            className="w-6 h-6 rounded-md bg-accent/10 border border-accent/20 text-accent hover:bg-accent/20 flex items-center justify-center cursor-pointer transition-colors"
          >
            <Plus size={12} strokeWidth={2.5} />
          </button>
        )}
      </div>
    );
  }

  function RowActions({ onEdit, onDelete }) {
    return (
      <div className="flex gap-1 opacity-0 group-hover:opacity-100 transition-opacity shrink-0">
        <button
          onClick={(e) => { e.stopPropagation(); onEdit(); }}
          className="w-6 h-6 rounded-md bg-hover hover:bg-border text-ghost hover:text-muted flex items-center justify-center cursor-pointer transition-colors"
          title="Edit"
        >
          <Pencil size={10} strokeWidth={2} />
        </button>
        <button
          onClick={(e) => { e.stopPropagation(); onDelete(); }}
          className="w-6 h-6 rounded-md hover:bg-danger/10 text-ghost hover:text-danger flex items-center justify-center cursor-pointer transition-colors"
          title="Delete"
        >
          <Trash2 size={10} strokeWidth={2} />
        </button>
      </div>
    );
  }

  function diffBadge(label) {
    const map = { Basic: "text-success bg-success/10", Intermediate: "text-warning bg-warning/10", Advanced: "text-danger bg-danger/10" };
    return map[label] || "text-muted bg-hover";
  }

  return (
    <div className="flex flex-col h-full overflow-hidden">

      {/* Breadcrumb bar */}
      <div className="flex items-center gap-1.5 px-5 py-2.5 border-b border-border bg-surface/60 shrink-0">
        <span className="text-[11px] text-ghost font-medium">Content</span>
        {activeTopic && (
          <>
            <ChevronRight size={11} className="text-ghost" />
            <button onClick={() => { setActiveSection(null); }}
              className="text-[11px] text-soft hover:text-primary font-medium transition-colors cursor-pointer">{activeTopic.label}</button>
          </>
        )}
        {activeSection && (
          <>
            <ChevronRight size={11} className="text-ghost" />
            <span className="text-[11px] text-accent font-medium">{activeSection.label}</span>
          </>
        )}
      </div>

      <div className="flex flex-1 overflow-hidden">

        {/* ── Topics column ── */}
        <div className="w-56 shrink-0 border-r border-border flex flex-col overflow-hidden">
          <ColHeader icon={Layers} label="Topics" count={topics.length} onAdd={() => setTopicForm("new")} addLabel="New Topic" />
          <div className="flex-1 overflow-y-auto py-1.5">
            {loading && (
              <div className="space-y-1 px-2">
                {[1,2,3,4].map(i => <div key={i} className="h-8 bg-hover rounded-lg animate-pulse" />)}
              </div>
            )}
            {topics.map((t) => {
              const isActive = activeTopic?.id === t.id;
              return (
                <div
                  key={t.id}
                  onClick={() => setActiveTopic(t)}
                  className={`flex items-center gap-2.5 mx-2 px-3 py-2 rounded-lg cursor-pointer group transition-all mb-0.5 ${
                    isActive ? "bg-accent/10 border border-accent/20" : "hover:bg-hover border border-transparent"
                  }`}
                >
                  <div className={`w-1.5 h-1.5 rounded-full shrink-0 ${isActive ? "bg-accent" : "bg-ghost"}`} />
                  <span className={`flex-1 text-xs font-medium truncate ${isActive ? "text-bright" : "text-muted"}`}>
                    {t.label}
                  </span>
                  <RowActions
                    onEdit={() => setTopicForm(t)}
                    onDelete={() => setConfirmDel({ type: "topic", id: t.id, label: t.label })}
                  />
                </div>
              );
            })}
            {!loading && topics.length === 0 && (
              <div className="flex flex-col items-center py-8 px-4 text-center">
                <Layers size={20} className="text-ghost mb-2" strokeWidth={1.5} />
                <p className="text-xs text-ghost">No topics yet</p>
              </div>
            )}
          </div>
        </div>

        {/* ── Sections column ── */}
        <div className="w-56 shrink-0 border-r border-border flex flex-col overflow-hidden">
          <ColHeader
            icon={Database}
            label="Sections"
            count={activeTopic ? sections.length : null}
            onAdd={activeTopic ? () => setSectionForm("new") : null}
            addLabel="New Section"
          />
          <div className="flex-1 overflow-y-auto py-1.5">
            {!activeTopic ? (
              <div className="flex flex-col items-center py-10 px-4 text-center">
                <ChevronRight size={18} className="text-ghost mb-2" strokeWidth={1.5} />
                <p className="text-xs text-ghost">Select a topic</p>
              </div>
            ) : sections.length === 0 ? (
              <div className="flex flex-col items-center py-10 px-4 text-center">
                <Database size={18} className="text-ghost mb-2" strokeWidth={1.5} />
                <p className="text-xs text-ghost">No sections yet</p>
              </div>
            ) : (
              sections.map((s) => {
                const isActive = activeSection?.id === s.id;
                return (
                  <div
                    key={s.id}
                    onClick={() => setActiveSection(s)}
                    className={`flex items-center gap-2.5 mx-2 px-3 py-2 rounded-lg cursor-pointer group transition-all mb-0.5 ${
                      isActive ? "bg-accent/10 border border-accent/20" : "hover:bg-hover border border-transparent"
                    }`}
                  >
                    <div className={`w-1.5 h-1.5 rounded-full shrink-0 ${isActive ? "bg-accent" : "bg-ghost"}`} />
                    <span className={`flex-1 text-xs font-medium truncate ${isActive ? "text-bright" : "text-muted"}`}>
                      {s.label}
                    </span>
                    <RowActions
                      onEdit={() => setSectionForm(s)}
                      onDelete={() => setConfirmDel({ type: "section", id: s.id, label: s.label })}
                    />
                  </div>
                );
              })
            )}
          </div>
        </div>

        {/* ── Questions panel ── */}
        <div className="flex-1 flex flex-col overflow-hidden">
          <div className="flex items-center justify-between px-5 py-3 border-b border-border shrink-0 bg-panel/80">
            <div className="flex items-center gap-2">
              <HelpCircle size={13} strokeWidth={1.8} className="text-ghost" />
              <span className="text-[11px] font-bold tracking-widest uppercase text-ghost">Questions</span>
              {questions.length > 0 && (
                <span className="text-[10px] font-semibold text-ghost bg-hover px-1.5 py-0.5 rounded-md tabular-nums">{questions.length}</span>
              )}
            </div>
            {activeSection && (
              <button
                onClick={() => setQuestionForm("new")}
                className="flex items-center gap-1.5 h-7 px-3 rounded-lg bg-accent hover:bg-accent-hover text-white text-xs font-semibold transition-colors cursor-pointer"
              >
                <Plus size={12} strokeWidth={2.5} />
                New Question
              </button>
            )}
          </div>

          <div className="flex-1 overflow-y-auto">
            {!activeSection ? (
              <div className="flex flex-col items-center justify-center h-full text-center py-10">
                <div className="w-12 h-12 rounded-xl bg-hover border border-border flex items-center justify-center mb-3">
                  <HelpCircle size={20} className="text-ghost" strokeWidth={1.5} />
                </div>
                <p className="text-sm font-medium text-ghost">Select a section</p>
                <p className="text-xs text-ghost mt-1">Questions will appear here</p>
              </div>
            ) : questions.length === 0 ? (
              <div className="flex flex-col items-center justify-center h-full text-center py-10">
                <div className="w-12 h-12 rounded-xl bg-hover border border-border flex items-center justify-center mb-3">
                  <Plus size={20} className="text-ghost" strokeWidth={1.5} />
                </div>
                <p className="text-sm font-medium text-ghost">No questions yet</p>
                <p className="text-xs text-ghost mt-1">Add the first question above</p>
              </div>
            ) : (
              <table className="w-full text-sm">
                <thead className="sticky top-0 bg-panel z-10 border-b border-border">
                  <tr>
                    <th className="text-left px-5 py-2.5 text-[10px] font-bold tracking-wider uppercase text-ghost w-10">#</th>
                    <th className="text-left px-4 py-2.5 text-[10px] font-bold tracking-wider uppercase text-ghost">Question</th>
                    <th className="text-left px-4 py-2.5 text-[10px] font-bold tracking-wider uppercase text-ghost w-28">Difficulty</th>
                    <th className="text-right px-5 py-2.5 text-[10px] font-bold tracking-wider uppercase text-ghost w-40">Actions</th>
                  </tr>
                </thead>
                <tbody>
                  {questions.map((q) => (
                    <tr key={q.id} className="border-b border-border/40 hover:bg-hover/30 group transition-colors">
                      <td className="px-5 py-3 text-ghost text-[11px] tabular-nums font-mono">{q.serial_number}</td>
                      <td className="px-4 py-3 text-primary text-xs leading-relaxed">{q.text}</td>
                      <td className="px-4 py-3">
                        {q.difficulty_levels?.label ? (
                          <span className={`text-[10px] font-semibold px-2 py-0.5 rounded-md ${diffBadge(q.difficulty_levels.label)}`}>
                            {q.difficulty_levels.label}
                          </span>
                        ) : (
                          <span className="text-[10px] text-ghost">—</span>
                        )}
                      </td>
                      <td className="px-5 py-3">
                        <div className="flex gap-1.5 justify-end">
                          <button
                            onClick={() => setAnswerEditor(q)}
                            className="flex items-center gap-1 h-7 px-2.5 rounded-lg bg-hover hover:bg-border border border-border text-xs font-medium text-muted hover:text-primary transition-colors cursor-pointer"
                          >
                            <Eye size={11} strokeWidth={1.8} />
                            Answer
                          </button>
                          <button
                            onClick={() => setQuestionForm(q)}
                            className="w-7 h-7 rounded-lg bg-hover hover:bg-border border border-border text-ghost hover:text-muted flex items-center justify-center cursor-pointer transition-colors"
                            title="Edit"
                          >
                            <Pencil size={11} strokeWidth={1.8} />
                          </button>
                          <button
                            onClick={() => setConfirmDel({ type: "question", id: q.id, label: q.text.slice(0, 50) })}
                            className="w-7 h-7 rounded-lg hover:bg-danger/10 border border-transparent hover:border-danger/20 text-ghost hover:text-danger flex items-center justify-center cursor-pointer transition-colors"
                            title="Delete"
                          >
                            <Trash2 size={11} strokeWidth={1.8} />
                          </button>
                        </div>
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
            )}
          </div>
        </div>
      </div>

      {/* ── Modals ── */}
      {topicForm && (
        <TopicForm
          initial={topicForm === "new" ? null : topicForm}
          onSave={topicForm === "new"
            ? (p) => adminCreateTopic(p).then(refreshTopics)
            : (p) => adminUpdateTopic(topicForm.id, p).then(refreshTopics)}
          onClose={() => setTopicForm(null)}
        />
      )}
      {sectionForm && activeTopic && (
        <SectionForm
          topicId={activeTopic.id}
          initial={sectionForm === "new" ? null : sectionForm}
          onSave={sectionForm === "new"
            ? (p) => adminCreateSection(p).then(refreshSections)
            : (p) => adminUpdateSection(sectionForm.id, p).then(refreshSections)}
          onClose={() => setSectionForm(null)}
        />
      )}
      {questionForm && activeSection && (
        <QuestionForm
          sectionId={activeSection.id}
          initial={questionForm === "new" ? null : questionForm}
          onSave={questionForm === "new"
            ? (p) => adminCreateQuestion(p).then(refreshQuestions)
            : (p) => adminUpdateQuestion(questionForm.id, p).then(refreshQuestions)}
          onClose={() => setQuestionForm(null)}
        />
      )}
      {answerEditor && (
        <AnswerEditor
          questionId={answerEditor.id}
          questionText={answerEditor.text}
          onClose={() => setAnswerEditor(null)}
        />
      )}
      {confirmDel && (
        <ConfirmModal
          message={`Delete "${confirmDel.label}"? This cannot be undone.`}
          onConfirm={handleDelete}
          onClose={() => setConfirmDel(null)}
        />
      )}
    </div>
  );
}

/* ── Users ───────────────────────────────────────────────────── */
function AdminUsers() {
  const [users, setUsers] = useState([]);
  const [loading, setLoading] = useState(true);
  const [expanding, setExpanding] = useState({});
  const [stats, setStats] = useState({});
  const [search, setSearch] = useState("");

  useEffect(() => {
    adminGetUsers(100).then((data) => { setUsers(data); setLoading(false); }).catch(console.error);
  }, []);

  async function toggleStats(userId) {
    if (stats[userId]) {
      setStats((p) => { const n = { ...p }; delete n[userId]; return n; });
      return;
    }
    setExpanding((p) => ({ ...p, [userId]: true }));
    const s = await adminGetUserStats(userId).catch(() => null);
    setExpanding((p) => { const n = { ...p }; delete n[userId]; return n; });
    if (s) setStats((p) => ({ ...p, [userId]: s }));
  }

  async function handleRoleChange(userId, newRole) {
    try {
      await adminSetUserRole(userId, newRole);
      setUsers((prev) => prev.map((u) => u.id === userId ? { ...u, role: newRole } : u));
    } catch (e) { alert(e.message); }
  }

  const filtered = users.filter((u) =>
    !search ||
    u.email.toLowerCase().includes(search.toLowerCase()) ||
    (u.full_name || "").toLowerCase().includes(search.toLowerCase())
  );

  function initials(u) {
    if (u.full_name) return u.full_name.split(" ").map(n => n[0]).join("").slice(0, 2).toUpperCase();
    return u.email.slice(0, 2).toUpperCase();
  }

  function avatarColor(email) {
    const colors = [
      "bg-accent/20 text-accent", "bg-success/20 text-success",
      "bg-warning/20 text-warning", "bg-violet-500/20 text-violet-400",
      "bg-blue-500/20 text-blue-400", "bg-pink-500/20 text-pink-400",
    ];
    const idx = email.charCodeAt(0) % colors.length;
    return colors[idx];
  }

  const adminCount = users.filter(u => u.role === "admin").length;
  const userCount = users.filter(u => u.role !== "admin").length;

  return (
    <div className="p-6 space-y-5 overflow-y-auto h-full">

      {/* Header */}
      <div className="flex items-center justify-between gap-4 flex-wrap">
        <div>
          <h1 className="text-xl font-bold text-heading">Users</h1>
          <p className="text-sm text-muted mt-0.5">{users.length} registered accounts</p>
        </div>

        {/* Quick stats */}
        <div className="flex items-center gap-3">
          <div className="flex items-center gap-2 px-3 py-1.5 rounded-lg bg-panel border border-border">
            <Users size={12} className="text-muted" strokeWidth={1.8} />
            <span className="text-xs text-muted tabular-nums">{userCount} users</span>
          </div>
          <div className="flex items-center gap-2 px-3 py-1.5 rounded-lg bg-accent/10 border border-accent/20">
            <Crown size={12} className="text-accent" strokeWidth={1.8} />
            <span className="text-xs text-accent tabular-nums font-medium">{adminCount} admins</span>
          </div>
        </div>
      </div>

      {/* Search */}
      <div className="relative">
        <Search size={13} className="absolute left-3 top-1/2 -translate-y-1/2 text-ghost" strokeWidth={1.8} />
        <input
          className="w-full h-9 pl-9 pr-4 rounded-lg bg-panel border border-border text-primary text-sm outline-none focus:border-accent transition-colors placeholder:text-ghost"
          placeholder="Search by email or name…"
          value={search}
          onChange={(e) => setSearch(e.target.value)}
        />
        {search && (
          <button onClick={() => setSearch("")}
            className="absolute right-3 top-1/2 -translate-y-1/2 text-ghost hover:text-muted cursor-pointer">
            <X size={12} strokeWidth={2} />
          </button>
        )}
      </div>

      {/* Table */}
      <div className="bg-panel border border-border rounded-xl overflow-hidden">
        {loading ? (
          <div className="space-y-0">
            {[1,2,3].map(i => (
              <div key={i} className="flex items-center gap-4 px-5 py-4 border-b border-border/50">
                <div className="w-8 h-8 rounded-full bg-hover animate-pulse" />
                <div className="flex-1 space-y-1.5">
                  <div className="h-3 bg-hover rounded animate-pulse w-48" />
                  <div className="h-2.5 bg-hover rounded animate-pulse w-32" />
                </div>
              </div>
            ))}
          </div>
        ) : (
          <table className="w-full text-sm">
            <thead>
              <tr className="border-b border-border">
                <th className="text-left px-5 py-3 text-[10px] font-bold tracking-wider uppercase text-ghost">User</th>
                <th className="text-left px-4 py-3 text-[10px] font-bold tracking-wider uppercase text-ghost">Provider</th>
                <th className="text-left px-4 py-3 text-[10px] font-bold tracking-wider uppercase text-ghost">Role</th>
                <th className="text-left px-4 py-3 text-[10px] font-bold tracking-wider uppercase text-ghost">Joined</th>
                <th className="text-right px-5 py-3 text-[10px] font-bold tracking-wider uppercase text-ghost">Activity</th>
              </tr>
            </thead>
            <tbody>
              {filtered.map((u) => (
                <>
                  <tr key={u.id} className="border-b border-border/40 hover:bg-hover/30 transition-colors group">
                    <td className="px-5 py-3.5">
                      <div className="flex items-center gap-3">
                        <div className={`w-8 h-8 rounded-full flex items-center justify-center text-[11px] font-bold shrink-0 ${avatarColor(u.email)}`}>
                          {initials(u)}
                        </div>
                        <div className="min-w-0">
                          <p className="text-xs font-semibold text-primary truncate">{u.email}</p>
                          {u.full_name && <p className="text-[11px] text-muted">{u.full_name}</p>}
                        </div>
                      </div>
                    </td>
                    <td className="px-4 py-3.5">
                      <span className="text-[11px] text-muted capitalize bg-hover px-2 py-0.5 rounded-md border border-border">
                        {u.provider || "email"}
                      </span>
                    </td>
                    <td className="px-4 py-3.5">
                      <select
                        value={u.role}
                        onChange={(e) => handleRoleChange(u.id, e.target.value)}
                        className={`text-[11px] font-semibold px-2.5 py-1 rounded-lg border cursor-pointer outline-none transition-colors ${
                          u.role === "admin"
                            ? "bg-accent/10 border-accent/30 text-accent"
                            : "bg-hover border-border text-muted"
                        }`}
                      >
                        <option value="user">user</option>
                        <option value="admin">admin</option>
                      </select>
                    </td>
                    <td className="px-4 py-3.5 text-[11px] text-muted tabular-nums">
                      {new Date(u.created_at).toLocaleDateString("en", { month: "short", day: "numeric", year: "numeric" })}
                    </td>
                    <td className="px-5 py-3.5 text-right">
                      <button
                        onClick={() => toggleStats(u.id)}
                        disabled={!!expanding[u.id]}
                        className={`flex items-center gap-1.5 h-7 px-3 rounded-lg text-[11px] font-medium transition-colors cursor-pointer disabled:opacity-40 ml-auto ${
                          stats[u.id]
                            ? "bg-accent/10 border border-accent/20 text-accent"
                            : "bg-hover border border-border text-muted hover:text-primary hover:border-accent/30"
                        }`}
                      >
                        <TrendingUp size={10} strokeWidth={2} />
                        {expanding[u.id] ? "Loading…" : stats[u.id] ? "Hide" : "Stats"}
                      </button>
                    </td>
                  </tr>
                  {stats[u.id] && (
                    <tr key={`${u.id}-stats`} className="border-b border-border/40 bg-accent/3">
                      <td colSpan={5} className="px-5 py-3">
                        <div className="flex items-center gap-5 flex-wrap">
                          {[
                            { label: "Total Tracked", value: stats[u.id].total, cls: "text-primary" },
                            { label: "Completed",     value: stats[u.id].done, cls: "text-success" },
                            { label: "In Progress",   value: stats[u.id].inProgress, cls: "text-warning" },
                          ].map(({ label, value, cls }) => (
                            <div key={label} className="flex items-center gap-2">
                              <div className={`w-1.5 h-1.5 rounded-full ${cls.replace("text-", "bg-")}`} />
                              <span className="text-[11px] text-muted">{label}:</span>
                              <span className={`text-[11px] font-semibold tabular-nums ${cls}`}>{value}</span>
                            </div>
                          ))}
                          {stats[u.id].total > 0 && (
                            <div className="flex items-center gap-2 ml-auto">
                              <div className="w-24 h-1.5 bg-hover rounded-full overflow-hidden">
                                <div className="h-full bg-success rounded-full transition-all"
                                  style={{ width: `${Math.round((stats[u.id].done / stats[u.id].total) * 100)}%` }} />
                              </div>
                              <span className="text-[10px] text-muted tabular-nums">
                                {Math.round((stats[u.id].done / stats[u.id].total) * 100)}% done
                              </span>
                            </div>
                          )}
                        </div>
                      </td>
                    </tr>
                  )}
                </>
              ))}
              {filtered.length === 0 && (
                <tr>
                  <td colSpan={5} className="text-center py-12">
                    <Search size={20} className="text-ghost mx-auto mb-2" strokeWidth={1.5} />
                    <p className="text-xs text-ghost">No users found for "{search}"</p>
                  </td>
                </tr>
              )}
            </tbody>
          </table>
        )}
      </div>
    </div>
  );
}

/* ── Bulk Import ─────────────────────────────────────────────── */
function parseCsv(text) {
  const lines = text.trim().split(/\r?\n/);
  if (lines.length < 2) return [];
  const headers = lines[0].split(",").map(h => h.trim().replace(/^"|"$/g, "").toLowerCase());
  return lines.slice(1).map((line, i) => {
    // Handle quoted fields
    const cols = [];
    let cur = ""; let inQ = false;
    for (let c = 0; c < line.length; c++) {
      const ch = line[c];
      if (ch === '"') { inQ = !inQ; }
      else if (ch === "," && !inQ) { cols.push(cur.trim()); cur = ""; }
      else cur += ch;
    }
    cols.push(cur.trim());
    const row = {};
    headers.forEach((h, idx) => { row[h] = (cols[idx] || "").replace(/^"|"$/g, ""); });
    row._index = i + 2;
    return row;
  });
}

function AdminBulkImport() {
  const [topics, setTopics] = useState([]);
  const [sections, setSections] = useState([]);
  const [levels, setLevels] = useState([]);
  const [selectedTopic, setSelectedTopic] = useState("");
  const [selectedSection, setSelectedSection] = useState("");
  const [rows, setRows] = useState([]);
  const [errors, setErrors] = useState([]);
  const [importing, setImporting] = useState(false);
  const [result, setResult] = useState(null);
  const [dragOver, setDragOver] = useState(false);
  const fileRef = useRef(null);

  useEffect(() => {
    adminGetTopics().then(setTopics);
    adminGetDifficultyLevels().then(setLevels);
  }, []);

  useEffect(() => {
    if (!selectedTopic) { setSections([]); setSelectedSection(""); return; }
    adminGetSections(Number(selectedTopic)).then(data => { setSections(data); setSelectedSection(""); });
  }, [selectedTopic]);

  function processFile(file) {
    if (!file) return;
    const ext = file.name.split(".").pop().toLowerCase();
    const reader = new FileReader();
    reader.onload = (e) => {
      try {
        let parsed = [];
        if (ext === "json") {
          parsed = JSON.parse(e.target.result);
          if (!Array.isArray(parsed)) parsed = [parsed];
        } else {
          parsed = parseCsv(e.target.result);
        }
        setRows(parsed);
        setErrors([]);
        setResult(null);
      } catch (err) {
        setErrors([`Parse error: ${err.message}`]);
      }
    };
    reader.readAsText(file);
  }

  function handleDrop(e) {
    e.preventDefault(); setDragOver(false);
    const file = e.dataTransfer.files[0];
    processFile(file);
  }

  function validateRows() {
    const errs = [];
    const levelNames = levels.map(l => l.label.toLowerCase());
    rows.forEach((r, i) => {
      const num = i + 1;
      if (!r.text && !r.question) errs.push(`Row ${num}: missing "text" field`);
      if (r.difficulty && !levelNames.includes(r.difficulty.toLowerCase()))
        errs.push(`Row ${num}: unknown difficulty "${r.difficulty}" (valid: ${levels.map(l=>l.label).join(", ")})`);
    });
    return errs;
  }

  async function handleImport() {
    if (!selectedSection) { setErrors(["Select a section first"]); return; }
    const errs = validateRows();
    if (errs.length) { setErrors(errs); return; }
    setImporting(true); setErrors([]); setResult(null);
    try {
      const levelMap = {};
      levels.forEach(l => { levelMap[l.label.toLowerCase()] = l.id; });
      const payload = rows.map((r, i) => ({
        text: (r.text || r.question || "").trim(),
        serial_number: r.serial_number ? Number(r.serial_number) : i + 1,
        difficulty_id: r.difficulty ? (levelMap[r.difficulty.toLowerCase()] || null) : null,
        section_id: Number(selectedSection),
      })).filter(r => r.text);
      const created = await adminBulkCreateQuestions(payload);
      setResult({ count: created.length });
      setRows([]);
    } catch (err) {
      setErrors([err.message]);
    }
    setImporting(false);
  }

  function downloadTemplate() {
    const csv = `serial_number,text,difficulty\n1,"What is dependency injection?",Basic\n2,"Explain SOLID principles",Intermediate\n3,"What is the difference between abstract class and interface?",Advanced`;
    const blob = new Blob([csv], { type: "text/csv" });
    const a = document.createElement("a"); a.href = URL.createObjectURL(blob);
    a.download = "devready_import_template.csv"; a.click();
  }

  return (
    <div className="p-6 space-y-6 overflow-y-auto h-full">
      <div className="flex items-start justify-between">
        <div>
          <h1 className="text-xl font-bold text-heading">Bulk Import Questions</h1>
          <p className="text-sm text-muted mt-0.5">Upload a CSV or JSON file to add multiple questions at once</p>
        </div>
        <button onClick={downloadTemplate}
          className="flex items-center gap-2 h-9 px-4 rounded-lg bg-hover border border-border text-xs font-semibold text-muted hover:text-primary hover:border-accent/30 transition-all cursor-pointer">
          <Download size={13} strokeWidth={1.8} />
          Download Template
        </button>
      </div>

      {/* Format guide */}
      <div className="bg-panel border border-border rounded-xl p-5">
        <p className="text-xs font-semibold text-soft mb-3 flex items-center gap-2">
          <Table2 size={13} strokeWidth={1.8} className="text-accent" />
          Expected Format
        </p>
        <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
          <div>
            <p className="text-[10px] font-bold uppercase text-ghost mb-1.5">CSV columns</p>
            {[
              { col: "text", desc: "Question text (required)", req: true },
              { col: "serial_number", desc: "Order in section (auto if omitted)", req: false },
              { col: "difficulty", desc: "Basic / Intermediate / Advanced", req: false },
            ].map(({ col, desc, req }) => (
              <div key={col} className="flex items-start gap-2 mb-1">
                <code className={`text-[10px] px-1.5 py-0.5 rounded font-mono ${req ? "bg-accent/10 text-accent" : "bg-hover text-muted"}`}>{col}</code>
                <span className="text-[11px] text-muted">{desc}</span>
              </div>
            ))}
          </div>
          <div>
            <p className="text-[10px] font-bold uppercase text-ghost mb-1.5">JSON format</p>
            <pre className="text-[11px] text-muted bg-hover/60 rounded-lg p-3 font-mono overflow-auto">{`[
  {
    "text": "What is C#?",
    "difficulty": "Basic",
    "serial_number": 1
  }
]`}</pre>
          </div>
        </div>
      </div>

      {/* Section selector */}
      <div className="grid grid-cols-2 gap-3">
        <label className="flex flex-col gap-1">
          <span className="text-xs font-medium text-soft">Topic <span className="text-danger">*</span></span>
          <select value={selectedTopic} onChange={e => setSelectedTopic(e.target.value)}
            className="h-9 px-3 rounded-lg bg-panel border border-border text-primary text-sm outline-none focus:border-accent cursor-pointer">
            <option value="">— Select topic —</option>
            {topics.map(t => <option key={t.id} value={t.id}>{t.label}</option>)}
          </select>
        </label>
        <label className="flex flex-col gap-1">
          <span className="text-xs font-medium text-soft">Section <span className="text-danger">*</span></span>
          <select value={selectedSection} onChange={e => setSelectedSection(e.target.value)}
            disabled={!selectedTopic}
            className="h-9 px-3 rounded-lg bg-panel border border-border text-primary text-sm outline-none focus:border-accent cursor-pointer disabled:opacity-40">
            <option value="">— Select section —</option>
            {sections.map(s => <option key={s.id} value={s.id}>{s.label}</option>)}
          </select>
        </label>
      </div>

      {/* Drop zone */}
      <div
        onDragOver={e => { e.preventDefault(); setDragOver(true); }}
        onDragLeave={() => setDragOver(false)}
        onDrop={handleDrop}
        onClick={() => fileRef.current?.click()}
        className={`border-2 border-dashed rounded-xl p-10 text-center cursor-pointer transition-all ${
          dragOver ? "border-accent bg-accent/5" : "border-border hover:border-accent/40 hover:bg-hover/30"
        }`}
      >
        <input ref={fileRef} type="file" accept=".csv,.json" className="hidden"
          onChange={e => processFile(e.target.files[0])} />
        <Upload size={28} className="text-ghost mx-auto mb-3" strokeWidth={1.5} />
        <p className="text-sm font-semibold text-soft">Drop CSV or JSON file here</p>
        <p className="text-xs text-muted mt-1">or click to browse</p>
        <p className="text-[10px] text-ghost mt-3">Supports .csv and .json files</p>
      </div>

      {/* Errors */}
      {errors.length > 0 && (
        <div className="bg-danger/5 border border-danger/20 rounded-xl p-4 space-y-1">
          <div className="flex items-center gap-2 mb-2">
            <AlertTriangle size={13} className="text-danger" strokeWidth={2} />
            <p className="text-xs font-semibold text-danger">Issues found</p>
          </div>
          {errors.map((e, i) => <p key={i} className="text-xs text-danger/80 pl-5">{e}</p>)}
        </div>
      )}

      {/* Success */}
      {result && (
        <div className="bg-success/5 border border-success/20 rounded-xl p-4 flex items-center gap-3">
          <CheckCircle size={16} className="text-success" strokeWidth={2} />
          <p className="text-sm font-semibold text-success">
            Successfully imported {result.count} question{result.count !== 1 ? "s" : ""}!
          </p>
        </div>
      )}

      {/* Preview table */}
      {rows.length > 0 && (
        <div className="bg-panel border border-border rounded-xl overflow-hidden">
          <div className="flex items-center justify-between px-5 py-3 border-b border-border">
            <div className="flex items-center gap-2">
              <Table2 size={13} className="text-accent" strokeWidth={1.8} />
              <p className="text-sm font-semibold text-soft">Preview — {rows.length} rows</p>
            </div>
            <button
              onClick={handleImport}
              disabled={importing || !selectedSection}
              className="flex items-center gap-2 h-8 px-4 rounded-lg bg-accent hover:bg-accent-hover text-white text-xs font-semibold transition-colors cursor-pointer disabled:opacity-40 disabled:cursor-not-allowed"
            >
              <Upload size={12} strokeWidth={2.5} />
              {importing ? "Importing…" : `Import ${rows.length} Questions`}
            </button>
          </div>
          <div className="overflow-x-auto">
            <table className="w-full text-xs">
              <thead className="border-b border-border bg-hover/30">
                <tr>
                  <th className="text-left px-4 py-2.5 text-ghost font-semibold uppercase tracking-wide w-10">#</th>
                  <th className="text-left px-4 py-2.5 text-ghost font-semibold uppercase tracking-wide">Question Text</th>
                  <th className="text-left px-4 py-2.5 text-ghost font-semibold uppercase tracking-wide w-28">Difficulty</th>
                  <th className="text-left px-4 py-2.5 text-ghost font-semibold uppercase tracking-wide w-16">Serial</th>
                </tr>
              </thead>
              <tbody>
                {rows.slice(0, 50).map((r, i) => (
                  <tr key={i} className="border-b border-border/40 hover:bg-hover/20">
                    <td className="px-4 py-2.5 text-ghost tabular-nums">{i + 1}</td>
                    <td className="px-4 py-2.5 text-primary leading-snug max-w-lg">
                      {(r.text || r.question || "").slice(0, 120)}{(r.text || r.question || "").length > 120 ? "…" : ""}
                    </td>
                    <td className="px-4 py-2.5 text-muted">{r.difficulty || "—"}</td>
                    <td className="px-4 py-2.5 text-muted tabular-nums">{r.serial_number || i + 1}</td>
                  </tr>
                ))}
              </tbody>
            </table>
            {rows.length > 50 && (
              <p className="text-xs text-ghost text-center py-3">Showing first 50 of {rows.length} rows</p>
            )}
          </div>
        </div>
      )}
    </div>
  );
}

/* ── Admin Notifications & Comments ─────────────────────────── */
function AdminNotifications({ adminUser }) {
  const [tab, setTab] = useState("broadcast");
  const [broadcastTitle, setBroadcastTitle] = useState("");
  const [broadcastBody, setBroadcastBody] = useState("");
  const [targetType, setTargetType] = useState("all");
  const [userSearch, setUserSearch] = useState("");
  const [selectedUsers, setSelectedUsers] = useState([]);
  const [allUsers, setAllUsers] = useState([]);
  const [sending, setSending] = useState(false);
  const [sendSuccess, setSendSuccess] = useState(false);
  const [broadcasts, setBroadcasts] = useState([]);
  const [comments, setComments] = useState([]);
  const [commentSearch, setCommentSearch] = useState("");
  const [commentFilter, setCommentFilter] = useState("all");
  const [filterTopic, setFilterTopic] = useState("");
  const [filterSection, setFilterSection] = useState("");
  const [filterQuestion, setFilterQuestion] = useState("");
  const [loadingComments, setLoadingComments] = useState(false);

  useEffect(() => {
    fetchBroadcasts().then(setBroadcasts).catch(() => {});
    adminGetUsers(200).then(setAllUsers).catch(() => {});
  }, []);

  useEffect(() => {
    if (tab !== "comments") return;
    setLoadingComments(true);
    fetchAllComments({ search: commentSearch }).then(setComments).catch(() => {}).finally(() => setLoadingComments(false));
  }, [tab, commentSearch]);

  // Derive unique topics/sections/questions from loaded comments for filter dropdowns
  const commentTopics   = [...new Map(comments.map(c => [c.questions?.sections?.topics?.id, c.questions?.sections?.topics]).filter(([id]) => id)).values()];
  const commentSections = [...new Map(comments.filter(c => !filterTopic || c.questions?.sections?.topics?.id == filterTopic).map(c => [c.questions?.sections?.id, c.questions?.sections]).filter(([id]) => id)).values()];
  const commentQuestions = [...new Map(comments.filter(c => {
    if (filterTopic && c.questions?.sections?.topics?.id != filterTopic) return false;
    if (filterSection && c.questions?.sections?.id != filterSection) return false;
    return true;
  }).map(c => [c.question_id, c.questions]).filter(([id]) => id)).values()];

  async function handleSendBroadcast(e) {
    e.preventDefault();
    if (!broadcastTitle.trim() || !broadcastBody.trim()) return;
    if (targetType === "specific" && selectedUsers.length === 0) {
      alert("Select at least one user for specific targeting.");
      return;
    }
    setSending(true);
    try {
      await sendBroadcast(adminUser?.id, {
        title: broadcastTitle.trim(),
        body: broadcastBody.trim(),
        targetType,
        targetUserIds: targetType === "specific" ? selectedUsers : [],
      });
      setSendSuccess(true);
      setBroadcastTitle(""); setBroadcastBody(""); setSelectedUsers([]);
      const fresh = await fetchBroadcasts();
      setBroadcasts(fresh);
      setTimeout(() => setSendSuccess(false), 3000);
    } catch (e) { alert(e.message); } finally { setSending(false); }
  }

  async function handleDeleteComment(id) {
    if (!confirm("Delete this comment?")) return;
    await deleteComment(id);
    setComments(prev => prev.filter(c => c.id !== id));
  }

  async function handlePinComment(id, isPinned) {
    await togglePin(id, isPinned);
    setComments(prev => prev.map(c => c.id === id ? { ...c, is_pinned: !isPinned } : c));
  }

  function toggleUser(id) {
    setSelectedUsers(prev => prev.includes(id) ? prev.filter(x => x !== id) : [...prev, id]);
  }

  function timeAgo(iso) {
    const d = (Date.now() - new Date(iso)) / 1000;
    if (d < 60) return "just now";
    if (d < 3600) return `${Math.floor(d / 60)}m ago`;
    if (d < 86400) return `${Math.floor(d / 3600)}h ago`;
    return `${Math.floor(d / 86400)}d ago`;
  }

  const filteredUsers = allUsers.filter(u =>
    !userSearch || u.email.toLowerCase().includes(userSearch.toLowerCase()) || (u.full_name || "").toLowerCase().includes(userSearch.toLowerCase())
  );

  const filteredComments = comments.filter(c => {
    if (commentFilter === "active")  { if (c.is_deleted || c.is_pinned) return false; }
    else if (commentFilter === "pinned")  { if (!c.is_pinned || c.is_deleted) return false; }
    else if (commentFilter === "deleted") { if (!c.is_deleted) return false; }
    if (filterTopic    && c.questions?.sections?.topics?.id != filterTopic)   return false;
    if (filterSection  && c.questions?.sections?.id != filterSection)         return false;
    if (filterQuestion && c.question_id != filterQuestion)                    return false;
    return true;
  });

  const commentStats = {
    total:   comments.length,
    pinned:  comments.filter(c => c.is_pinned && !c.is_deleted).length,
    deleted: comments.filter(c => c.is_deleted).length,
    active:  comments.filter(c => !c.is_deleted).length,
  };

  return (
    <div className="flex flex-col h-full overflow-hidden">
      {/* Header */}
      <div className="shrink-0 px-6 py-4 border-b border-border flex items-center gap-3">
        <div className="w-8 h-8 rounded-lg bg-accent/10 border border-accent/20 text-accent flex items-center justify-center shrink-0">
          <Bell size={15} strokeWidth={1.8} />
        </div>
        <div>
          <h1 className="text-base font-bold text-heading">Notifications & Comments</h1>
          <p className="text-[11px] text-muted">Send announcements, moderate comments, view activity</p>
        </div>
      </div>

      {/* Tab bar */}
      <div className="shrink-0 flex gap-1 px-6 pt-3 border-b border-border">
        {[
          { id: "broadcast", label: "Send Announcement", Icon: Megaphone },
          { id: "history",   label: "Sent History",      Icon: Bell },
          { id: "comments",  label: "Comments",          Icon: MessageSquare },
        ].map(t => (
          <button key={t.id} onClick={() => setTab(t.id)}
            className={`flex items-center gap-1.5 px-3 py-2 text-xs font-semibold border-b-2 transition-colors cursor-pointer -mb-px ${
              tab === t.id ? "border-accent text-accent" : "border-transparent text-muted hover:text-primary"
            }`}>
            <t.Icon size={12} strokeWidth={1.8} />
            {t.label}
            {t.id === "history" && broadcasts.length > 0 && (
              <span className="ml-1 text-[9px] font-bold px-1 py-0.5 rounded bg-hover text-ghost tabular-nums">{broadcasts.length}</span>
            )}
            {t.id === "comments" && commentStats.total > 0 && (
              <span className="ml-1 text-[9px] font-bold px-1 py-0.5 rounded bg-hover text-ghost tabular-nums">{commentStats.total}</span>
            )}
          </button>
        ))}
      </div>

      <div className="flex-1 overflow-y-auto p-6">

        {/* ── Broadcast composer ── */}
        {tab === "broadcast" && (
          <div className="grid grid-cols-1 xl:grid-cols-5 gap-6">
            {/* Form — left */}
            <div className="xl:col-span-3 space-y-5">
              <div className="bg-panel border border-border rounded-2xl p-6">
                <h2 className="text-sm font-bold text-heading mb-4 flex items-center gap-2">
                  <Megaphone size={14} strokeWidth={1.8} className="text-warning" />
                  New Announcement
                </h2>
                <form onSubmit={handleSendBroadcast} className="space-y-4">
                  {/* Target */}
                  <div>
                    <label className="text-xs font-semibold text-soft block mb-1.5">Target audience</label>
                    <div className="flex gap-2">
                      {[["all", "All Users"], ["specific", "Specific Users"]].map(([val, lbl]) => (
                        <button key={val} type="button" onClick={() => setTargetType(val)}
                          className={`flex-1 h-9 rounded-lg border text-xs font-semibold transition-all cursor-pointer ${
                            targetType === val ? "bg-accent/10 border-accent/40 text-accent" : "bg-hover border-border text-muted hover:border-accent/30"
                          }`}>
                          {lbl}
                        </button>
                      ))}
                    </div>
                  </div>

                  {/* Specific user picker */}
                  {targetType === "specific" && (
                    <div className="space-y-2">
                      <label className="text-xs font-semibold text-soft block">
                        Select users
                        {selectedUsers.length > 0 && <span className="ml-2 text-accent font-bold">{selectedUsers.length} selected</span>}
                      </label>
                      <div className="relative">
                        <Search size={12} className="absolute left-3 top-1/2 -translate-y-1/2 text-ghost" strokeWidth={1.8} />
                        <input value={userSearch} onChange={e => setUserSearch(e.target.value)}
                          placeholder="Search users…"
                          className="w-full h-8 pl-8 pr-3 rounded-lg bg-hover border border-border text-xs text-primary outline-none focus:border-accent transition-colors placeholder:text-ghost" />
                      </div>
                      <div className="max-h-40 overflow-y-auto border border-border rounded-lg divide-y divide-border/50">
                        {filteredUsers.slice(0, 30).map(u => {
                          const sel = selectedUsers.includes(u.id);
                          return (
                            <button key={u.id} type="button" onClick={() => toggleUser(u.id)}
                              className={`w-full flex items-center gap-2.5 px-3 py-2 text-left transition-colors cursor-pointer ${sel ? "bg-accent/5" : "hover:bg-hover"}`}>
                              <div className={`w-4 h-4 rounded border flex items-center justify-center shrink-0 transition-colors ${sel ? "bg-accent border-accent" : "border-border"}`}>
                                {sel && <Check size={10} strokeWidth={3} className="text-white" />}
                              </div>
                              <div className="min-w-0">
                                <p className="text-[11px] font-medium text-primary truncate">{u.email}</p>
                                {u.full_name && <p className="text-[10px] text-ghost truncate">{u.full_name}</p>}
                              </div>
                            </button>
                          );
                        })}
                        {filteredUsers.length === 0 && <p className="text-xs text-ghost text-center py-4">No users found</p>}
                      </div>
                      {selectedUsers.length > 0 && (
                        <button type="button" onClick={() => setSelectedUsers([])} className="text-[10px] text-ghost hover:text-danger cursor-pointer">Clear selection</button>
                      )}
                    </div>
                  )}

                  {/* Title */}
                  <div>
                    <label className="text-xs font-semibold text-soft block mb-1.5">Title</label>
                    <input value={broadcastTitle} onChange={e => setBroadcastTitle(e.target.value)}
                      placeholder="e.g. New questions added — Java Collections"
                      className="w-full h-10 bg-hover border border-border focus:border-accent/50 rounded-lg px-3 text-sm text-primary outline-none transition-colors placeholder:text-ghost" />
                  </div>

                  {/* Message */}
                  <div>
                    <label className="text-xs font-semibold text-soft block mb-1.5">Message</label>
                    <textarea value={broadcastBody} onChange={e => setBroadcastBody(e.target.value)}
                      placeholder="Write your announcement here…"
                      rows={4}
                      className="w-full bg-hover border border-border focus:border-accent/50 rounded-lg px-3 py-2.5 text-sm text-primary outline-none resize-none transition-colors placeholder:text-ghost" />
                  </div>

                  <div className="flex items-center gap-3">
                    <button type="submit" disabled={sending || !broadcastTitle.trim() || !broadcastBody.trim()}
                      className="flex items-center gap-2 h-10 px-5 rounded-xl bg-accent hover:bg-accent-hover text-white text-sm font-semibold cursor-pointer disabled:opacity-50 transition-all"
                      style={{ boxShadow: "0 0 12px rgba(99,102,241,0.25)" }}>
                      <Send size={13} strokeWidth={2} />
                      {sending ? "Sending…" : targetType === "all" ? "Send to All Users" : `Send to ${selectedUsers.length} User${selectedUsers.length !== 1 ? "s" : ""}`}
                    </button>
                    {sendSuccess && (
                      <span className="flex items-center gap-1 text-xs text-success font-semibold">
                        <CheckCircle size={13} strokeWidth={2} /> Sent!
                      </span>
                    )}
                  </div>
                </form>
              </div>
            </div>

            {/* Info + stats — right */}
            <div className="xl:col-span-2 space-y-4">
              <div className="bg-panel border border-border rounded-xl p-5">
                <p className="text-xs font-bold text-soft mb-3">How it works</p>
                <div className="space-y-2.5">
                  {[
                    "Announcements appear in the notification bell for all targeted users",
                    "Users can dismiss them individually",
                    "They appear in real-time without page refresh",
                    "Specific Users targeting sends only to selected accounts",
                  ].map((t, i) => (
                    <div key={i} className="flex items-start gap-2">
                      <div className="w-4 h-4 rounded-full bg-accent/10 border border-accent/20 text-accent flex items-center justify-center shrink-0 mt-0.5 text-[9px] font-bold">{i + 1}</div>
                      <p className="text-[11px] text-muted leading-relaxed">{t}</p>
                    </div>
                  ))}
                </div>
              </div>

              {broadcasts.length > 0 && (
                <div className="bg-panel border border-border rounded-xl p-5">
                  <p className="text-xs font-bold text-soft mb-3">Recent Sends</p>
                  <div className="space-y-2">
                    {broadcasts.slice(0, 3).map(b => (
                      <div key={b.id} className="flex items-start gap-2">
                        <Megaphone size={11} strokeWidth={1.8} className="text-ghost mt-0.5 shrink-0" />
                        <div className="min-w-0">
                          <p className="text-[11px] font-semibold text-soft truncate">{b.title}</p>
                          <p className="text-[10px] text-ghost">{timeAgo(b.created_at)}</p>
                        </div>
                      </div>
                    ))}
                  </div>
                </div>
              )}
            </div>
          </div>
        )}

        {/* ── Broadcast history ── */}
        {tab === "history" && (
          <div className="space-y-3">
            {broadcasts.length === 0 ? (
              <div className="text-center py-16">
                <Bell size={28} strokeWidth={1.2} className="text-ghost mx-auto mb-2" />
                <p className="text-sm text-muted">No announcements sent yet</p>
              </div>
            ) : (
              <div className="bg-panel border border-border rounded-xl overflow-hidden">
                <table className="w-full text-sm">
                  <thead>
                    <tr className="border-b border-border bg-hover/30">
                      <th className="text-left px-5 py-3 text-[10px] font-bold uppercase tracking-wider text-ghost">Title</th>
                      <th className="text-left px-4 py-3 text-[10px] font-bold uppercase tracking-wider text-ghost">Message</th>
                      <th className="text-left px-4 py-3 text-[10px] font-bold uppercase tracking-wider text-ghost w-24">Target</th>
                      <th className="text-left px-4 py-3 text-[10px] font-bold uppercase tracking-wider text-ghost w-24">Sent</th>
                    </tr>
                  </thead>
                  <tbody>
                    {broadcasts.map(b => (
                      <tr key={b.id} className="border-b border-border/40 hover:bg-hover/20 transition-colors">
                        <td className="px-5 py-3">
                          <p className="text-xs font-semibold text-primary">{b.title}</p>
                        </td>
                        <td className="px-4 py-3">
                          <p className="text-[11px] text-muted line-clamp-2 max-w-xs">{b.body}</p>
                        </td>
                        <td className="px-4 py-3">
                          <span className={`text-[10px] font-bold px-1.5 py-0.5 rounded-md border ${
                            b.target_type === "all" ? "bg-accent/10 text-accent border-accent/20" : "bg-warning/10 text-warning border-warning/20"
                          }`}>
                            {b.target_type === "all" ? "All" : `${b.target_user_ids?.length ?? 0} users`}
                          </span>
                        </td>
                        <td className="px-4 py-3 text-[11px] text-ghost tabular-nums">{timeAgo(b.created_at)}</td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              </div>
            )}
          </div>
        )}

        {/* ── Comments moderation ── */}
        {tab === "comments" && (
          <div className="space-y-4">
            {/* Stats bar */}
            {!loadingComments && comments.length > 0 && (
              <div className="grid grid-cols-4 gap-3">
                {[
                  { label: "Total",   value: commentStats.total,   cls: "text-primary", bg: "bg-hover"     },
                  { label: "Active",  value: commentStats.active,  cls: "text-success", bg: "bg-success/5" },
                  { label: "Pinned",  value: commentStats.pinned,  cls: "text-warning", bg: "bg-warning/5" },
                  { label: "Deleted", value: commentStats.deleted, cls: "text-danger",  bg: "bg-danger/5"  },
                ].map(({ label, value, cls, bg }) => (
                  <button key={label} onClick={() => setCommentFilter(label.toLowerCase())}
                    className={`${bg} border rounded-xl p-3 text-center transition-all cursor-pointer ${
                      commentFilter === label.toLowerCase() ? "border-accent/40 ring-1 ring-accent/20" : "border-border hover:border-accent/20"
                    }`}>
                    <p className={`text-xl font-bold tabular-nums ${cls}`}>{value}</p>
                    <p className="text-[10px] text-ghost mt-0.5">{label}</p>
                  </button>
                ))}
              </div>
            )}

            {/* Topic → Section → Question drill-down filters */}
            <div className="flex flex-wrap gap-2 p-3 bg-panel border border-border rounded-xl">
              <div className="flex items-center gap-1.5 text-[10px] font-bold text-ghost uppercase tracking-wider shrink-0 self-center">
                <Layers size={11} strokeWidth={2} />
                Filter by:
              </div>
              <select value={filterTopic} onChange={e => { setFilterTopic(e.target.value); setFilterSection(""); setFilterQuestion(""); }}
                className="h-8 px-2.5 rounded-lg bg-hover border border-border text-xs text-primary outline-none focus:border-accent cursor-pointer">
                <option value="">All Topics ({commentTopics.length})</option>
                {commentTopics.map(t => {
                  const count = comments.filter(c => c.questions?.sections?.topics?.id === t?.id).length;
                  return <option key={t?.id} value={t?.id}>{t?.label} ({count})</option>;
                })}
              </select>
              <select value={filterSection} onChange={e => { setFilterSection(e.target.value); setFilterQuestion(""); }}
                disabled={!filterTopic}
                className="h-8 px-2.5 rounded-lg bg-hover border border-border text-xs text-primary outline-none focus:border-accent cursor-pointer disabled:opacity-40">
                <option value="">All Sections ({commentSections.length})</option>
                {commentSections.map(s => {
                  const count = comments.filter(c => c.questions?.sections?.id === s?.id).length;
                  return <option key={s?.id} value={s?.id}>{s?.label} ({count})</option>;
                })}
              </select>
              <select value={filterQuestion} onChange={e => setFilterQuestion(e.target.value)}
                disabled={!filterSection}
                className="h-8 px-2.5 rounded-lg bg-hover border border-border text-xs text-primary outline-none focus:border-accent cursor-pointer disabled:opacity-40 max-w-xs">
                <option value="">All Questions ({commentQuestions.length})</option>
                {commentQuestions.map(q => {
                  const count = comments.filter(c => c.question_id === q?.id).length;
                  return <option key={q?.id} value={q?.id}>{q?.text?.slice(0, 50)}{q?.text?.length > 50 ? "…" : ""} ({count})</option>;
                })}
              </select>
              {(filterTopic || filterSection || filterQuestion) && (
                <button onClick={() => { setFilterTopic(""); setFilterSection(""); setFilterQuestion(""); }}
                  className="h-8 px-2.5 rounded-lg border border-border bg-hover text-[11px] text-ghost hover:text-danger hover:border-danger/30 transition-colors cursor-pointer flex items-center gap-1">
                  <X size={10} strokeWidth={2} /> Clear
                </button>
              )}
              {(filterTopic || filterSection || filterQuestion) && (
                <span className="ml-auto self-center text-[11px] text-accent font-semibold">{filteredComments.length} result{filteredComments.length !== 1 ? "s" : ""}</span>
              )}
            </div>

            {/* Search + status filter row */}
            <div className="flex flex-wrap gap-2">
              <div className="relative flex-1 min-w-48">
                <Search size={13} strokeWidth={1.8} className="absolute left-3 top-1/2 -translate-y-1/2 text-ghost" />
                <input value={commentSearch} onChange={e => setCommentSearch(e.target.value)}
                  placeholder="Search comment content…"
                  className="w-full h-9 pl-9 pr-3 bg-panel border border-border focus:border-accent/50 rounded-lg text-sm text-primary outline-none transition-colors placeholder:text-ghost" />
              </div>
              <div className="flex gap-1">
                {[["all", "All"], ["active", "Active"], ["pinned", "Pinned"], ["deleted", "Deleted"]].map(([val, lbl]) => (
                  <button key={val} onClick={() => setCommentFilter(val)}
                    className={`h-9 px-3 rounded-lg border text-xs font-semibold transition-colors cursor-pointer ${
                      commentFilter === val ? "bg-accent/10 border-accent/40 text-accent" : "bg-panel border-border text-muted hover:border-accent/30"
                    }`}>
                    {lbl}
                  </button>
                ))}
              </div>
            </div>

            {/* Comments table */}
            {loadingComments ? (
              <div className="flex items-center justify-center py-12 gap-2">
                <div className="w-4 h-4 rounded-full border-2 border-border border-t-accent" style={{ animation: "spin 0.8s linear infinite" }} />
                <span className="text-xs text-muted">Loading comments…</span>
              </div>
            ) : filteredComments.length === 0 ? (
              <div className="text-center py-16">
                <MessageSquare size={28} strokeWidth={1.2} className="text-ghost mx-auto mb-2" />
                <p className="text-sm text-muted">No comments found</p>
              </div>
            ) : (
              <div className="bg-panel border border-border rounded-xl overflow-hidden">
                <table className="w-full text-sm">
                  <thead>
                    <tr className="border-b border-border bg-hover/30">
                      <th className="text-left px-5 py-3 text-[10px] font-bold uppercase tracking-wider text-ghost">Comment</th>
                      <th className="text-left px-4 py-3 text-[10px] font-bold uppercase tracking-wider text-ghost">Question & Tags</th>
                      <th className="text-left px-4 py-3 text-[10px] font-bold uppercase tracking-wider text-ghost w-20">Status</th>
                      <th className="text-left px-4 py-3 text-[10px] font-bold uppercase tracking-wider text-ghost w-20">When</th>
                      <th className="text-right px-5 py-3 text-[10px] font-bold uppercase tracking-wider text-ghost w-28">Actions</th>
                    </tr>
                  </thead>
                  <tbody>
                    {filteredComments.map(c => {
                      const q = c.questions;
                      const topic   = q?.sections?.topics?.label;
                      const section = q?.sections?.label;
                      const diff    = q?.difficulty_levels?.label;
                      const diffCls = diff === "Basic" ? "bg-success/10 text-success border-success/20"
                                    : diff === "Intermediate" ? "bg-warning/10 text-warning border-warning/20"
                                    : diff === "Advanced" ? "bg-danger/10 text-danger border-danger/20"
                                    : "bg-hover text-ghost border-border";
                      return (
                        <tr key={c.id} className={`border-b border-border/40 hover:bg-hover/20 transition-colors ${c.is_deleted ? "opacity-50" : ""}`}>
                          <td className="px-5 py-3 max-w-xs">
                            <p className="text-xs text-primary leading-relaxed line-clamp-3">{c.content}</p>
                          </td>
                          <td className="px-4 py-3">
                            <p className="text-[11px] text-muted line-clamp-2 mb-1.5">{q?.text?.slice(0, 80) ?? "—"}{q?.text?.length > 80 ? "…" : ""}</p>
                            <div className="flex flex-wrap gap-1">
                              {topic && (
                                <span className="text-[9px] font-bold px-1.5 py-0.5 rounded bg-accent/10 text-accent border border-accent/20">{topic}</span>
                              )}
                              {section && (
                                <span className="text-[9px] font-bold px-1.5 py-0.5 rounded bg-hover text-muted border border-border">{section}</span>
                              )}
                              {diff && (
                                <span className={`text-[9px] font-bold px-1.5 py-0.5 rounded border ${diffCls}`}>{diff}</span>
                              )}
                            </div>
                          </td>
                          <td className="px-4 py-3">
                            {c.is_deleted
                              ? <span className="text-[9px] font-bold px-1.5 py-0.5 rounded bg-danger/10 text-danger border border-danger/20">Deleted</span>
                              : c.is_pinned
                              ? <span className="text-[9px] font-bold px-1.5 py-0.5 rounded bg-warning/10 text-warning border border-warning/20">Pinned</span>
                              : <span className="text-[9px] font-bold px-1.5 py-0.5 rounded bg-success/10 text-success border border-success/20">Active</span>
                            }
                          </td>
                          <td className="px-4 py-3 text-[11px] text-ghost tabular-nums whitespace-nowrap">{timeAgo(c.created_at)}</td>
                          <td className="px-5 py-3">
                            <div className="flex items-center gap-1.5 justify-end">
                              {!c.is_deleted && (
                                <button onClick={() => handlePinComment(c.id, c.is_pinned)}
                                  className={`flex items-center gap-1 h-6 px-2 rounded-md border text-[10px] font-semibold cursor-pointer transition-colors ${
                                    c.is_pinned ? "bg-warning/10 border-warning/30 text-warning" : "bg-hover border-border text-ghost hover:text-warning hover:border-warning/30"
                                  }`}>
                                  <Pin size={9} strokeWidth={2.5} />
                                  {c.is_pinned ? "Unpin" : "Pin"}
                                </button>
                              )}
                              {!c.is_deleted && (
                                <button onClick={() => handleDeleteComment(c.id)}
                                  className="flex items-center gap-1 h-6 px-2 rounded-md border bg-hover border-border text-[10px] font-semibold text-ghost hover:text-danger hover:border-danger/30 cursor-pointer transition-colors">
                                  <Trash2 size={9} strokeWidth={2.5} />
                                  Delete
                                </button>
                              )}
                            </div>
                          </td>
                        </tr>
                      );
                    })}
                  </tbody>
                </table>
              </div>
            )}
          </div>
        )}
      </div>
    </div>
  );
}

/* ── Admin Layout ────────────────────────────────────────────── */
/* ── Topics Roadmap ──────────────────────────────────────────── */
const ROADMAP = [
  {
    category: "🖥️ Programming Languages",
    items: [
      { name: "Python",      priority: 3, notes: "AI/ML, backend, scripting — most demanded" },
      { name: "Java",        priority: 3, notes: "Enterprise, Android, Spring Boot" },
      { name: "Go (Golang)", priority: 2, notes: "Cloud-native, microservices, backend" },
      { name: "C++",         priority: 2, notes: "Systems, game dev, embedded" },
      { name: "PHP",         priority: 2, notes: "Massive in web — Laravel" },
      { name: "Kotlin",      priority: 2, notes: "Android + server-side" },
      { name: "Swift",       priority: 2, notes: "iOS / macOS dev" },
      { name: "Rust",        priority: 1, notes: "Systems, WASM — growing fast" },
      { name: "Ruby",        priority: 1, notes: "Rails shops still hire" },
    ],
  },
  {
    category: "🌐 Frontend",
    items: [
      { name: "Next.js",              priority: 3, notes: "Full-stack React — heavily asked" },
      { name: "Vue.js",               priority: 3, notes: "Very common alongside React" },
      { name: "Angular",              priority: 2, notes: "Enterprise frontend" },
      { name: "CSS / HTML Fundamentals", priority: 2, notes: "Flexbox, Grid, specificity, accessibility" },
      { name: "Web Performance",      priority: 2, notes: "Core Web Vitals, lazy loading, bundling" },
      { name: "TypeScript Deep Dive", priority: 2, notes: "Generics, decorators, utility types" },
    ],
  },
  {
    category: "⚙️ Backend & APIs",
    items: [
      { name: "Node.js / Express", priority: 3, notes: "JS backend staple" },
      { name: "REST API Design",   priority: 3, notes: "Every backend role asks this" },
      { name: "Spring Boot",       priority: 3, notes: "Java backend standard" },
      { name: "Django / Flask",    priority: 2, notes: "Python web frameworks" },
      { name: "GraphQL",           priority: 2, notes: "Used at scale — Facebook, GitHub" },
      { name: "gRPC",              priority: 1, notes: "Microservices communication" },
    ],
  },
  {
    category: "🗄️ Databases",
    items: [
      { name: "MongoDB",               priority: 3, notes: "Most popular NoSQL" },
      { name: "Redis",                 priority: 3, notes: "Caching, pub/sub, sessions" },
      { name: "PostgreSQL Deep Dive",  priority: 2, notes: "Advanced features beyond basic SQL" },
      { name: "Database Design",       priority: 2, notes: "Normalization, indexing, ERD" },
      { name: "Elasticsearch",         priority: 1, notes: "Search at scale" },
    ],
  },
  {
    category: "☁️ Cloud & DevOps",
    items: [
      { name: "AWS",              priority: 3, notes: "Biggest cloud — EC2, S3, Lambda, RDS" },
      { name: "Docker",           priority: 3, notes: "Every dev role requires this now" },
      { name: "Linux / Shell",    priority: 3, notes: "Every backend / DevOps role" },
      { name: "CI/CD",            priority: 2, notes: "GitHub Actions, Jenkins, pipelines" },
      { name: "Kubernetes",       priority: 2, notes: "Container orchestration" },
      { name: "GCP",              priority: 2, notes: "Google Cloud — growing fast" },
      { name: "Networking Basics",priority: 2, notes: "DNS, HTTP, TCP/IP, load balancers" },
      { name: "Terraform",        priority: 1, notes: "Infrastructure as Code" },
    ],
  },
  {
    category: "🏗️ Architecture & Patterns",
    items: [
      { name: "Design Patterns",          priority: 3, notes: "GoF patterns — every senior role" },
      { name: "Microservices",            priority: 3, notes: "Architecture interviews" },
      { name: "Message Queues",           priority: 2, notes: "Kafka, RabbitMQ, SQS" },
      { name: "Event-Driven Architecture",priority: 1, notes: "Distributed systems" },
    ],
  },
  {
    category: "🔒 Security",
    items: [
      { name: "Web Security / OWASP",  priority: 3, notes: "Every full-stack role" },
      { name: "Authentication & Auth", priority: 3, notes: "JWT, OAuth2, SSO" },
      { name: "Cryptography Basics",   priority: 1, notes: "Encryption, hashing, TLS" },
    ],
  },
  {
    category: "📱 Mobile",
    items: [
      { name: "React Native",    priority: 3, notes: "Cross-platform — most in demand" },
      { name: "Flutter",         priority: 2, notes: "Fast-growing cross-platform" },
      { name: "Android (Kotlin)",priority: 2, notes: "Native Android dev" },
      { name: "iOS (Swift)",     priority: 1, notes: "Native iOS dev" },
    ],
  },
  {
    category: "🧪 Testing & Quality",
    items: [
      { name: "Unit & Integration Testing", priority: 3, notes: "Every role asks" },
      { name: "QA & Automation",            priority: 2, notes: "Selenium, Cypress, Playwright" },
      { name: "TDD / BDD",                  priority: 1, notes: "Senior roles" },
    ],
  },
  {
    category: "🤖 AI / Data",
    items: [
      { name: "Machine Learning Basics", priority: 2, notes: "Product + ML engineer roles" },
      { name: "Data Engineering",        priority: 2, notes: "Pipelines, ETL, Spark" },
      { name: "Prompt Engineering",      priority: 1, notes: "New but fast-growing" },
    ],
  },
  {
    category: "💼 Soft Skills / HR",
    items: [
      { name: "Behavioural Questions",        priority: 3, notes: "STAR method — every interview" },
      { name: "System Design Communication",  priority: 2, notes: "How to talk through designs" },
      { name: "Salary Negotiation",           priority: 1, notes: "Often overlooked" },
    ],
  },
];

const STORAGE_KEY = "devready_roadmap_status";

function AdminRoadmap() {
  const [search, setSearch] = useState("");
  const [filterPriority, setFilterPriority] = useState("all");
  const [filterStatus, setFilterStatus] = useState("all");
  const [statuses, setStatuses] = useState(() => {
    try { return JSON.parse(localStorage.getItem(STORAGE_KEY) || "{}"); } catch { return {}; }
  });

  function setStatus(name, status) {
    setStatuses(prev => {
      const next = { ...prev, [name]: status };
      localStorage.setItem(STORAGE_KEY, JSON.stringify(next));
      return next;
    });
  }

  const allItems = ROADMAP.flatMap(cat => cat.items.map(i => ({ ...i, category: cat.category })));

  const filtered = allItems.filter(item => {
    if (filterPriority !== "all" && item.priority !== Number(filterPriority)) return false;
    const status = statuses[item.name] || "pending";
    if (filterStatus === "pending"    && status !== "pending")    return false;
    if (filterStatus === "inprogress" && status !== "inprogress") return false;
    if (filterStatus === "done"       && status !== "done")       return false;
    if (search && !item.name.toLowerCase().includes(search.toLowerCase()) && !item.notes.toLowerCase().includes(search.toLowerCase())) return false;
    return true;
  });

  const totalDone = allItems.filter(i => statuses[i.name] === "done").length;
  const totalInProgress = allItems.filter(i => statuses[i.name] === "inprogress").length;
  const totalPending = allItems.filter(i => !statuses[i.name] || statuses[i.name] === "pending").length;
  const pct = Math.round((totalDone / allItems.length) * 100);

  function PriorityStars({ p }) {
    return (
      <div className="flex gap-0.5">
        {[1,2,3].map(n => (
          <Star key={n} size={10} strokeWidth={2}
            className={n <= p ? "text-warning fill-warning" : "text-ghost"} />
        ))}
      </div>
    );
  }

  const STATUS_CFG = {
    pending:    { label: "Pending",     cls: "bg-hover text-ghost border-border",           dot: "bg-ghost"   },
    inprogress: { label: "In Progress", cls: "bg-warning/10 text-warning border-warning/30", dot: "bg-warning" },
    done:       { label: "Done",        cls: "bg-success/10 text-success border-success/30", dot: "bg-success" },
  };

  // Group filtered items back by category
  const grouped = ROADMAP.map(cat => ({
    ...cat,
    items: cat.items.filter(i => filtered.find(f => f.name === i.name)),
  })).filter(cat => cat.items.length > 0);

  return (
    <div className="flex flex-col h-full overflow-hidden">
      {/* Header */}
      <div className="shrink-0 px-6 py-4 border-b border-border">
        <div className="flex items-center gap-3 mb-3">
          <div className="w-8 h-8 rounded-lg bg-violet-500/10 border border-violet-500/20 text-violet-400 flex items-center justify-center shrink-0">
            <Map size={15} strokeWidth={1.8} />
          </div>
          <div>
            <h1 className="text-base font-bold text-heading">Topics Roadmap</h1>
            <p className="text-[11px] text-muted">Track which topics to add next — {allItems.length} total</p>
          </div>
        </div>

        {/* Progress bar */}
        <div className="flex items-center gap-3 mb-3">
          <div className="flex-1 h-2 bg-hover rounded-full overflow-hidden">
            <div className="h-full rounded-full transition-all duration-700 bg-success"
              style={{ width: `${pct}%` }} />
          </div>
          <span className="text-xs font-semibold text-soft tabular-nums w-10">{pct}%</span>
        </div>

        {/* Stats row */}
        <div className="flex gap-3">
          {[
            { label: "Done",        value: totalDone,       cls: "text-success" },
            { label: "In Progress", value: totalInProgress, cls: "text-warning" },
            { label: "Pending",     value: totalPending,    cls: "text-ghost"   },
            { label: "Total",       value: allItems.length, cls: "text-primary" },
          ].map(({ label, value, cls }) => (
            <div key={label} className="flex items-center gap-1.5 text-[11px]">
              <span className={`font-bold tabular-nums ${cls}`}>{value}</span>
              <span className="text-ghost">{label}</span>
            </div>
          ))}
        </div>
      </div>

      {/* Filters */}
      <div className="shrink-0 flex flex-wrap gap-2 px-6 py-3 border-b border-border bg-surface/40">
        <div className="relative flex-1 min-w-40">
          <Search size={12} strokeWidth={1.8} className="absolute left-3 top-1/2 -translate-y-1/2 text-ghost" />
          <input value={search} onChange={e => setSearch(e.target.value)}
            placeholder="Search topics…"
            className="w-full h-8 pl-8 pr-3 bg-panel border border-border rounded-lg text-xs text-primary outline-none focus:border-accent transition-colors placeholder:text-ghost" />
        </div>
        <select value={filterPriority} onChange={e => setFilterPriority(e.target.value)}
          className="h-8 px-2.5 rounded-lg bg-panel border border-border text-xs text-primary outline-none focus:border-accent cursor-pointer">
          <option value="all">All Priorities</option>
          <option value="3">⭐⭐⭐ High</option>
          <option value="2">⭐⭐ Medium</option>
          <option value="1">⭐ Low</option>
        </select>
        <select value={filterStatus} onChange={e => setFilterStatus(e.target.value)}
          className="h-8 px-2.5 rounded-lg bg-panel border border-border text-xs text-primary outline-none focus:border-accent cursor-pointer">
          <option value="all">All Status</option>
          <option value="pending">Pending</option>
          <option value="inprogress">In Progress</option>
          <option value="done">Done</option>
        </select>
        {(search || filterPriority !== "all" || filterStatus !== "all") && (
          <button onClick={() => { setSearch(""); setFilterPriority("all"); setFilterStatus("all"); }}
            className="h-8 px-2.5 rounded-lg border border-border bg-hover text-xs text-ghost hover:text-danger hover:border-danger/30 transition-colors cursor-pointer flex items-center gap-1">
            <X size={10} strokeWidth={2} /> Clear
          </button>
        )}
        <span className="ml-auto self-center text-[11px] text-ghost tabular-nums">{filtered.length} topics</span>
      </div>

      {/* Table */}
      <div className="flex-1 overflow-y-auto">
        {grouped.map(cat => (
          <div key={cat.category}>
            {/* Category header */}
            <div className="sticky top-0 z-10 px-6 py-2 bg-hover/80 backdrop-blur border-b border-border flex items-center gap-2">
              <span className="text-xs font-bold text-soft">{cat.category}</span>
              <span className="text-[10px] text-ghost">({cat.items.length})</span>
              <span className="ml-auto text-[10px] text-ghost">
                {cat.items.filter(i => statuses[i.name] === "done").length}/{cat.items.length} done
              </span>
            </div>

            <table className="w-full text-sm">
              <tbody>
                {cat.items.map(item => {
                  const status = statuses[item.name] || "pending";
                  const cfg = STATUS_CFG[status];
                  return (
                    <tr key={item.name} className={`border-b border-border/40 hover:bg-hover/20 transition-colors ${status === "done" ? "opacity-60" : ""}`}>
                      {/* Priority */}
                      <td className="px-5 py-3 w-20">
                        <PriorityStars p={item.priority} />
                      </td>
                      {/* Name */}
                      <td className="px-3 py-3 w-48">
                        <div className="flex items-center gap-2">
                          {status === "done" && <Check size={12} strokeWidth={2.5} className="text-success shrink-0" />}
                          <span className={`text-xs font-semibold ${status === "done" ? "line-through text-ghost" : "text-primary"}`}>
                            {item.name}
                          </span>
                        </div>
                      </td>
                      {/* Notes */}
                      <td className="px-3 py-3">
                        <span className="text-[11px] text-muted">{item.notes}</span>
                      </td>
                      {/* Status dropdown */}
                      <td className="px-5 py-3 w-40">
                        <select value={status}
                          onChange={e => setStatus(item.name, e.target.value)}
                          className={`h-7 px-2.5 rounded-lg border text-[11px] font-semibold cursor-pointer outline-none transition-colors ${cfg.cls}`}>
                          <option value="pending">Pending</option>
                          <option value="inprogress">In Progress</option>
                          <option value="done">Done</option>
                        </select>
                      </td>
                    </tr>
                  );
                })}
              </tbody>
            </table>
          </div>
        ))}

        {grouped.length === 0 && (
          <div className="flex flex-col items-center justify-center py-20 text-center">
            <Map size={28} strokeWidth={1.2} className="text-ghost mx-auto mb-2" />
            <p className="text-sm text-muted">No topics match your filters</p>
          </div>
        )}
      </div>
    </div>
  );
}

/* ── Prompts Page ────────────────────────────────────────────── */
const PROMPT_STEPS = [
  {
    step: 1,
    title: "Create Topic",
    icon: "🗂️",
    color: "text-accent bg-accent/10 border-accent/20",
    description: "Go to Content → click + next to Topics. Fill in the topic name, emoji icon, and color.",
    prompt: (topic) => `I want to add a new topic called "${topic}" to DevReady.

Go to Admin → Content → Topics and create it with:
- Label: ${topic}
- Pick a relevant emoji icon
- Pick a fitting color hex

Then confirm it's created before moving to sections.`,
  },
  {
    step: 2,
    title: "Create Sections",
    icon: "📂",
    color: "text-blue-400 bg-blue-500/10 border-blue-500/20",
    description: "After topic is created, add logical sections (chapters/subtopics) under it.",
    prompt: (topic) => `The topic "${topic}" has been created in DevReady admin.

Now create the following sections under "${topic}" in Admin → Content → Sections.
Number them in display order. Suggested sections for ${topic}:

1. Basics & Fundamentals
2. Core Concepts
3. Advanced Topics
4. Best Practices & Patterns
5. Real-world & Interview Questions

Adjust section names to match what's most relevant for ${topic} interviews. Create each one in the admin panel under the ${topic} topic.`,
  },
  {
    step: 3,
    title: "Bulk Import Questions",
    icon: "❓",
    color: "text-violet-400 bg-violet-500/10 border-violet-500/20",
    description: "Use Bulk Import to add questions as a JSON or CSV file.",
    prompt: (topic) => `Generate a list of 30 interview questions for the "${topic}" topic, spread across these difficulty levels: Basic, Intermediate, Advanced.

Format as JSON array like this:
[
  { "text": "What is ...?", "difficulty": "Basic", "serial_number": 1 },
  { "text": "Explain ...?", "difficulty": "Intermediate", "serial_number": 2 },
  { "text": "How does ... work internally?", "difficulty": "Advanced", "serial_number": 3 }
]

Rules:
- Questions must be specific and commonly asked in real technical interviews
- Cover a wide range: concepts, differences, practical usage, code patterns, performance
- No duplicate questions
- serial_number starts at 1 and increments
- difficulty must be exactly "Basic", "Intermediate", or "Advanced"

Generate 30 questions for: ${topic}`,
  },
  {
    step: 4,
    title: "Write Answers",
    icon: "✍️",
    color: "text-success bg-success/10 border-success/20",
    description: "For each question, write a detailed answer in the Answer editor (Markdown supported).",
    prompt: (topic) => `Write a detailed answer for this ${topic} interview question.

Use this exact Markdown structure:

## ⚡ Short Answer
One clear sentence that directly answers the question.

## 📘 Detailed Explanation
**What it is:** ...
**Why it exists:** ...
**How it works internally:** ...
**Benefits:** ...
**Drawbacks / limitations:** ...

## 💻 Code Example
\`\`\`[language]
// Practical, working code example
\`\`\`

## 🔑 Key Points
- Point 1
- Point 2
- Point 3

Rules:
- Keep it factual and interview-focused
- Code examples must be concise and correct
- Avoid fluff — every sentence must add value
- Target audience: developers preparing for technical interviews

Question: [PASTE QUESTION HERE]`,
  },
  {
    step: 5,
    title: "Bulk Answer via AI",
    icon: "🤖",
    color: "text-warning bg-warning/10 border-warning/20",
    description: "Generate answers for multiple questions at once using AI.",
    prompt: (topic) => `I have the following ${topic} interview questions in DevReady. Generate a complete answer for EACH question using this Markdown format:

---
**Q: [question text]**

## ⚡ Short Answer
[one sentence]

## 📘 Detailed Explanation
**What it is:** ...
**Why it exists:** ...
**How it works:** ...

## 💻 Code Example
\`\`\`[language]
// working example
\`\`\`

## 🔑 Key Points
- ...
- ...
---

Questions to answer:
1. [paste questions here]

Topic: ${topic}
Keep answers concise, accurate, and interview-ready.`,
  },
];

function AdminPrompts() {
  const [topic, setTopic] = useState("");
  const [activeStep, setActiveStep] = useState(0);
  const [copied, setCopied] = useState(null);

  function copy(text, idx) {
    navigator.clipboard.writeText(text).then(() => {
      setCopied(idx);
      setTimeout(() => setCopied(null), 2000);
    });
  }

  const step = PROMPT_STEPS[activeStep];
  const generatedPrompt = step.prompt(topic || "[TOPIC NAME]");

  return (
    <div className="flex h-full overflow-hidden">

      {/* Left — step selector */}
      <div className="w-56 shrink-0 border-r border-border flex flex-col">
        <div className="px-4 py-4 border-b border-border">
          <h2 className="text-sm font-bold text-heading mb-0.5">Content Prompts</h2>
          <p className="text-[11px] text-muted">Copy-ready prompts for each step</p>
        </div>

        {/* Topic input */}
        <div className="px-3 py-3 border-b border-border">
          <label className="text-[10px] font-bold text-ghost uppercase tracking-wider block mb-1.5">Topic Name</label>
          <input
            value={topic}
            onChange={e => setTopic(e.target.value)}
            placeholder="e.g. Python, Docker…"
            className="w-full h-8 px-3 rounded-lg bg-hover border border-border text-xs text-primary outline-none focus:border-accent transition-colors placeholder:text-ghost"
          />
          <p className="text-[10px] text-ghost mt-1">Fills into prompts automatically</p>
        </div>

        {/* Steps */}
        <div className="flex-1 py-2 overflow-y-auto">
          {PROMPT_STEPS.map((s, idx) => (
            <button key={idx} onClick={() => setActiveStep(idx)}
              className={`w-full flex items-center gap-2.5 px-3 py-2.5 text-left transition-colors cursor-pointer border-l-2 ${
                activeStep === idx
                  ? "border-accent bg-accent/5 text-accent"
                  : "border-transparent text-muted hover:bg-hover hover:text-primary"
              }`}>
              <span className="text-base leading-none">{s.icon}</span>
              <div className="min-w-0">
                <p className={`text-xs font-semibold ${activeStep === idx ? "text-accent" : "text-soft"}`}>
                  Step {s.step}
                </p>
                <p className="text-[10px] text-ghost truncate">{s.title}</p>
              </div>
            </button>
          ))}
        </div>
      </div>

      {/* Right — prompt display */}
      <div className="flex-1 flex flex-col overflow-hidden">
        {/* Header */}
        <div className={`shrink-0 px-6 py-4 border-b border-border flex items-center justify-between`}>
          <div className="flex items-center gap-3">
            <div className={`w-10 h-10 rounded-xl border flex items-center justify-center text-xl shrink-0 ${step.color}`}>
              {step.icon}
            </div>
            <div>
              <p className="text-sm font-bold text-heading">Step {step.step}: {step.title}</p>
              <p className="text-[11px] text-muted">{step.description}</p>
            </div>
          </div>
          <div className="flex gap-2 shrink-0">
            {activeStep > 0 && (
              <button onClick={() => setActiveStep(p => p - 1)}
                className="h-8 px-3 rounded-lg border border-border bg-hover text-xs text-muted hover:text-primary transition-colors cursor-pointer">
                ← Prev
              </button>
            )}
            {activeStep < PROMPT_STEPS.length - 1 && (
              <button onClick={() => setActiveStep(p => p + 1)}
                className="h-8 px-3 rounded-lg bg-accent hover:bg-accent-hover text-white text-xs font-semibold transition-colors cursor-pointer">
                Next →
              </button>
            )}
          </div>
        </div>

        {/* Step progress */}
        <div className="shrink-0 flex items-center gap-1.5 px-6 py-2.5 border-b border-border bg-surface/40">
          {PROMPT_STEPS.map((s, idx) => (
            <button key={idx} onClick={() => setActiveStep(idx)}
              className={`flex items-center gap-1.5 cursor-pointer transition-all`}>
              <div className={`w-5 h-5 rounded-full flex items-center justify-center text-[10px] font-bold border transition-all ${
                idx < activeStep ? "bg-success border-success text-white"
                : idx === activeStep ? "bg-accent border-accent text-white"
                : "bg-hover border-border text-ghost"
              }`}>
                {idx < activeStep ? "✓" : idx + 1}
              </div>
              {idx < PROMPT_STEPS.length - 1 && (
                <div className={`w-6 h-px ${idx < activeStep ? "bg-success" : "bg-border"}`} />
              )}
            </button>
          ))}
          <span className="ml-3 text-[11px] text-ghost">{activeStep + 1} of {PROMPT_STEPS.length}</span>
        </div>

        {/* Prompt box */}
        <div className="flex-1 overflow-y-auto p-6">
          <div className="space-y-4">
            {/* Topic reminder */}
            {!topic && (
              <div className="flex items-center gap-2 p-3 rounded-lg bg-warning/5 border border-warning/20">
                <span className="text-warning text-sm">⚠</span>
                <p className="text-xs text-warning">Enter a topic name on the left to personalize this prompt</p>
              </div>
            )}

            {/* Prompt textarea */}
            <div className="relative">
              <div className="flex items-center justify-between mb-2">
                <span className="text-[10px] font-bold text-ghost uppercase tracking-wider">Prompt</span>
                <button onClick={() => copy(generatedPrompt, activeStep)}
                  className={`flex items-center gap-1.5 h-7 px-3 rounded-lg border text-[11px] font-semibold transition-all cursor-pointer ${
                    copied === activeStep
                      ? "bg-success/10 border-success/30 text-success"
                      : "bg-hover border-border text-muted hover:border-accent/40 hover:text-primary"
                  }`}>
                  {copied === activeStep
                    ? <><Check size={11} strokeWidth={2.5} /> Copied!</>
                    : <><FileText size={11} strokeWidth={1.8} /> Copy Prompt</>}
                </button>
              </div>
              <pre className="w-full bg-hover border border-border rounded-xl p-4 text-xs text-primary font-mono leading-relaxed whitespace-pre-wrap overflow-x-auto">
                {generatedPrompt}
              </pre>
            </div>

            {/* How to use */}
            <div className="bg-panel border border-border rounded-xl p-4">
              <p className="text-[10px] font-bold text-ghost uppercase tracking-wider mb-2">How to use</p>
              {activeStep === 0 && <p className="text-xs text-muted leading-relaxed">Go to <strong className="text-soft">Admin → Content → Topics</strong>, click the <strong className="text-soft">+</strong> button, fill in the details, and save. Then come back and move to Step 2.</p>}
              {activeStep === 1 && <p className="text-xs text-muted leading-relaxed">Copy this prompt, paste it to me (Claude) in this chat. I'll generate the section names. Then go to <strong className="text-soft">Admin → Content → Sections</strong> and create each one under your topic.</p>}
              {activeStep === 2 && <p className="text-xs text-muted leading-relaxed">Copy this prompt, paste it to me (Claude). I'll return a JSON array. Download it as a <code className="text-accent bg-accent/10 px-1 rounded">.json</code> file, then go to <strong className="text-soft">Admin → Bulk Import</strong>, select your topic + section, and upload the file.</p>}
              {activeStep === 3 && <p className="text-xs text-muted leading-relaxed">Go to <strong className="text-soft">Admin → Content → Questions</strong>, click <strong className="text-soft">Answer</strong> on any question, copy this prompt + paste the question to me (Claude), then paste the answer into the editor and save.</p>}
              {activeStep === 4 && <p className="text-xs text-muted leading-relaxed">Copy this prompt, paste your list of questions below it, and send to me (Claude). I'll generate all answers at once. Then paste each answer into the Answer editor in <strong className="text-soft">Admin → Content</strong>.</p>}
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}

const NAV = [
  { id: "dashboard", label: "Dashboard",    Icon: LayoutDashboard },
  { id: "content",   label: "Content",      Icon: BookOpen        },
  { id: "import",    label: "Bulk Import",  Icon: Upload          },
  { id: "users",     label: "Users",        Icon: Users           },
  { id: "notifs",    label: "Notifications", Icon: Bell           },
  { id: "roadmap",   label: "Roadmap",      Icon: Map             },
  { id: "prompts",   label: "Prompts",      Icon: FileText        },
];

function AdminLayout({ adminUser }) {
  const [view, setView] = useState("dashboard");
  const { theme, toggleTheme } = useTheme();

  async function signOut() {
    await supabase.auth.signOut();
    window.location.href = "/";
  }

  return (
    <div className="flex h-full bg-surface text-bright font-sans">

      {/* Sidebar */}
      <aside className="w-52 shrink-0 bg-panel border-r border-border flex flex-col">
        {/* Logo */}
        <div className="flex items-center gap-2.5 px-4 py-4 border-b border-border">
          <div className="w-7 h-7 rounded-lg bg-accent flex items-center justify-center shrink-0" style={{ boxShadow: "0 0 12px rgba(99,102,241,0.35)" }}>
            <CheckCircle size={14} strokeWidth={2.5} className="text-white" />
          </div>
          <div>
            <p className="text-xs font-bold text-bright">DevReady</p>
            <p className="text-[10px] text-danger font-semibold tracking-wider uppercase">Admin</p>
          </div>
        </div>

        {/* Nav */}
        <nav className="flex-1 py-3 px-2 space-y-0.5">
          {NAV.map(({ id, label, Icon }) => (
            <button
              key={id}
              onClick={() => setView(id)}
              className={`flex items-center gap-2.5 w-full px-3 py-2 rounded-lg text-xs font-medium transition-colors cursor-pointer ${
                view === id ? "bg-accent/10 text-accent border border-accent/20" : "text-muted hover:bg-hover hover:text-primary border border-transparent"
              }`}
            >
              <Icon size={13} strokeWidth={1.7} />
              {label}
            </button>
          ))}
        </nav>

        {/* Back to app + user */}
        <div className="border-t border-border p-3 space-y-1">
          <div className="flex items-center gap-1">
            <a href="/"
              className="flex-1 flex items-center gap-2 px-3 py-2 rounded-lg text-xs font-medium text-muted hover:bg-hover hover:text-primary transition-colors">
              <ArrowLeft size={12} strokeWidth={1.7} />
              Back to App
            </a>
            <button onClick={toggleTheme}
              className="w-8 h-8 flex items-center justify-center rounded-lg text-ghost hover:text-primary hover:bg-hover transition-colors cursor-pointer shrink-0"
              title={theme === "dark" ? "Switch to light mode" : "Switch to dark mode"}>
              {theme === "dark" ? (
                <svg width="14" height="14" viewBox="0 0 15 15" fill="none">
                  <circle cx="7.5" cy="7.5" r="3" stroke="currentColor" strokeWidth="1.3"/>
                  <path d="M7.5 1v1.5M7.5 12.5V14M1 7.5h1.5M12.5 7.5H14M2.9 2.9l1.06 1.06M11.04 11.04l1.06 1.06M2.9 12.1l1.06-1.06M11.04 3.96l1.06-1.06" stroke="currentColor" strokeWidth="1.3" strokeLinecap="round"/>
                </svg>
              ) : (
                <svg width="13" height="13" viewBox="0 0 14 14" fill="none">
                  <path d="M12.5 8.5A5.5 5.5 0 0 1 5.5 1.5a5.5 5.5 0 1 0 7 7z" stroke="currentColor" strokeWidth="1.3" strokeLinecap="round" strokeLinejoin="round"/>
                </svg>
              )}
            </button>
          </div>
          <div className="px-3 py-2">
            <p className="text-[11px] font-medium text-soft truncate">{adminUser?.email}</p>
            <button onClick={signOut} className="text-[10px] text-ghost hover:text-danger transition-colors cursor-pointer mt-0.5">
              Sign out
            </button>
          </div>
        </div>
      </aside>

      {/* Main */}
      <main className="flex-1 overflow-hidden">
        {view === "dashboard" && <AdminDashboard />}
        {view === "content"   && <AdminContent />}
        {view === "import"    && <AdminBulkImport />}
        {view === "users"     && <AdminUsers />}
        {view === "notifs"    && <AdminNotifications adminUser={adminUser} />}
        {view === "roadmap"   && <AdminRoadmap />}
        {view === "prompts"   && <AdminPrompts />}
      </main>
    </div>
  );
}

/* ── Root ────────────────────────────────────────────────────── */
export default function AdminPage() {
  const { status, adminUser } = useAdminAuth();

  if (status === "loading") {
    return (
      <div className="h-full bg-surface flex items-center justify-center">
        <div className="w-6 h-6 rounded-full border-2 border-border border-t-accent" style={{ animation: "spin 0.8s linear infinite" }} />
      </div>
    );
  }

  if (status === "denied") {
    return (
      <div className="h-full bg-surface flex flex-col items-center justify-center text-center px-6">
        <div className="text-4xl mb-4">🔒</div>
        <h1 className="text-xl font-bold text-heading mb-2">Access Denied</h1>
        <p className="text-sm text-muted max-w-sm mb-6">
          This area is restricted to admin accounts. Sign in with an admin account to continue.
        </p>
        <a href="/" className="h-9 px-5 rounded-lg bg-accent hover:bg-accent-hover text-white text-sm font-semibold transition-colors inline-flex items-center">
          ← Back to App
        </a>
      </div>
    );
  }

  return <AdminLayout adminUser={adminUser} />;
}
