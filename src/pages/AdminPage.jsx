import { useState, useEffect } from "react";
import { useAdminAuth } from "../hooks/useAdminAuth";
import { supabase } from "../config/supabaseClient";
import { renderMarkdown } from "../utils/markdown";
import {
  LayoutDashboard, BookOpen, Users, ArrowLeft,
  Layers, HelpCircle, FileText, CheckCircle, AlertCircle,
  TrendingUp, Shield, Zap, Database,
  Plus, Pencil, Trash2, ChevronRight, Search,
  UserCircle, Crown, X, Eye,
} from "lucide-react";
import {
  getAdminStats, getRecentUsers,
  adminGetTopics, adminCreateTopic, adminUpdateTopic, adminDeleteTopic,
  adminGetSections, adminCreateSection, adminUpdateSection, adminDeleteSection,
  adminGetQuestions, adminCreateQuestion, adminUpdateQuestion, adminDeleteQuestion,
  adminGetAnswer, adminUpsertAnswer,
  adminGetUsers, adminGetUserStats, adminSetUserRole,
  adminGetDifficultyLevels,
  getContentHealth, getTopicPerformance,
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
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    Promise.all([
      getAdminStats(),
      getContentHealth(),
      getTopicPerformance(),
      getRecentUsers(6),
    ]).then(([s, h, tp, r]) => {
      setStats(s); setHealth(h); setTopicPerf(tp); setRecent(r);
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

/* ── Admin Layout ────────────────────────────────────────────── */
const NAV = [
  { id: "dashboard", label: "Dashboard", Icon: LayoutDashboard },
  { id: "content",   label: "Content",   Icon: BookOpen        },
  { id: "users",     label: "Users",     Icon: Users           },
];

function AdminLayout({ adminUser }) {
  const [view, setView] = useState("dashboard");

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
          <a
            href="/"
            className="flex items-center gap-2 px-3 py-2 rounded-lg text-xs font-medium text-muted hover:bg-hover hover:text-primary transition-colors"
          >
            <ArrowLeft size={12} strokeWidth={1.7} />
            Back to App
          </a>
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
        {view === "users"     && <AdminUsers />}
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
