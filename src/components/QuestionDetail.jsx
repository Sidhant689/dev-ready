import { useEffect, useRef, useMemo, useState } from "react";
import { renderMarkdown } from "../utils/markdown";
import Badge from "./ui/Badge";
import Spinner from "./ui/Spinner";
import { useNotes } from "../hooks/useNotes";

// Guests can freely read the first N questions in any section
export const GUEST_FREE_LIMIT = 3;

const STATUS_CYCLE = ["To Do", "In Progress", "Done"];

const STATUS_STYLE = {
  "To Do": {
    pill: "border border-border text-muted bg-transparent hover:border-subtle hover:text-soft",
    icon: "○",
  },
  "In Progress": {
    pill: "border border-warning/50 text-warning bg-warning/10 hover:bg-warning/15",
    icon: "◐",
  },
  "Done": {
    pill: "border border-success/50 text-success bg-success/10 hover:bg-success/15",
    icon: "✓",
  },
};

function estimateReadTime(html) {
  if (!html) return null;
  const words = html.replace(/<[^>]+>/g, " ").split(/\s+/).filter(Boolean).length;
  const mins = Math.max(1, Math.ceil(words / 220));
  return `~${mins} min read`;
}

/* Gate shown when a guest tries to open a locked question */
function GuestGate({ onSignIn, onSignUp }) {
  return (
    <div className="flex flex-col items-center justify-center h-full px-6 text-center">
      <div
        className="w-16 h-16 rounded-2xl flex items-center justify-center mb-6 text-2xl"
        style={{ background: 'rgba(99,102,241,0.12)', border: '1px solid rgba(99,102,241,0.25)' }}
      >
        🔒
      </div>

      <h2 className="text-xl font-bold text-heading mb-2">
        Sign in to unlock this answer
      </h2>
      <p className="text-sm text-muted max-w-sm leading-relaxed mb-8">
        Free preview includes the first {GUEST_FREE_LIMIT} questions per section.
        Create a free account to access all{" "}
        <span className="text-primary font-medium">500+ questions</span> and sync your progress.
      </p>

      <div className="flex flex-col sm:flex-row gap-3 w-full max-w-xs">
        <button
          onClick={onSignUp}
          className="flex-1 h-11 rounded-lg bg-accent hover:bg-accent-hover text-white font-semibold text-sm transition-all cursor-pointer"
          style={{ boxShadow: '0 0 16px rgba(99,102,241,0.3)' }}
        >
          Create Free Account
        </button>
        <button
          onClick={onSignIn}
          className="flex-1 h-11 rounded-lg border border-border text-primary font-medium text-sm hover:bg-hover transition-colors cursor-pointer"
        >
          Sign In
        </button>
      </div>

      <p className="text-xs text-ghost mt-5">No credit card required · Free forever</p>
    </div>
  );
}

/* Notes panel */
function NotesPanel({ user, questionId, isGuest, onOpenAuth }) {
  const { note, saving, saved, saveNote } = useNotes(user, questionId);

  if (isGuest) {
    return (
      <div className="flex flex-col items-center justify-center h-full px-6 text-center py-8">
        <div className="text-2xl mb-3">📝</div>
        <p className="text-sm font-semibold text-soft mb-1">Notes are saved to your account</p>
        <p className="text-xs text-muted mb-4 leading-relaxed">Sign in to write and sync personal notes for each question.</p>
        <button
          onClick={() => onOpenAuth("signup")}
          className="h-8 px-4 rounded-lg bg-accent hover:bg-accent-hover text-white text-xs font-semibold transition-colors cursor-pointer"
        >
          Sign In to Add Notes
        </button>
      </div>
    );
  }

  return (
    <div className="flex flex-col h-full p-4 gap-3">
      <div className="flex items-center justify-between">
        <p className="text-xs font-semibold text-soft">My Notes</p>
        <span className="text-[10px] text-ghost">
          {saving ? "Saving…" : saved ? "Saved ✓" : ""}
        </span>
      </div>
      <textarea
        className="flex-1 w-full bg-hover border border-border rounded-lg p-3 text-sm text-primary resize-none outline-none focus:border-accent/60 placeholder-ghost transition-colors"
        placeholder="Write your notes here… (auto-saved)"
        value={note}
        onChange={(e) => saveNote(e.target.value)}
      />
      <p className="text-[10px] text-ghost">Notes are private and auto-saved as you type.</p>
    </div>
  );
}

