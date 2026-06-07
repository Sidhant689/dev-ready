import { useEffect, useRef, useMemo, useState, useCallback } from "react";
import {
  Lock, FileText, Sparkles, Share2, MessageSquare,
  Brain, ThumbsUp, ThumbsDown, X, Check, ChevronLeft, ChevronRight,
  Bookmark, BookmarkCheck,
} from "lucide-react";
import { renderMarkdown } from "../utils/markdown";
import Badge from "./ui/Badge";
import Spinner from "./ui/Spinner";
import { useNotes } from "../hooks/useNotes";
import { explainDifferently } from "../services/aiService";
import { useSpacedRepetition } from "../hooks/useSpacedRepetition";
import CommentsPanel from "./CommentsPanel";
import { fetchAnswerRating, rateAnswer } from "../services/commentService";

export const GUEST_FREE_LIMIT = 3;

const STATUS_CYCLE = ["To Do", "In Progress", "Done"];
const STATUS_STYLE = {
  "To Do":       { pill: "border-border text-ghost",                           icon: "○" },
  "In Progress": { pill: "border-warning/50 text-warning bg-warning/10",       icon: "◐" },
  "Done":        { pill: "border-success/50 text-success bg-success/10",       icon: "✓" },
};

function estimateReadTime(html) {
  if (!html) return null;
  const words = html.replace(/<[^>]+>/g, " ").split(/\s+/).filter(Boolean).length;
  return `~${Math.max(1, Math.ceil(words / 220))} min`;
}

/* ── Guest gate ─────────────────────────────────────────────────────────── */
function GuestGate({ onSignIn, onSignUp }) {
  return (
    <div className="flex flex-col items-center justify-center h-full px-8 text-center">
      <div className="w-14 h-14 rounded-2xl bg-accent/10 border border-accent/25 flex items-center justify-center mb-5 text-accent">
        <Lock size={24} strokeWidth={1.5} />
      </div>
      <h2 className="text-lg font-bold text-heading mb-2">Sign in to unlock</h2>
      <p className="text-sm text-muted max-w-xs leading-relaxed mb-6">
        Free preview includes the first {GUEST_FREE_LIMIT} questions. Create a free account to access all 500+ questions.
      </p>
      <div className="flex gap-2 w-full max-w-xs">
        <button onClick={onSignUp}
          className="flex-1 h-10 rounded-lg bg-accent hover:bg-accent-hover text-white font-semibold text-sm cursor-pointer transition-colors"
          style={{ boxShadow: "0 0 16px rgba(99,102,241,0.3)" }}>
          Create Account
        </button>
        <button onClick={onSignIn}
          className="flex-1 h-10 rounded-lg border border-border text-muted text-sm font-medium hover:bg-hover cursor-pointer transition-colors">
          Sign In
        </button>
      </div>
    </div>
  );
}

/* ── Right panel: Notes ──────────────────────────────────────────────────── */
function PanelNotes({ user, questionId, isGuest, onOpenAuth }) {
  const { note, saving, saved, saveNote } = useNotes(user, questionId);
  if (isGuest) return (
    <div className="flex flex-col items-center justify-center flex-1 px-5 text-center">
      <FileText size={22} strokeWidth={1.4} className="text-ghost mb-3" />
      <p className="text-xs font-semibold text-soft mb-1">Notes require an account</p>
      <button onClick={() => onOpenAuth("signup")}
        className="mt-3 h-8 px-4 rounded-lg bg-accent text-white text-xs font-semibold cursor-pointer">
        Sign in
      </button>
    </div>
  );
  return (
    <div className="flex flex-col flex-1 min-h-0 p-4 gap-2">
      <div className="flex items-center justify-between text-[11px]">
        <span className="font-semibold text-soft">My Notes</span>
        <span className="text-ghost">{saving ? "Saving…" : saved ? "Saved ✓" : ""}</span>
      </div>
      <textarea
        className="flex-1 min-h-0 w-full bg-hover border border-border rounded-lg p-3 text-sm text-primary resize-none outline-none focus:border-accent/60 transition-colors placeholder:text-ghost"
        placeholder="Write your notes… (auto-saved)"
        value={note}
        onChange={e => saveNote(e.target.value)}
      />
      <p className="text-[10px] text-ghost">Private · auto-saved as you type</p>
    </div>
  );
}

