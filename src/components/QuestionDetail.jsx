import { useEffect, useRef } from "react";
import { STATUS_CFG } from "../constants";
import { renderMarkdown } from "../utils/markdown";
import Badge from "./ui/Badge";
import Spinner from "./ui/Spinner";

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
}) {
  const answerRef = useRef(null);

  // Scroll answer panel to top on question change
  useEffect(() => {
    if (answerRef.current) answerRef.current.scrollTop = 0;
  }, [activeQ?.id]);

  // Keyboard navigation
  useEffect(() => {
    const handler = (e) => {
      if (e.target.tagName === "INPUT" || e.target.tagName === "SELECT" || e.target.tagName === "TEXTAREA") return;
      if (e.key === "ArrowLeft"  || e.key === "p") onPrev();
      if (e.key === "ArrowRight" || e.key === "n") onNext();
      if (e.key === "Escape") onBack();
    };
    window.addEventListener("keydown", handler);
    return () => window.removeEventListener("keydown", handler);
  }, [onPrev, onNext, onBack]);

  const hasPrev = currentIndex > 0;
  const hasNext = currentIndex < totalCount - 1;

  return (
    <div className="flex flex-col h-full overflow-hidden">
      {/* Header */}
      <div className="shrink-0 bg-panel border-b border-border px-5 py-3 space-y-2">
        {/* Breadcrumb + back */}
        <div className="flex items-center gap-1.5 text-[11px] text-muted">
          <span>{activeQ.topic_label}</span>
          <span>›</span>
          <span>{activeQ.section_label}</span>
          <span>›</span>
          <span className="text-subtle">Q{activeQ.id}</span>
          <button
            className="ml-auto text-xs text-muted hover:text-primary transition-colors cursor-pointer"
            onClick={onBack}
            title="Back to list (Esc)"
          >
            ← back
          </button>
        </div>

        {/* Question text + badge */}
        <div className="flex items-start gap-2">
          <Badge level={activeQ.difficulty} />
        </div>
        <p className="text-[17px] font-semibold text-bright leading-relaxed">
          {activeQ.text}
        </p>
      </div>

      {/* Status + Navigation bar */}
      <div className="shrink-0 bg-panel border-b border-border px-5 py-2 flex items-center gap-3 flex-wrap">
        {/* Status buttons */}
        <span className="text-xs text-muted">Mark as:</span>
        <div className="flex rounded-lg overflow-hidden border border-border">
          {["To Do", "In Progress", "Done"].map((s, i) => (
            <button
              key={s}
              className={`h-8 px-3 text-xs flex items-center gap-1 transition-colors cursor-pointer ${
                i < 2 ? "border-r border-border" : ""
              } ${
                activeStatus === s
                  ? "bg-hover text-primary"
                  : "bg-transparent text-muted hover:bg-hover hover:text-primary"
              }`}
              style={{ color: activeStatus === s ? STATUS_CFG[s].color : undefined }}
              onClick={() => onSaveStatus(activeKey, s)}
            >
              {STATUS_CFG[s].icon} {s}
            </button>
          ))}
        </div>

        {/* Navigation — pushed to the right */}
        <div className="ml-auto flex items-center gap-2">
          <button
            className={`h-8 w-8 flex items-center justify-center rounded-lg border border-border text-sm transition-colors cursor-pointer ${
              hasPrev
                ? "text-primary hover:bg-hover"
                : "text-muted opacity-40 cursor-not-allowed"
            }`}
            onClick={onPrev}
            disabled={!hasPrev}
            title="Previous question (← or P)"
          >
            ←
          </button>

          {/* Jump to question */}
          <div className="flex items-center gap-1.5">
            <span className="text-xs text-muted tabular-nums">
              {currentIndex + 1} / {totalCount}
            </span>
            <select
              className="h-8 px-2 rounded-lg bg-hover border border-border text-xs text-primary cursor-pointer outline-none focus:border-accent max-w-35"
              value={currentIndex}
              onChange={(e) => onJumpTo(e.target.value)}
            >
              {sectionQuestions.map((q, idx) => (
                <option key={q.id} value={idx}>
                  Q{idx + 1}. {q.text.length > 40 ? q.text.slice(0, 40) + "…" : q.text}
                </option>
              ))}
            </select>
          </div>

          <button
            className={`h-8 w-8 flex items-center justify-center rounded-lg border border-border text-sm transition-colors cursor-pointer ${
              hasNext
                ? "text-primary hover:bg-hover"
                : "text-muted opacity-40 cursor-not-allowed"
            }`}
            onClick={onNext}
            disabled={!hasNext}
            title="Next question (→ or N)"
          >
            →
          </button>
        </div>
      </div>

      {/* Answer panel */}
      <div
        ref={answerRef}
        className="flex-1 overflow-y-auto px-6 py-5 bg-surface"
      >
        {error && (
          <div className="bg-red-950 border border-red-800 rounded-lg p-3 text-red-300 text-sm">
            ⚠ {error}
          </div>
        )}

        {loading && <Spinner />}

        {!loading && !answer && !error && (
          <div className="flex flex-col items-center justify-center h-full">
            <div className="bg-panel border border-dashed border-border rounded-xl p-8 text-center max-w-sm">
              <div className="text-3xl mb-3">🔧</div>
              <p className="text-sm font-medium text-soft mb-1">Answer coming soon</p>
              <p className="text-xs text-muted">
                This question hasn&apos;t been added to the database yet. Check back soon!
              </p>
            </div>
          </div>
        )}

        {!loading && answer && (
          <div
            className="text-sm leading-7 text-primary"
            dangerouslySetInnerHTML={{ __html: renderMarkdown(answer) }}
          />
        )}
      </div>
    </div>
  );
}