export default function QuestionDetail({
  activeQ,
  activeKey,
  activeStatus,
  answer,
  loading,
  error,
  currentIndex,
  totalCount,
  sectionQuestions,
  onBack,
  onSaveStatus,
  onPrev,
  onNext,
  onJumpTo,
  isGuest,
  onOpenAuth,
  user,
  isBookmarked,
  onToggleBookmark,
}) {
  const answerRef = useRef(null);
  const [tab, setTab] = useState("answer"); // "answer" | "notes"
  const [interviewMode, setInterviewMode] = useState(false);
  const [revealed, setRevealed] = useState(false);

  useEffect(() => {
    if (answerRef.current) answerRef.current.scrollTop = 0;
    setRevealed(false); // hide answer when switching question in interview mode
  }, [activeQ?.id]);

  // Reset interview mode reveal when toggling the mode on
  useEffect(() => {
    if (interviewMode) setRevealed(false);
  }, [interviewMode]);

  useEffect(() => {
    const handler = (e) => {
      if (e.target.tagName === "INPUT" || e.target.tagName === "SELECT" || e.target.tagName === "TEXTAREA") return;
      if (e.key === "ArrowLeft"  || e.key === "p") onPrev();
      if (e.key === "ArrowRight" || e.key === "n") onNext();
      if (e.key === "Escape") onBack();
      if ((e.key === "i" || e.key === "I") && !e.ctrlKey && !e.metaKey) setInterviewMode((v) => !v);
      if (e.key === " " && interviewMode && !isLocked) { e.preventDefault(); setRevealed((v) => !v); }
    };
    window.addEventListener("keydown", handler);
    return () => window.removeEventListener("keydown", handler);
  }, [onPrev, onNext, onBack, interviewMode]);

  const hasPrev = currentIndex > 0;
  const hasNext = currentIndex < totalCount - 1;
  const readTime = useMemo(() => estimateReadTime(answer), [answer]);

  // Guests can read questions 0–(GUEST_FREE_LIMIT-1) freely
  const isLocked = isGuest && currentIndex >= GUEST_FREE_LIMIT;

  function cycleStatus() {
    console.log("[cycleStatus] isGuest:", isGuest, "activeKey:", activeKey, "activeStatus:", activeStatus);
    if (isGuest) { onOpenAuth("signin"); return; }
    const idx = STATUS_CYCLE.indexOf(activeStatus);
    const next = STATUS_CYCLE[(idx + 1) % STATUS_CYCLE.length];
    console.log("[cycleStatus] saving:", activeKey, "→", next);
    onSaveStatus(activeKey, next);
  }

  const statusStyle = STATUS_STYLE[activeStatus] || STATUS_STYLE["To Do"];

  return (
    <div className="flex flex-col h-full overflow-hidden">

      {/* ── Question Header ─────────────────────────────── */}
      <div className="shrink-0 bg-panel border-b border-border px-5 py-4">

        {/* Top row: breadcrumb + badges + back */}
        <div className="flex items-center gap-2 mb-3 flex-wrap">
          <span className="text-[11px] text-ghost">{activeQ.topic_label}</span>
          <span className="text-[11px] text-ghost">›</span>
          <span className="text-[11px] text-muted">{activeQ.section_label}</span>

          <div className="flex items-center gap-2 ml-auto">
            <Badge level={activeQ.difficulty} />

            {/* Interview mode toggle */}
            <button
              className={`flex items-center gap-1 h-7 px-2.5 rounded-full text-xs font-medium transition-all cursor-pointer ${
                interviewMode
                  ? "bg-accent/15 border border-accent/50 text-accent"
                  : "border border-border text-ghost hover:text-muted hover:border-subtle"
              }`}
              onClick={() => setInterviewMode((v) => !v)}
              title="Toggle Interview Mode (I)"
            >
              🎯 Interview
            </button>

            {/* Status pill — disabled visually when locked */}
            <button
              className={`flex items-center gap-1.5 h-7 px-3 rounded-full text-xs font-medium transition-all duration-150 cursor-pointer ${
                isLocked
                  ? "border border-border text-ghost bg-transparent cursor-not-allowed"
                  : statusStyle.pill
              }`}
              onClick={cycleStatus}
              title={isLocked ? "Sign in to track progress" : "Click to change status"}
            >
              <span>{isLocked ? "🔒" : statusStyle.icon}</span>
              <span>{isLocked ? "Locked" : activeStatus}</span>
            </button>

            {/* Bookmark */}
            {!isLocked && (
              <button
                className={`w-7 h-7 flex items-center justify-center rounded-full transition-colors cursor-pointer ${
                  isBookmarked
                    ? "text-warning hover:text-warning/70"
                    : "text-ghost hover:text-warning"
                }`}
                onClick={() => onToggleBookmark?.(activeQ.id, {
                  text: activeQ.text,
                  section_label: activeQ.section_label,
                  topic_label: activeQ.topic_label,
                })}
                title={isBookmarked ? "Remove bookmark" : "Bookmark this question"}
              >
                {isBookmarked ? "★" : "☆"}
              </button>
            )}

            <button
              className="text-xs text-muted hover:text-primary transition-colors cursor-pointer ml-1"
              onClick={onBack}
              title="Back to list (Esc)"
            >
              ← back
            </button>
          </div>
        </div>

        {/* Question text */}
        <h1 className="text-lg font-semibold text-heading leading-relaxed mb-2">
          {activeQ.text}
        </h1>

        {/* Meta row + tabs */}
        <div className="flex items-center gap-3 text-[11px] text-muted flex-wrap">
          <span className="tabular-nums">Q{currentIndex + 1} of {totalCount}</span>
          {!isLocked && readTime && (
            <>
              <span className="text-ghost">·</span>
              <span>{readTime}</span>
            </>
          )}
          {isGuest && (
            <>
              <span className="text-ghost">·</span>
              <span className="text-accent">
                {Math.max(0, GUEST_FREE_LIMIT - currentIndex - 1)} free previews left
              </span>
            </>
          )}

          {/* Tab switcher */}
          {!isLocked && (
            <div className="ml-auto flex items-center gap-0.5 bg-hover rounded-lg p-0.5">
              <button
                className={`h-6 px-3 rounded-md text-[11px] font-medium transition-colors cursor-pointer ${
                  tab === "answer" ? "bg-panel text-primary shadow-sm" : "text-ghost hover:text-muted"
                }`}
                onClick={() => setTab("answer")}
              >
                Answer
              </button>
              <button
                className={`h-6 px-3 rounded-md text-[11px] font-medium transition-colors cursor-pointer ${
                  tab === "notes" ? "bg-panel text-primary shadow-sm" : "text-ghost hover:text-muted"
                }`}
                onClick={() => setTab("notes")}
              >
                Notes
              </button>
            </div>
          )}
        </div>
      </div>

      {/* ── Answer / Notes Panel ─────────────────────────── */}
      <div
        ref={answerRef}
        className="flex-1 overflow-y-auto bg-surface"
      >
        {isLocked ? (
          <div className="h-full px-6 py-8">
            <GuestGate
              onSignIn={() => onOpenAuth("signin")}
              onSignUp={() => onOpenAuth("signup")}
            />
          </div>
        ) : tab === "notes" ? (
          <NotesPanel user={user} questionId={activeQ?.id} isGuest={isGuest} onOpenAuth={onOpenAuth} />
        ) : (
          <div className="px-6 py-8">
            {error && (
              <div className="max-w-lg mx-auto bg-danger/10 border border-danger/30 rounded-lg p-4 text-danger text-sm">
                ⚠ {error}
              </div>
            )}

            {loading && (
              <div className="flex items-center justify-center pt-20">
                <Spinner />
              </div>
            )}

            {!loading && !answer && !error && (
              <div className="flex flex-col items-center justify-center h-full text-center">
                <div className="bg-panel border border-dashed border-border rounded-xl p-10 max-w-sm">
                  <div className="w-12 h-12 rounded-xl bg-hover flex items-center justify-center text-xl mb-4 mx-auto">🔧</div>
                  <p className="text-sm font-semibold text-soft mb-1">Answer coming soon</p>
                  <p className="text-xs text-muted leading-relaxed">
                    This question hasn&apos;t been answered yet. Check back soon!
                  </p>
                </div>
              </div>
            )}

            {!loading && answer && (
              <>
                {/* Interview mode — hide/reveal */}
                {interviewMode && !revealed ? (
                  <div className="flex flex-col items-center justify-center py-16 text-center">
                    <div
                      className="w-20 h-20 rounded-2xl flex items-center justify-center mb-6 text-3xl"
                      style={{ background: 'rgba(99,102,241,0.10)', border: '1px solid rgba(99,102,241,0.2)' }}
                    >
                      🎯
                    </div>
                    <h3 className="text-lg font-semibold text-heading mb-2">Interview Mode</h3>
                    <p className="text-sm text-muted max-w-sm leading-relaxed mb-8">
                      Think through your answer first, then reveal the solution.
                    </p>
                    <button
                      onClick={() => setRevealed(true)}
                      className="h-11 px-8 rounded-lg bg-accent hover:bg-accent-hover text-white font-semibold text-sm transition-all cursor-pointer"
                      style={{ boxShadow: '0 0 16px rgba(99,102,241,0.3)' }}
                    >
                      Reveal Answer
                    </button>
                    <p className="text-xs text-ghost mt-4">Press <kbd className="font-mono px-1 py-0.5 rounded bg-hover border border-border">Space</kbd> to reveal</p>
                  </div>
                ) : (
                  <>
                    {interviewMode && revealed && (
                      <div className="flex items-center justify-between mb-4 p-3 bg-success/5 border border-success/20 rounded-lg">
                        <span className="text-xs text-success font-medium">✓ Answer revealed</span>
                        <button
                          className="text-xs text-ghost hover:text-muted cursor-pointer"
                          onClick={() => setRevealed(false)}
                        >
                          Hide again
                        </button>
                      </div>
                    )}
                    <div
                      className="prose-answer"
                      dangerouslySetInnerHTML={{ __html: renderMarkdown(answer) }}
                    />
                  </>
                )}
              </>
            )}
          </div>
        )}
      </div>

      {/* ── Sticky Bottom Navigation ─────────────────────── */}
      <div className="shrink-0 bg-panel border-t border-border px-5 h-13 flex items-center gap-3">
        <button
          className={`flex items-center gap-1.5 text-sm transition-colors cursor-pointer ${
            hasPrev ? "text-muted hover:text-primary" : "text-ghost cursor-not-allowed"
          }`}
          onClick={onPrev}
          disabled={!hasPrev}
          title="Previous (← or P)"
        >
          <svg width="14" height="14" viewBox="0 0 14 14" fill="none">
            <path d="M9 11L5 7L9 3" stroke="currentColor" strokeWidth="1.5" strokeLinecap="round" strokeLinejoin="round"/>
          </svg>
          Prev
        </button>

        <div className="flex-1 flex items-center justify-center">
          <select
            className="h-8 px-2 rounded-md bg-hover border border-border text-xs text-primary cursor-pointer outline-none focus:border-accent max-w-52 tabular-nums"
            value={currentIndex}
            onChange={(e) => onJumpTo(e.target.value)}
          >
            {sectionQuestions.map((q, idx) => (
              <option key={q.id} value={idx}>
                {isGuest && idx >= GUEST_FREE_LIMIT ? "🔒 " : ""}Q{idx + 1}. {q.text.length > 45 ? q.text.slice(0, 45) + "…" : q.text}
              </option>
            ))}
          </select>
        </div>

        <button
          className={`flex items-center gap-1.5 text-sm transition-colors cursor-pointer ${
            hasNext ? "text-muted hover:text-primary" : "text-ghost cursor-not-allowed"
          }`}
          onClick={onNext}
          disabled={!hasNext}
          title="Next (→ or N)"
        >
          Next
          <svg width="14" height="14" viewBox="0 0 14 14" fill="none">
            <path d="M5 3L9 7L5 11" stroke="currentColor" strokeWidth="1.5" strokeLinecap="round" strokeLinejoin="round"/>
          </svg>
        </button>
      </div>

    </div>
  );
}