/* ── Right panel: Review (spaced repetition) ─────────────────────────────── */
function PanelReview({ questionId, user, isGuest, onOpenAuth, answer, onSaveStatus, activeKey }) {
  const { rate } = useSpacedRepetition(user);
  const [rated, setRated] = useState(null);
  const [helpfulness, setHelpfulness] = useState({ helpful: 0, total: 0, myRating: null });

  useEffect(() => { setRated(null); }, [questionId]);

  useEffect(() => {
    if (!questionId) return;
    fetchAnswerRating(questionId).then(setHelpfulness).catch(() => {});
  }, [questionId]);

  async function handleRate(rating) {
    if (isGuest) { onOpenAuth?.("signup"); return; }
    setRated(rating);
    await rate(questionId, rating).catch(() => {});
    if (rating >= 2) onSaveStatus(activeKey, "Done");
    else onSaveStatus(activeKey, "In Progress");
  }

  async function handleHelpful(val) {
    if (isGuest) { onOpenAuth?.("signup"); return; }
    await rateAnswer(questionId, user?.id, val).catch(() => {});
    const fresh = await fetchAnswerRating(questionId).catch(() => helpfulness);
    setHelpfulness(fresh);
  }

  const SR_BUTTONS = [
    { label: "Again", rating: 0, sub: "< 1 day", color: "text-danger",  border: "border-danger/30",  bg: "bg-danger/10"  },
    { label: "Hard",  rating: 1, sub: "1 day",    color: "text-warning", border: "border-warning/30", bg: "bg-warning/10" },
    { label: "Good",  rating: 2, sub: "6 days",   color: "text-accent",  border: "border-accent/30",  bg: "bg-accent/10"  },
    { label: "Easy",  rating: 3, sub: "varies",   color: "text-success", border: "border-success/30", bg: "bg-success/10" },
  ];

  const pct = helpfulness.total > 0 ? Math.round((helpfulness.helpful / helpfulness.total) * 100) : null;

  return (
    <div className="flex flex-col gap-5 p-5">
      {/* Spaced repetition */}
      <div>
        <p className="text-[10px] font-bold text-ghost uppercase tracking-wider mb-3">How well did you know this?</p>
        <div className="grid grid-cols-2 gap-2">
          {SR_BUTTONS.map(({ label, rating, sub, color, border, bg }) => (
            <button key={label} onClick={() => handleRate(rating)}
              className={`flex flex-col items-center py-3 rounded-xl border text-sm font-bold transition-all cursor-pointer ${
                rated === rating
                  ? `${bg} ${border} ${color}`
                  : rated !== null
                  ? "bg-hover border-border text-ghost opacity-40"
                  : `bg-hover border-border text-muted hover:${bg} hover:${border} hover:${color}`
              }`}>
              {label}
              <span className="text-[10px] font-normal mt-0.5 opacity-60">{sub}</span>
            </button>
          ))}
        </div>
        {rated !== null && (
          <p className="text-[11px] text-success mt-2 text-center">
            ✓ {rated >= 2 ? "Scheduled for review" : "Will review tomorrow"}
          </p>
        )}
      </div>

      <div className="h-px bg-border" />

      {/* Answer helpfulness */}
      <div>
        <p className="text-[10px] font-bold text-ghost uppercase tracking-wider mb-3">Was this answer helpful?</p>
        <div className="flex gap-2">
          <button onClick={() => handleHelpful(1)}
            className={`flex-1 flex items-center justify-center gap-1.5 h-9 rounded-lg border text-xs font-semibold transition-all cursor-pointer ${
              helpfulness.myRating === 1
                ? "bg-success/15 border-success/40 text-success"
                : "bg-hover border-border text-muted hover:border-success/40 hover:text-success"
            }`}>
            <ThumbsUp size={13} strokeWidth={2} /> Yes
          </button>
          <button onClick={() => handleHelpful(-1)}
            className={`flex-1 flex items-center justify-center gap-1.5 h-9 rounded-lg border text-xs font-semibold transition-all cursor-pointer ${
              helpfulness.myRating === -1
                ? "bg-danger/15 border-danger/40 text-danger"
                : "bg-hover border-border text-muted hover:border-danger/40 hover:text-danger"
            }`}>
            <ThumbsDown size={13} strokeWidth={2} /> No
          </button>
        </div>
        {pct !== null && (
          <p className="text-[11px] text-ghost mt-2 text-center tabular-nums">
            {pct}% found this helpful <span className="text-ghost/60">({helpfulness.total})</span>
          </p>
        )}
      </div>
    </div>
  );
}

