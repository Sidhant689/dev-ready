function ProgressRing({ pct, size = 20 }) {
  const r = (size - 4) / 2;
  const circ = 2 * Math.PI * r;
  const fill = (pct / 100) * circ;

  if (pct === 100) {
    return (
      <span className="w-5 h-5 rounded-full bg-success/20 text-success flex items-center justify-center text-[10px] font-bold shrink-0">
        ✓
      </span>
    );
  }

  return (
    <svg width={size} height={size} className="shrink-0 -rotate-90">
      <circle cx={size/2} cy={size/2} r={r} fill="none" stroke="#1e293b" strokeWidth="2" />
      <circle
        cx={size/2} cy={size/2} r={r}
        fill="none"
        stroke="#6366f1"
        strokeWidth="2"
        strokeDasharray={`${fill} ${circ}`}
        strokeLinecap="round"
        style={{ transition: 'stroke-dasharray 0.5s ease' }}
      />
    </svg>
  );
}

function Chevron({ open }) {
  return (
    <svg
      width="12" height="12" viewBox="0 0 12 12" fill="none"
      className="shrink-0 text-muted transition-transform duration-200"
      style={{ transform: open ? 'rotate(180deg)' : 'rotate(0deg)' }}
    >
      <path d="M2 4L6 8L10 4" stroke="currentColor" strokeWidth="1.5" strokeLinecap="round" strokeLinejoin="round"/>
    </svg>
  );
}

