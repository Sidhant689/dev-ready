import { useState, useEffect, useMemo } from "react";
import { STATUS_CFG } from "../constants";
import { qKey } from "../utils/helpers";
import { fetchLevelsList } from "../services/questionService";
import Badge from "./ui/Badge";
import { GUEST_FREE_LIMIT } from "./QuestionDetail";

function StatusDot({ status }) {
  const cfg = {
    "To Do":       { bg: "transparent", border: "#475569", fill: false },
    "In Progress": { bg: "#f59e0b33",   border: "#f59e0b", fill: false, half: true },
    "Done":        { bg: "#10b98133",   border: "#10b981", fill: true },
  }[status] || { bg: "transparent", border: "#475569" };

  return (
    <span
      className="w-3.5 h-3.5 rounded-full shrink-0 mt-0.5 flex items-center justify-center"
      style={{ background: cfg.bg, border: `1.5px solid ${cfg.border}` }}
      title={status}
    >
      {cfg.fill && (
        <span style={{ color: '#10b981', fontSize: '8px', lineHeight: 1 }}>✓</span>
      )}
      {cfg.half && (
        <span style={{ color: '#f59e0b', fontSize: '8px', lineHeight: 1 }}>◐</span>
      )}
    </span>
  );
}

export default function QuestionList({
  activeSection,
  activeTopic,
  questions,
  loading,
  statuses,
  cached,
  onOpenQuestion,
  onBack,
  isGuest,
  onOpenAuth,
}) {
  const [search, setSearch] = useState("");
  const [lvlFilter, setLvlFilter] = useState("All");
  const [levels, setLevels] = useState(["All"]);

  useEffect(() => {
    fetchLevelsList().then(setLevels).catch(console.error);
  }, []);

  useEffect(() => {
    setSearch("");
    setLvlFilter("All");
  }, [activeSection?.id]);

  const filteredQs = useMemo(() => {
    return questions.filter((q) => {
      const matchSearch = !search || q.text.toLowerCase().includes(search.toLowerCase());
      const matchLevel = lvlFilter === "All" || q.difficulty_levels?.label === lvlFilter;
      return matchSearch && matchLevel;
    });
  }, [questions, search, lvlFilter]);

  const doneCount = useMemo(
    () => questions.filter((q) => statuses[qKey(q.id)] === "Done").length,
    [questions, statuses]
  );

  const sectionPct = questions.length > 0 ? Math.round((doneCount / questions.length) * 100) : 0;

  if (!activeSection) {
    return (
      <div className="flex flex-col items-center justify-center h-full text-center px-8">
        <div className="w-14 h-14 rounded-2xl bg-accent/10 border border-accent/20 flex items-center justify-center mb-4 text-2xl">
          👈
        </div>
        <p className="text-base font-semibold text-soft mb-1">Select a topic to begin</p>
        <p className="text-sm text-muted max-w-xs">
          Choose any topic from the sidebar to see questions and start your preparation.
        </p>
      </div>
    );
  }

  return (
    <div className="flex flex-col h-full overflow-hidden">
      {/* Header */}
      <div className="shrink-0 bg-panel border-b border-border px-4 py-3 space-y-2.5">
        <div className="flex items-center justify-between gap-3">
          <div className="flex items-center gap-2 min-w-0">
            {onBack && (
              <button
                onClick={onBack}
                className="text-ghost hover:text-muted transition-colors cursor-pointer text-xs shrink-0"
                title="Back to sections"
              >
                ←
              </button>
            )}
            {activeTopic && (
              <>
                <span className="text-xs text-ghost truncate hidden sm:block">{activeTopic.label}</span>
                <span className="text-xs text-ghost hidden sm:block">›</span>
              </>
            )}
            <h2 className="text-sm font-semibold text-bright truncate">
              {activeSection.label}
            </h2>
          </div>
          {questions.length > 0 && (
            <span className="text-xs text-muted tabular-nums whitespace-nowrap shrink-0">
              {doneCount}/{questions.length} done
            </span>
          )}
        </div>

        {/* Section progress bar */}
        {questions.length > 0 && (
          <div className="h-1 bg-hover rounded-full overflow-hidden">
            <div
              className="h-full rounded-full transition-all duration-500"
              style={{
                width: `${sectionPct}%`,
                background: sectionPct === 100 ? 'var(--color-success)' : 'var(--color-accent)',
              }}
            />
          </div>
        )}

        {/* Filters */}
        <div className="flex gap-2">
          <div className="relative flex-1">
            <svg className="absolute left-2.5 top-1/2 -translate-y-1/2 text-muted pointer-events-none w-3.5 h-3.5" viewBox="0 0 16 16" fill="none">
              <circle cx="7" cy="7" r="5" stroke="currentColor" strokeWidth="1.5"/>
              <path d="M11 11l3 3" stroke="currentColor" strokeWidth="1.5" strokeLinecap="round"/>
            </svg>
            <input
              className="w-full h-8 pl-8 pr-3 rounded-md bg-hover border border-border text-primary text-xs outline-none focus:border-accent transition-colors placeholder:text-muted"
              placeholder="Search questions…"
              value={search}
              onChange={(e) => setSearch(e.target.value)}
            />
          </div>
          <select
            className="h-8 px-2 rounded-md bg-hover border border-border text-primary text-xs cursor-pointer outline-none focus:border-accent min-w-20"
            value={lvlFilter}
            onChange={(e) => setLvlFilter(e.target.value)}
          >
            {levels.map((l) => (
              <option key={l} value={l}>{l}</option>
            ))}
          </select>
        </div>
      </div>

      {/* Question list */}
      <div className="flex-1 overflow-y-auto p-2">
        {loading ? (
          <div className="flex items-center justify-center py-16">
            <div className="w-5 h-5 rounded-full border-2 border-border border-t-accent animate-spin" />
          </div>
        ) : filteredQs.length === 0 ? (
          <div className="flex flex-col items-center justify-center py-16 text-center px-4">
            {questions.length === 0 ? (
              <>
                <p className="text-sm text-soft font-medium mb-1">No questions yet</p>
                <p className="text-xs text-muted">This section doesn't have questions yet. Check back soon.</p>
              </>
            ) : doneCount === questions.length ? (
              <>
                <div className="w-12 h-12 rounded-2xl bg-success/10 border border-success/20 flex items-center justify-center mb-3 text-xl">✓</div>
                <p className="text-sm font-semibold text-soft mb-1">Section Complete</p>
                <p className="text-xs text-muted">You've answered all questions in this section.</p>
              </>
            ) : (
              <>
                <p className="text-sm text-soft font-medium mb-1">No matches</p>
                <p className="text-xs text-muted">Try a different search term or filter.</p>
              </>
            )}
          </div>
        ) : (
          filteredQs.map((q, listIdx) => {
            const k = qKey(q.id);
            const st = statuses[k] || "To Do";
            // Use the question's original index in the full questions array for locking
            const originalIdx = questions.findIndex((orig) => orig.id === q.id);
            const locked = isGuest && originalIdx >= GUEST_FREE_LIMIT;

            function handleClick() {
              if (locked) {
                onOpenAuth?.("signup");
                return;
              }
              onOpenQuestion(activeSection, q);
            }

            return (
              <div
                key={q.id}
                className={`flex items-start gap-3 px-3 py-3 rounded-lg border border-transparent transition-all duration-100 mb-0.5 group ${
                  locked
                    ? "cursor-pointer hover:bg-hover/40 hover:border-border/50 opacity-60"
                    : "cursor-pointer hover:bg-hover hover:border-border"
                }`}
                onClick={handleClick}
              >
                {/* Status dot or lock icon */}
                {locked ? (
                  <span className="text-ghost text-xs shrink-0 mt-0.5">🔒</span>
                ) : (
                  <StatusDot status={st} />
                )}

                {/* Serial number */}
                <span className="text-[11px] text-ghost shrink-0 mt-0.5 tabular-nums w-5 text-right">
                  {q.serial_number}.
                </span>

                {/* Question text */}
                <span className={`text-sm leading-relaxed flex-1 min-w-0 ${locked ? "text-muted" : "text-primary"}`}>
                  {q.text}
                </span>

                {/* Right column: badge + cached */}
                <div className="flex flex-col items-end gap-1 shrink-0">
                  {locked ? (
                    <span className="text-[10px] text-muted border border-border rounded-full px-2 py-0.5">
                      Sign in
                    </span>
                  ) : (
                    <>
                      <Badge
                        level={q.difficulty_levels?.label}
                        bgColor={q.difficulty_levels?.bg_color}
                        textColor={q.difficulty_levels?.text_color}
                      />
                      {cached[k] && (
                        <span className="text-[10px] text-success/60" title="Cached locally">⚡</span>
                      )}
                    </>
                  )}
                </div>
              </div>
            );
          })
        )}
        {/* Guest upsell banner */}
        {isGuest && questions.length > GUEST_FREE_LIMIT && (
          <div
            className="mx-2 mt-3 mb-1 rounded-xl border border-accent/25 px-4 py-3 text-center"
            style={{ background: 'rgba(99,102,241,0.07)' }}
          >
            <p className="text-xs font-semibold text-soft mb-1">
              🔒 {questions.length - GUEST_FREE_LIMIT} questions locked
            </p>
            <p className="text-[11px] text-muted mb-2.5">
              Create a free account to access all questions and save your progress.
            </p>
            <button
              onClick={() => onOpenAuth?.("signup")}
              className="h-8 px-4 rounded-lg bg-accent hover:bg-accent-hover text-white text-xs font-semibold transition-colors cursor-pointer"
            >
              Unlock All Questions →
            </button>
          </div>
        )}
      </div>
    </div>
  );
}