/* ── Right panel: AI Explain ─────────────────────────────────────────────── */
function PanelAI({ questionText, answer }) {
  const [state, setState] = useState("idle"); // idle | loading | done | error
  const [explanation, setExplanation] = useState("");

  useEffect(() => { setState("idle"); setExplanation(""); }, [questionText]);

  async function generate() {
    if (!answer) return;
    setState("loading");
    try {
      const text = await explainDifferently(questionText, answer);
      setExplanation(text);
      setState("done");
    } catch {
      setState("error");
    }
  }

  return (
    <div className="flex flex-col flex-1 min-h-0 p-5 gap-4">
      <p className="text-[10px] font-bold text-ghost uppercase tracking-wider">AI Explanation</p>

      {state === "idle" && (
        <div className="flex flex-col items-center justify-center flex-1 text-center gap-3">
          <div className="w-12 h-12 rounded-2xl bg-violet-500/10 border border-violet-500/20 flex items-center justify-center">
            <Sparkles size={20} strokeWidth={1.5} className="text-violet-400" />
          </div>
          <p className="text-xs text-muted">Get a fresh explanation using a different analogy or mental model.</p>
          <button onClick={generate} disabled={!answer}
            className="h-9 px-5 rounded-xl bg-violet-500/15 border border-violet-500/30 text-violet-400 text-sm font-semibold hover:bg-violet-500/20 transition-all cursor-pointer disabled:opacity-40">
            Explain differently
          </button>
        </div>
      )}

      {state === "loading" && (
        <div className="flex items-center justify-center flex-1 gap-2">
          <div className="w-4 h-4 rounded-full border-2 border-violet-400 border-t-transparent" style={{ animation: "spin 0.8s linear infinite" }} />
          <span className="text-xs text-muted">Generating…</span>
        </div>
      )}

      {state === "error" && (
        <div className="flex flex-col items-center justify-center flex-1 gap-3 text-center">
          <p className="text-xs text-muted/70 italic">AI explanations are coming soon — check back later.</p>
          <button onClick={() => setState("idle")} className="text-xs text-accent hover:underline cursor-pointer">Try again</button>
        </div>
      )}

      {state === "done" && (
        <div className="flex-1 overflow-y-auto space-y-3">
          <p className="text-sm text-primary leading-relaxed whitespace-pre-wrap">{explanation}</p>
          <button onClick={() => setState("idle")}
            className="text-[11px] text-ghost hover:text-muted cursor-pointer underline">
            Generate another
          </button>
        </div>
      )}
    </div>
  );
}

/* ── Right panel: Share ──────────────────────────────────────────────────── */
function PanelShare({ questionId, questionText }) {
  const [copied, setCopied] = useState(false);
  const url = `${window.location.origin}${window.location.pathname}?q=${questionId}`;

  function copy() {
    navigator.clipboard.writeText(url).then(() => { setCopied(true); setTimeout(() => setCopied(false), 2000); });
  }

  return (
    <div className="p-5 space-y-4">
      <p className="text-[10px] font-bold text-ghost uppercase tracking-wider">Share Question</p>
      <div className="bg-hover border border-border rounded-xl p-3">
        <p className="text-xs text-muted mb-2 leading-relaxed line-clamp-2">{questionText}</p>
        <p className="text-[10px] font-mono text-ghost truncate">{url}</p>
      </div>
      <button onClick={copy}
        className={`w-full h-10 rounded-xl border text-sm font-semibold transition-all cursor-pointer flex items-center justify-center gap-2 ${
          copied
            ? "bg-success/10 border-success/30 text-success"
            : "bg-hover border-border text-muted hover:border-accent/40 hover:text-primary"
        }`}>
        {copied
          ? <><Check size={14} strokeWidth={2.5} /> Copied!</>
          : <><Share2 size={14} strokeWidth={2} /> Copy link</>}
      </button>
    </div>
  );
}

