import { useState, useEffect, useCallback } from "react";
import { useAdminAuth } from "../hooks/useAdminAuth";
import { supabase } from "../config/supabaseClient";
import { renderMarkdown } from "../utils/markdown";
import {
  getAdminStats, getRecentUsers,
  adminGetTopics, adminCreateTopic, adminUpdateTopic, adminDeleteTopic,
  adminGetSections, adminCreateSection, adminUpdateSection, adminDeleteSection,
  adminGetQuestions, adminCreateQuestion, adminUpdateQuestion, adminDeleteQuestion,
  adminGetAnswer, adminUpsertAnswer,
  adminGetUsers, adminGetUserStats, adminSetUserRole,
  adminGetDifficultyLevels,
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

function StatCard({ icon, label, value }) {
  return (
    <div className="bg-panel border border-border rounded-xl p-4 flex items-center gap-3">
      <div className="w-10 h-10 rounded-xl bg-accent/10 border border-accent/20 flex items-center justify-center text-xl shrink-0">{icon}</div>
      <div>
        <p className="text-2xl font-bold text-heading tabular-nums">{value}</p>
        <p className="text-xs text-muted font-medium">{label}</p>
      </div>
    </div>
  );
}

/* ── Dashboard ───────────────────────────────────────────────── */
function AdminDashboard() {
  const [stats, setStats] = useState(null);
  const [recent, setRecent] = useState([]);

  useEffect(() => {
    getAdminStats().then(setStats).catch(console.error);
    getRecentUsers(8).then(setRecent).catch(console.error);
  }, []);

  return (
    <div className="p-6 space-y-6 overflow-y-auto h-full">
      <div>
        <h1 className="text-xl font-bold text-heading">Dashboard</h1>
        <p className="text-sm text-muted mt-0.5">Platform overview</p>
      </div>

      <div className="grid grid-cols-2 lg:grid-cols-5 gap-3">
        <StatCard icon="📚" label="Topics" value={stats?.topics ?? "…"} />
        <StatCard icon="📂" label="Sections" value={stats?.sections ?? "…"} />
        <StatCard icon="❓" label="Questions" value={stats?.questions ?? "…"} />
        <StatCard icon="✍️" label="Answers" value={stats?.answers ?? "…"} />
        <StatCard icon="👤" label="Users" value={stats?.users ?? "…"} />
      </div>

      <div>
        <h2 className="text-xs font-semibold tracking-widest uppercase text-ghost mb-3">Recent Users</h2>
        <div className="bg-panel border border-border rounded-xl overflow-hidden">
          <table className="w-full text-sm">
            <thead>
              <tr className="border-b border-border">
                <th className="text-left px-4 py-2.5 text-xs font-semibold text-muted">Email</th>
                <th className="text-left px-4 py-2.5 text-xs font-semibold text-muted">Name</th>
                <th className="text-left px-4 py-2.5 text-xs font-semibold text-muted">Role</th>
                <th className="text-left px-4 py-2.5 text-xs font-semibold text-muted">Joined</th>
              </tr>
            </thead>
            <tbody>
              {recent.map((u) => (
                <tr key={u.id} className="border-b border-border/50 hover:bg-hover/40 transition-colors">
                  <td className="px-4 py-2.5 text-primary">{u.email}</td>
                  <td className="px-4 py-2.5 text-muted">{u.full_name || "—"}</td>
                  <td className="px-4 py-2.5">
                    <span className={`text-xs px-2 py-0.5 rounded-full font-medium ${u.role === "admin" ? "bg-accent/15 text-accent" : "bg-hover text-muted"}`}>
                      {u.role}
                    </span>
                  </td>
                  <td className="px-4 py-2.5 text-muted tabular-nums text-xs">
                    {new Date(u.created_at).toLocaleDateString()}
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
          {recent.length === 0 && (
            <p className="text-xs text-ghost text-center py-8">No users yet</p>
          )}
        </div>
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

  // Modals
  const [topicForm, setTopicForm] = useState(null);   // null | "new" | topic obj
  const [sectionForm, setSectionForm] = useState(null);
  const [questionForm, setQuestionForm] = useState(null);
  const [answerEditor, setAnswerEditor] = useState(null); // question obj
  const [confirmDel, setConfirmDel] = useState(null);  // {type, id, label}

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

  return (
    <div className="flex h-full overflow-hidden">

      {/* ── Topics column ── */}
      <div className="w-52 shrink-0 border-r border-border flex flex-col overflow-hidden">
        <div className="flex items-center justify-between px-3 py-2.5 border-b border-border">
          <span className="text-[10px] font-semibold tracking-widest uppercase text-ghost">Topics</span>
          <button onClick={() => setTopicForm("new")} className="text-accent hover:text-accent-hover text-lg cursor-pointer" title="New topic">+</button>
        </div>
        <div className="flex-1 overflow-y-auto py-1">
          {loading && <p className="text-xs text-ghost text-center py-4">Loading…</p>}
          {topics.map((t) => (
            <div
              key={t.id}
              className={`flex items-center gap-2 px-3 py-2 cursor-pointer group transition-colors ${activeTopic?.id === t.id ? "bg-accent/10 text-bright" : "hover:bg-hover text-muted"}`}
              onClick={() => setActiveTopic(t)}
            >
              {t.icon_emoji && <span className="shrink-0">{t.icon_emoji}</span>}
              <span className="flex-1 text-xs font-medium truncate">{t.label}</span>
              <div className="flex gap-1 opacity-0 group-hover:opacity-100 transition-opacity">
                <button
                  onClick={(e) => { e.stopPropagation(); setTopicForm(t); }}
                  className="text-ghost hover:text-muted cursor-pointer text-[11px]"
                  title="Edit"
                >✎</button>
                <button
                  onClick={(e) => { e.stopPropagation(); setConfirmDel({ type: "topic", id: t.id, label: t.label }); }}
                  className="text-ghost hover:text-danger cursor-pointer text-[11px]"
                  title="Delete"
                >✕</button>
              </div>
            </div>
          ))}
        </div>
      </div>

      {/* ── Sections column ── */}
      <div className="w-52 shrink-0 border-r border-border flex flex-col overflow-hidden">
        <div className="flex items-center justify-between px-3 py-2.5 border-b border-border">
          <span className="text-[10px] font-semibold tracking-widest uppercase text-ghost">
            {activeTopic ? activeTopic.label : "Sections"}
          </span>
          {activeTopic && (
            <button onClick={() => setSectionForm("new")} className="text-accent hover:text-accent-hover text-lg cursor-pointer" title="New section">+</button>
          )}
        </div>
        <div className="flex-1 overflow-y-auto py-1">
          {!activeTopic && <p className="text-xs text-ghost text-center py-6">Select a topic</p>}
          {sections.map((s) => (
            <div
              key={s.id}
              className={`flex items-center gap-2 px-3 py-2 cursor-pointer group transition-colors ${activeSection?.id === s.id ? "bg-accent/10 text-bright" : "hover:bg-hover text-muted"}`}
              onClick={() => setActiveSection(s)}
            >
              <span className="flex-1 text-xs font-medium truncate">{s.label}</span>
              <div className="flex gap-1 opacity-0 group-hover:opacity-100 transition-opacity">
                <button onClick={(e) => { e.stopPropagation(); setSectionForm(s); }} className="text-ghost hover:text-muted cursor-pointer text-[11px]" title="Edit">✎</button>
                <button onClick={(e) => { e.stopPropagation(); setConfirmDel({ type: "section", id: s.id, label: s.label }); }} className="text-ghost hover:text-danger cursor-pointer text-[11px]" title="Delete">✕</button>
              </div>
            </div>
          ))}
        </div>
      </div>

      {/* ── Questions panel ── */}
      <div className="flex-1 flex flex-col overflow-hidden">
        <div className="flex items-center justify-between px-4 py-2.5 border-b border-border shrink-0">
          <span className="text-[10px] font-semibold tracking-widest uppercase text-ghost">
            {activeSection ? activeSection.label : "Questions"}
          </span>
          {activeSection && (
            <Btn variant="primary" onClick={() => setQuestionForm("new")}>+ New Question</Btn>
          )}
        </div>

        <div className="flex-1 overflow-y-auto">
          {!activeSection ? (
            <p className="text-xs text-ghost text-center py-10">Select a section to see questions</p>
          ) : questions.length === 0 ? (
            <p className="text-xs text-ghost text-center py-10">No questions yet — add one above</p>
          ) : (
            <table className="w-full text-sm">
              <thead className="sticky top-0 bg-panel z-10">
                <tr className="border-b border-border">
                  <th className="text-left px-4 py-2 text-xs font-semibold text-muted w-10">#</th>
                  <th className="text-left px-4 py-2 text-xs font-semibold text-muted">Question</th>
                  <th className="text-left px-4 py-2 text-xs font-semibold text-muted w-24">Difficulty</th>
                  <th className="text-right px-4 py-2 text-xs font-semibold text-muted w-36">Actions</th>
                </tr>
              </thead>
              <tbody>
                {questions.map((q) => (
                  <tr key={q.id} className="border-b border-border/50 hover:bg-hover/30 group">
                    <td className="px-4 py-2.5 text-ghost text-xs tabular-nums">{q.serial_number}</td>
                    <td className="px-4 py-2.5 text-primary leading-snug">{q.text}</td>
                    <td className="px-4 py-2.5 text-xs text-muted">{q.difficulty_levels?.label || "—"}</td>
                    <td className="px-4 py-2.5">
                      <div className="flex gap-1.5 justify-end">
                        <Btn onClick={() => setAnswerEditor(q)}>Answer</Btn>
                        <Btn onClick={() => setQuestionForm(q)}>Edit</Btn>
                        <Btn variant="danger" onClick={() => setConfirmDel({ type: "question", id: q.id, label: q.text.slice(0, 40) })}>Del</Btn>
                      </div>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          )}
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
    !search || u.email.toLowerCase().includes(search.toLowerCase()) || (u.full_name || "").toLowerCase().includes(search.toLowerCase())
  );

  return (
    <div className="p-6 space-y-4 overflow-y-auto h-full">
      <div className="flex items-center justify-between gap-4">
        <div>
          <h1 className="text-xl font-bold text-heading">Users</h1>
          <p className="text-sm text-muted mt-0.5">{users.length} registered</p>
        </div>
        <input
          className="h-9 px-3 rounded-lg bg-panel border border-border text-primary text-sm outline-none focus:border-accent transition-colors placeholder:text-ghost w-56"
          placeholder="Search by email…"
          value={search}
          onChange={(e) => setSearch(e.target.value)}
        />
      </div>

      <div className="bg-panel border border-border rounded-xl overflow-hidden">
        {loading ? (
          <p className="text-xs text-ghost text-center py-10">Loading…</p>
        ) : (
          <table className="w-full text-sm">
            <thead>
              <tr className="border-b border-border">
                <th className="text-left px-4 py-3 text-xs font-semibold text-muted">User</th>
                <th className="text-left px-4 py-3 text-xs font-semibold text-muted">Provider</th>
                <th className="text-left px-4 py-3 text-xs font-semibold text-muted">Role</th>
                <th className="text-left px-4 py-3 text-xs font-semibold text-muted">Joined</th>
                <th className="text-right px-4 py-3 text-xs font-semibold text-muted">Actions</th>
              </tr>
            </thead>
            <tbody>
              {filtered.map((u) => (
                <>
                  <tr key={u.id} className="border-b border-border/50 hover:bg-hover/30">
                    <td className="px-4 py-3">
                      <p className="text-primary font-medium">{u.email}</p>
                      {u.full_name && <p className="text-xs text-muted">{u.full_name}</p>}
                    </td>
                    <td className="px-4 py-3 text-xs text-muted capitalize">{u.provider || "—"}</td>
                    <td className="px-4 py-3">
                      <select
                        value={u.role}
                        onChange={(e) => handleRoleChange(u.id, e.target.value)}
                        className="text-xs px-2 py-1 rounded-md bg-hover border border-border text-primary cursor-pointer outline-none focus:border-accent"
                      >
                        <option value="user">user</option>
                        <option value="admin">admin</option>
                      </select>
                    </td>
                    <td className="px-4 py-3 text-xs text-muted tabular-nums">
                      {new Date(u.created_at).toLocaleDateString()}
                    </td>
                    <td className="px-4 py-3 text-right">
                      <Btn onClick={() => toggleStats(u.id)} disabled={!!expanding[u.id]}>
                        {expanding[u.id] ? "…" : stats[u.id] ? "Hide Stats" : "Stats"}
                      </Btn>
                    </td>
                  </tr>
                  {stats[u.id] && (
                    <tr key={`${u.id}-stats`} className="border-b border-border/50 bg-hover/20">
                      <td colSpan={5} className="px-4 py-2">
                        <div className="flex items-center gap-6 text-xs text-muted">
                          <span>Total tracked: <strong className="text-primary">{stats[u.id].total}</strong></span>
                          <span>Done: <strong className="text-success">{stats[u.id].done}</strong></span>
                          <span>In Progress: <strong className="text-warning">{stats[u.id].inProgress}</strong></span>
                        </div>
                      </td>
                    </tr>
                  )}
                </>
              ))}
              {filtered.length === 0 && (
                <tr><td colSpan={5} className="text-center py-8 text-xs text-ghost">No users found</td></tr>
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
  { id: "dashboard", label: "Dashboard", icon: "▦" },
  { id: "content",   label: "Content",   icon: "📚" },
  { id: "users",     label: "Users",     icon: "👥" },
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
        <div className="flex items-center gap-2 px-4 py-4 border-b border-border">
          <div className="w-7 h-7 rounded-lg bg-accent flex items-center justify-center text-white text-xs font-bold" style={{ boxShadow: '0 0 12px rgba(99,102,241,0.35)' }}>D</div>
          <div>
            <p className="text-xs font-bold text-bright">DevReady</p>
            <p className="text-[10px] text-danger font-semibold tracking-wide uppercase">Admin</p>
          </div>
        </div>

        {/* Nav */}
        <nav className="flex-1 py-3 px-2 space-y-0.5">
          {NAV.map((n) => (
            <button
              key={n.id}
              onClick={() => setView(n.id)}
              className={`flex items-center gap-2.5 w-full px-3 py-2 rounded-lg text-xs font-medium transition-colors cursor-pointer ${
                view === n.id ? "bg-accent/10 text-accent" : "text-muted hover:bg-hover hover:text-primary"
              }`}
            >
              <span>{n.icon}</span>
              {n.label}
            </button>
          ))}
        </nav>

        {/* Back to app + user */}
        <div className="border-t border-border p-3 space-y-2">
          <a
            href="/"
            className="flex items-center gap-2 px-3 py-2 rounded-lg text-xs font-medium text-muted hover:bg-hover hover:text-primary transition-colors"
          >
            ← Back to App
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
