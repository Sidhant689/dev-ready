export default function Sidebar({
  topics,
  topicSections,
  activeTopic,
  activeSection,
  expanded,
  donePerTopic,
  onTopicClick,
  onSectionClick,
}) {
  return (
    <aside className="w-56 shrink-0 bg-panel border-r border-border overflow-y-auto flex flex-col">
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
              className={`flex items-center gap-2 px-3 py-2 cursor-pointer select-none transition-colors duration-150 ${
                isActiveTopic ? "bg-hover" : "hover:bg-hover"
              }`}
              onClick={() => onTopicClick(topic)}
            >
              <span
                className="w-2 h-2 rounded-full shrink-0"
                style={{ background: topic.color_hex }}
              />
              <span className="flex-1 text-[13px] font-medium text-primary truncate">
                {topic.icon_emoji && <span className="mr-1">{topic.icon_emoji}</span>}
                {topic.label}
              </span>
              <span className="text-[11px] text-muted tabular-nums">
                {done}/{total}
              </span>
              <span
                className="text-[10px] text-muted transition-transform duration-200"
                style={{ transform: isExpanded ? "rotate(180deg)" : "none" }}
              >
                ▼
              </span>
            </div>

            {/* Mini progress bar per topic */}
            {isExpanded && total > 0 && (
              <div className="mx-3 mb-1 h-0.5 bg-hover rounded-full overflow-hidden">
                <div
                  className="h-full bg-accent rounded-full transition-all duration-500"
                  style={{ width: `${pct}%` }}
                />
              </div>
            )}

            {/* Section list */}
            {isExpanded &&
              sections.map((section) => {
                const isActiveSection = activeSection?.id === section.id && isActiveTopic;
                return (
                  <button
                    key={section.id}
                    className={`flex items-center w-full pl-8 pr-3 py-1.5 text-left text-[12px] transition-all duration-150 border-l-2 cursor-pointer ${
                      isActiveSection
                        ? "border-accent text-primary bg-hover/50"
                        : "border-transparent text-subtle hover:text-primary hover:bg-hover/30"
                    }`}
                    onClick={() => onSectionClick(topic, section)}
                  >
                    <span className="flex-1 truncate">{section.label}</span>
                  </button>
                );
              })}
          </div>
        );
      })}
    </aside>
  );
}