/* ── Activity bar icon button ────────────────────────────────────────────── */
function ActivityBtn({ id, icon: Icon, label, active, onClick, badge }) {
  return (
    <button onClick={() => onClick(id)}
      title={label}
      className={`relative group w-full flex flex-col items-center justify-center py-3 gap-1 transition-all cursor-pointer border-l-2 ${
        active
          ? "border-accent text-accent bg-accent/5"
          : "border-transparent text-ghost hover:text-muted hover:bg-hover"
      }`}>
      <Icon size={17} strokeWidth={active ? 2 : 1.7} />
      <span className="text-[8px] font-semibold uppercase tracking-wide leading-none opacity-70">{label}</span>
      {badge > 0 && (
        <span className="absolute top-1.5 right-1.5 min-w-3.5 h-3.5 rounded-full bg-accent text-white text-[8px] font-bold flex items-center justify-center px-0.5">
          {badge > 9 ? "9+" : badge}
        </span>
      )}
    </button>
  );
}

/* ── Main ────────────────────────────────────────────────────────────────── */
export default function QuestionDetail({
  activeQ, activeKey, activeStatus, answer, loading, error,
  currentIndex, totalCount, sectionQuestions,
  onBack, onSaveStatus, onPrev, onNext, onJumpTo,
  isGuest, onOpenAuth, user, isBookmarked, onToggleBookmark, isAdmin,
}) {
  const answerRef = useRef(null);
  const [activePanel, setActivePanel] = useState(null); // null | "notes" | "review" | "ai" | "share" | "discuss"
  const [interviewMode, setInterviewMode] = useState(false);
  const [revealed, setRevealed] = useState(false);

  // Reset on question change
  useEffect(() => {
    if (answerRef.current) answerRef.current.scrollTop = 0;
    setRevealed(false);
  }, [activeQ?.id]);

  useEffect(() => { if (interviewMode) setRevealed(false); }, [interviewMode]);

  useEffect(() => {
    const handler = (e) => {
      if (e.target.tagName === "INPUT" || e.target.tagName === "TEXTAREA" || e.target.tagName === "SELECT") return;
      if (e.key === "ArrowLeft"  || e.key === "p") onPrev();
      if (e.key === "ArrowRight" || e.key === "n") onNext();
      if (e.key === "Escape") { if (activePanel) setActivePanel(null); else onBack(); }
      if ((e.key === "i" || e.key === "I") && !e.ctrlKey && !e.metaKey) setInterviewMode(v => !v);
      if (e.key === " " && interviewMode && !isLocked) { e.preventDefault(); setRevealed(v => !v); }
    };
    window.addEventListener("keydown", handler);
    return () => window.removeEventListener("keydown", handler);
  }, [onPrev, onNext, onBack, interviewMode, activePanel]);

  function togglePanel(id) { setActivePanel(prev => prev === id ? null : id); }

  const hasPrev = currentIndex > 0;
  const hasNext = currentIndex < totalCount - 1;
  const readTime = useMemo(() => estimateReadTime(answer), [answer]);
  const isLocked = isGuest && currentIndex >= GUEST_FREE_LIMIT;
  const statusStyle = STATUS_STYLE[activeStatus] || STATUS_STYLE["To Do"];

  function cycleStatus() {
    if (isGuest) { onOpenAuth("signin"); return; }
    const idx = STATUS_CYCLE.indexOf(activeStatus);
    onSaveStatus(activeKey, STATUS_CYCLE[(idx + 1) % STATUS_CYCLE.length]);
  }

  const PANELS = [
    { id: "notes",   icon: FileText,        label: "Notes"   },
    { id: "review",  icon: Brain,           label: "Review"  },
    { id: "ai",      icon: Sparkles,        label: "AI"      },
    { id: "share",   icon: Share2,          label: "Share"   },
    { id: "discuss", icon: MessageSquare,   label: "Chat"    },
  ];

  return (
    <div className="flex flex-col h-full overflow-hidden">

      {/* ── Header ──────────────────────────────────────────────────── */}
      <div className="shrink-0 bg-panel border-b border-border px-4 py-3">
        <div className="flex items-center gap-2">
          {/* Breadcrumb */}
          <button onClick={onBack} className="text-ghost hover:text-muted transition-colors cursor-pointer shrink-0">
            <ChevronLeft size={15} strokeWidth={2} />
          </button>
          <span className="text-[11px] text-ghost truncate hidden sm:block">{activeQ.topic_label}</span>
          <span className="text-[11px] text-ghost hidden sm:block">›</span>
          <span className="text-[11px] text-muted truncate hidden sm:block">{activeQ.section_label}</span>

          <div className="flex items-center gap-1.5 ml-auto shrink-0">
            <Badge level={activeQ.difficulty} />

            {/* Interview mode */}
            <button onClick={() => setInterviewMode(v => !v)}
              className={`h-6 px-2.5 rounded-full text-[11px] font-medium transition-all cursor-pointer border ${
                interviewMode ? "bg-accent/10 border-accent/40 text-accent" : "border-border text-ghost hover:text-muted"
              }`}>
              🎯 Interview
            </button>

            {/* Status */}
            <button onClick={cycleStatus}
              className={`flex items-center gap-1 h-6 px-2.5 rounded-full text-[11px] font-medium border transition-all cursor-pointer ${
                isLocked ? "border-border text-ghost" : statusStyle.pill
              }`}>
              <span>{isLocked ? "🔒" : statusStyle.icon}</span>
              <span>{isLocked ? "Locked" : activeStatus}</span>
            </button>

            {/* Bookmark */}
            {!isLocked && (
              <button onClick={() => onToggleBookmark?.(activeQ.id, { text: activeQ.text, section_label: activeQ.section_label, topic_label: activeQ.topic_label })}
                className={`w-6 h-6 flex items-center justify-center transition-colors cursor-pointer ${isBookmarked ? "text-warning" : "text-ghost hover:text-warning"}`}>
                {isBookmarked ? <BookmarkCheck size={14} strokeWidth={2} /> : <Bookmark size={14} strokeWidth={1.7} />}
              </button>
            )}
          </div>
        </div>

        {/* Question + meta */}
        <h1 className="text-base font-semibold text-heading leading-snug mt-2.5 mb-1.5">
          {activeQ.text}
        </h1>
        <div className="flex items-center gap-2 text-[11px] text-ghost">
          <span className="tabular-nums">Q{currentIndex + 1}/{totalCount}</span>
          {!isLocked && readTime && <><span>·</span><span>{readTime}</span></>}
          {isGuest && <><span>·</span><span className="text-accent">{Math.max(0, GUEST_FREE_LIMIT - currentIndex - 1)} previews left</span></>}
        </div>
      </div>

      {/* ── Body: answer | right panel | activity bar ───────────────── */}
      <div className="flex flex-1 overflow-hidden">

        {/* Main answer area */}
        <div ref={answerRef} className="flex-1 overflow-y-auto bg-surface">
          {isLocked ? (
            <div className="h-full">
              <GuestGate onSignIn={() => onOpenAuth("signin")} onSignUp={() => onOpenAuth("signup")} />
            </div>
          ) : (
            <div className="px-6 py-6">
              {error && <div className="bg-danger/10 border border-danger/30 rounded-lg p-4 text-danger text-sm mb-4">⚠ {error}</div>}
              {loading && <div className="flex justify-center pt-20"><Spinner /></div>}

              {!loading && !answer && !error && (
                <div className="flex flex-col items-center justify-center py-20 text-center">
                  <div className="w-12 h-12 rounded-xl bg-hover border border-dashed border-border flex items-center justify-center text-xl mb-4 mx-auto">🔧</div>
                  <p className="text-sm font-semibold text-soft mb-1">Answer coming soon</p>
                  <p className="text-xs text-muted">This question hasn&apos;t been answered yet.</p>
                </div>
              )}

              {!loading && answer && (
                interviewMode && !revealed ? (
                  <div className="flex flex-col items-center justify-center py-16 text-center">
                    <div className="w-16 h-16 rounded-2xl bg-accent/10 border border-accent/20 flex items-center justify-center mb-5 text-3xl">🎯</div>
                    <h3 className="text-base font-semibold text-heading mb-2">Interview Mode</h3>
                    <p className="text-sm text-muted max-w-xs mb-6">Think through your answer first, then reveal.</p>
                    <button onClick={() => setRevealed(true)}
                      className="h-10 px-7 rounded-lg bg-accent hover:bg-accent-hover text-white font-semibold text-sm cursor-pointer transition-colors"
                      style={{ boxShadow: "0 0 16px rgba(99,102,241,0.3)" }}>
                      Reveal Answer
                    </button>
                    <p className="text-xs text-ghost mt-3">
                      Press <kbd className="font-mono px-1 rounded bg-hover border border-border">Space</kbd> to reveal
                    </p>
                  </div>
                ) : (
                  <>
                    {interviewMode && revealed && (
                      <div className="flex items-center justify-between mb-4 px-3 py-2 bg-success/5 border border-success/20 rounded-lg">
                        <span className="text-xs text-success">✓ Revealed</span>
                        <button onClick={() => setRevealed(false)} className="text-xs text-ghost hover:text-muted cursor-pointer">Hide</button>
                      </div>
                    )}
                    <div className="prose-answer" dangerouslySetInnerHTML={{ __html: renderMarkdown(answer) }} />
                  </>
                )
              )}
            </div>
          )}
        </div>

        {/* Right panel content */}
        {activePanel && !isLocked && (
          <div className="w-72 shrink-0 border-l border-border bg-panel flex flex-col overflow-hidden">
            {/* Panel header */}
            <div className="flex items-center justify-between px-4 py-3 border-b border-border shrink-0">
              <span className="text-xs font-bold text-soft uppercase tracking-wide">
                {PANELS.find(p => p.id === activePanel)?.label}
              </span>
              <button onClick={() => setActivePanel(null)}
                className="w-6 h-6 rounded-md text-ghost hover:text-muted hover:bg-hover flex items-center justify-center cursor-pointer transition-colors">
                <X size={12} strokeWidth={2} />
              </button>
            </div>

            {/* Panel body */}
            <div className="flex-1 overflow-y-auto flex flex-col min-h-0">
              {activePanel === "notes"   && <PanelNotes user={user} questionId={activeQ?.id} isGuest={isGuest} onOpenAuth={onOpenAuth} />}
              {activePanel === "review"  && <PanelReview questionId={activeQ?.id} user={user} isGuest={isGuest} onOpenAuth={onOpenAuth} answer={answer} onSaveStatus={onSaveStatus} activeKey={activeKey} />}
              {activePanel === "ai"      && <PanelAI questionText={activeQ?.text} answer={answer} />}
              {activePanel === "share"   && <PanelShare questionId={activeQ?.id} questionText={activeQ?.text} />}
              {activePanel === "discuss" && (
                <div className="p-4 flex-1 overflow-y-auto">
                  <CommentsPanel
                    questionId={activeQ?.id}
                    questionText={activeQ?.text}
                    user={user}
                    isGuest={isGuest}
                    onOpenAuth={onOpenAuth}
                    isAdmin={isAdmin}
                    compact
                  />
                </div>
              )}
            </div>
          </div>
        )}

        {/* Activity bar — VS Code style right sidebar */}
        {!isLocked && (
          <div className="w-12 shrink-0 border-l border-border bg-panel flex flex-col items-center py-1">
            {PANELS.map(p => (
              <ActivityBtn
                key={p.id}
                id={p.id}
                icon={p.icon}
                label={p.label}
                active={activePanel === p.id}
                onClick={togglePanel}
              />
            ))}
          </div>
        )}
      </div>

      {/* ── Bottom nav ──────────────────────────────────────────────── */}
      <div className="shrink-0 bg-panel border-t border-border px-4 h-11 flex items-center gap-3">
        <button onClick={onPrev} disabled={!hasPrev}
          className={`flex items-center gap-1 text-xs font-medium transition-colors cursor-pointer ${hasPrev ? "text-muted hover:text-primary" : "text-ghost cursor-not-allowed"}`}>
          <ChevronLeft size={13} strokeWidth={2} /> Prev
        </button>

        <div className="flex-1 flex justify-center">
          <select value={currentIndex} onChange={e => onJumpTo(e.target.value)}
            className="h-7 px-2 rounded-md bg-hover border border-border text-xs text-primary cursor-pointer outline-none focus:border-accent max-w-56 tabular-nums">
            {sectionQuestions.map((q, idx) => (
              <option key={q.id} value={idx}>
                {isGuest && idx >= GUEST_FREE_LIMIT ? "🔒 " : ""}Q{idx + 1}. {q.text.length > 45 ? q.text.slice(0, 45) + "…" : q.text}
              </option>
            ))}
          </select>
        </div>

        <button onClick={onNext} disabled={!hasNext}
          className={`flex items-center gap-1 text-xs font-medium transition-colors cursor-pointer ${hasNext ? "text-muted hover:text-primary" : "text-ghost cursor-not-allowed"}`}>
          Next <ChevronRight size={13} strokeWidth={2} />
        </button>
      </div>
    </div>
  );
}
