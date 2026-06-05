export default function Sidebar({
  topics,
  topicSections,
  activeTopic,
  activeSection,
  expanded,
  onTopicClick,
  onSectionClick,
}) {
  return (
    <aside
      style={{
        width: 224,
        flexShrink: 0,
        background: "#0f1117",
        borderRight: "1px solid #1e293b",
        overflowY: "auto",
        display: "flex",
        flexDirection: "column",
      }}
    >
      {topics.map((topic) => {
        const isExpanded = !!expanded[topic.id];
        const isActiveTopic = activeTopic?.id === topic.id;
        const sections = topicSections[topic.id] || [];
        const total = topic.total_count || 0;

        return (
          <div key={topic.id}>
            {/* Topic row */}
            <div
              className="t-row"
              style={{
                display: "flex",
                alignItems: "center",
                gap: 8,
                padding: "8px 12px",
                cursor: "pointer",
                background: isActiveTopic ? "#1e293b" : "transparent",
                userSelect: "none",
              }}
              onClick={() => onTopicClick(topic)}
            >
              <span
                style={{
                  width: 8,
                  height: 8,
                  borderRadius: "50%",
                  background: topic.color_hex,
                  flexShrink: 0,
                }}
              />
              <span style={{ flex: 1, fontSize: 13, fontWeight: 500, color: "#e2e8f0" }}>
                {topic.label}
              </span>
              <span style={{ fontSize: 11, color: "#475569" }}>
                0/{total}
              </span>
              <span
                style={{
                  fontSize: 10,
                  color: "#475569",
                  transform: isExpanded ? "rotate(180deg)" : "none",
                  transition: "transform .2s",
                }}
              >
                ▼
              </span>
            </div>

            {/* Section buttons */}
            {isExpanded &&
              sections.map((section) => {
                const isActiveSection =
                  activeSection?.id === section.id && isActiveTopic;
                return (
                  <button
                    key={section.id}
                    className="s-btn"
                    style={{
                      display: "flex",
                      alignItems: "center",
                      gap: 6,
                      width: "100%",
                      padding: "5px 12px 5px 32px",
                      cursor: "pointer",
                      border: "none",
                      background: "transparent",
                      color: isActiveSection ? "#e2e8f0" : "#64748b",
                      fontSize: 12,
                      textAlign: "left",
                      borderLeft: isActiveSection
                        ? "2px solid #6366f1"
                        : "2px solid transparent",
                      transition: "all .15s",
                    }}
                    onClick={() => onSectionClick(topic, section)}
                  >
                    <span style={{ flex: 1, textAlign: "left" }}>{section.label}</span>
                  </button>
                );
              })}
          </div>
        );
      })}
    </aside>
  );
}