export default function Sidebar({
  topics,
  topicSections,
  activeTopic,
  activeSection,
  expanded,
  donePerTopic,
  streak,
  weekDone,
  weekGoal,
  bookmarks,
  onTopicClick,
  onSectionClick,
  onBookmarkClick,
  onHomeClick,
}) {
  return (
    <aside className="w-64 shrink-0 bg-panel border-r border-border flex flex-col overflow-hidden">

      {/* Home / Dashboard link */}
      <div className="px-3 pt-3 pb-1">
        <button
          onClick={onHomeClick}
          className="flex items-center gap-2 w-full px-3 py-2 rounded-lg text-xs font-medium text-muted hover:text-primary hover:bg-hover transition-colors cursor-pointer"
        >
          <svg width="13" height="13" viewBox="0 0 13 13" fill="none">
            <path d="M1 5.5L6.5 1L12 5.5V12H8.5V8.5H4.5V12H1V5.5Z" stroke="currentColor" strokeWidth="1.3" strokeLinejoin="round"/>
          </svg>
          Dashboard
        </button>
      </div>

      {/* Bookmarks — only if any */}
      {bookmarks?.length > 0 && (
        <div className="px-3 py-1">
          <div className="px-1 py-1.5">
            <span className="text-[10px] font-semibold tracking-widest uppercase text-ghost">Bookmarks</span>
          </div>
          <div className="space-y-0.5">
            {bookmarks.slice(0, 5).map((b) => (
              <button
                key={b.question_id}
                onClick={() => onBookmarkClick?.(b)}
                className="flex items-start gap-2 w-full px-2 py-1.5 rounded-md text-left hover:bg-hover transition-colors cursor-pointer group"
              >
                <span className="text-warning text-[10px] mt-0.5 shrink-0">★</span>
                <span className="text-xs text-muted group-hover:text-primary transition-colors truncate leading-relaxed">
                  {b.question_text}
                </span>
              </button>
            ))}
          </div>
          <div className="mt-1 mb-1 h-px bg-border" />
        </div>
      )}

      {/* Header label */}
      <div className="px-4 pt-2 pb-2">
        <span className="text-[10px] font-semibold tracking-widest uppercase text-ghost">Topics</span>
      </div>

      {/* Topic list — scrollable */}
      <div className="flex-1 overflow-y-auto">
        {topics.map((topic) => {
          const isExpanded = !!expanded[topic.id];
          const isActiveTopic = activeTopic?.id === topic.id;
          const sections = topicSections[topic.id] || [];
          const total = topic.total_count || 0;
          const done = donePerTopic?.[topic.id] || 0;
          const pct = total > 0 ? Math.round((done / total) * 100) : 0;

          return (
            <div key={topic.id}>
              {/* Topic row */}
              <div
                className={`flex items-center gap-2.5 px-4 py-2.5 cursor-pointer select-none transition-colors duration-150 ${
                  isActiveTopic ? 'bg-hover' : 'hover:bg-hover/60'
                }`}
                onClick={() => onTopicClick(topic)}
              >
                {/* Color dot */}
                <span
                  className="w-2 h-2 rounded-full shrink-0"
                  style={{ background: topic.color_hex || '#6366f1' }}
                />

                {/* Label */}
                <span className="flex-1 text-sm font-medium text-primary truncate leading-tight">
                  {topic.icon_emoji && <span className="mr-1.5">{topic.icon_emoji}</span>}
                  {topic.label}
                </span>

                {/* Progress ring */}
                <ProgressRing pct={pct} />

                {/* Chevron */}
                <Chevron open={isExpanded} />
              </div>

              {/* Progress bar — always visible */}
              {total > 0 && (
                <div className="mx-4 mb-1 h-0.5 bg-hover rounded-full overflow-hidden">
                  <div
                    className="h-full rounded-full transition-all duration-500"
                    style={{
                      width: `${pct}%`,
                      background: pct === 100 ? 'var(--color-success)' : 'var(--color-accent)',
                    }}
                  />
                </div>
              )}

              {/* Done count — only shown when collapsed */}
              {!isExpanded && total > 0 && (
                <div className="px-4 pb-2">
                  <span className="text-[11px] text-muted tabular-nums">{done}/{total} done</span>
                </div>
              )}

              {/* Section list */}
              {isExpanded && (
                <div className="pb-1">
                  {sections.map((section) => {
                    const isActiveSection = activeSection?.id === section.id && isActiveTopic;
                    return (
                      <button
                        key={section.id}
                        className={`flex items-center w-full pl-9 pr-4 py-1.5 text-left text-xs font-medium transition-all duration-150 border-l-2 cursor-pointer ${
                          isActiveSection
                            ? 'border-accent text-bright bg-accent/5'
                            : 'border-transparent text-muted hover:text-primary hover:bg-hover/40'
                        }`}
                        onClick={() => onSectionClick(topic, section)}
                      >
                        <span className="truncate">{section.label}</span>
                      </button>
                    );
                  })}
                </div>
              )}
            </div>
          );
        })}
      </div>

      {/* Sidebar footer — streak + weekly goal */}
      <div className="shrink-0 border-t border-border bg-panel/80 px-4 py-3 space-y-2.5">
        {/* Streak */}
        {streak > 0 && (
          <div className="flex items-center gap-2">
            <span className="text-base">🔥</span>
            <div>
              <p className="text-xs font-semibold text-soft">{streak}-day streak</p>
              <p className="text-[11px] text-muted">Keep it going!</p>
            </div>
          </div>
        )}

        {/* Weekly goal */}
        {weekGoal > 0 && (
          <div>
            <div className="flex items-center justify-between mb-1">
              <span className="text-[11px] font-semibold tracking-widest uppercase text-ghost">Weekly Goal</span>
              <span className="text-[11px] text-muted tabular-nums">{weekDone}/{weekGoal}</span>
            </div>
            <div className="h-1.5 bg-hover rounded-full overflow-hidden">
              <div
                className="h-full rounded-full transition-all duration-500"
                style={{
                  width: `${Math.min(100, Math.round((weekDone / weekGoal) * 100))}%`,
                  background: weekDone >= weekGoal ? 'var(--color-success)' : 'var(--color-accent)',
                }}
              />
            </div>
          </div>
        )}
      </div>

    </aside>
  );
}
