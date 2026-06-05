import { totalQs, doneQs } from "../utils/helpers";

export default function Sidebar({
  topics,
  activeTopic,
  activeSection,
  expanded,
  statuses,
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
        const done = doneQs(topic, statuses);
        const total = totalQs(topic);
        const isExpanded = !!expanded[topic.id];
        const isActiveTopic = activeTopic?.id === topic.id;

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
                  background: topic.color,
                  flexShrink: 0,
                }}
              />
              <span style={{ flex: 1, fontSize: 13, fontWeight: 500, color: "#e2e8f0" }}>
                {topic.label}
              </span>
              <span style={{ fontSize: 11, color: "#475569" }}>
                {done}/{total}
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
              topic.sections.map((section) => {
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
                    <span style={{ marginLeft: "auto", fontSize: 11, color: "#475569" }}>
                      {section.qs.length}
                    </span>
                  </button>
                );
              })}
          </div>
        );
      })}
    </aside>
  );
}
