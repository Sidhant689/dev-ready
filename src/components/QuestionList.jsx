import { useState, useMemo } from "react";
import { STATUS_CFG, LEVELS } from "../constants";
import { qKey } from "../utils/helpers";
import Badge from "./ui/Badge";

export default function QuestionList({
  activeTopic,
  activeSection,
  statuses,
  cached,
  onOpenQuestion,
}) {
  const [search, setSearch] = useState("");
  const [lvlFilter, setLvlFilter] = useState("All");

  const filteredQs = useMemo(() => {
    if (!activeSection) return [];
    return activeSection.qs.filter((q) => {
      const matchSearch = !search || q[1].toLowerCase().includes(search.toLowerCase());
      const matchLevel = lvlFilter === "All" || q[2] === lvlFilter;
      return matchSearch && matchLevel;
    });
  }, [activeSection, search, lvlFilter]);

  const handleSectionChange = () => {
    setSearch("");
    setLvlFilter("All");
  };

  // Reset filters when section changes
  useMemo(() => { handleSectionChange(); }, [activeSection?.id]); // eslint-disable-line react-hooks/exhaustive-deps

  return (
    <div style={{ display: "flex", flexDirection: "column", height: "100%", overflow: "hidden" }}>
      {/* List header */}
      <div
        style={{
          padding: "12px 16px",
          borderBottom: "1px solid #1e293b",
          background: "#0f1117",
          flexShrink: 0,
        }}
      >
        <div style={{ fontSize: 14, fontWeight: 500, color: "#e2e8f0", marginBottom: 10 }}>
          {activeSection?.label || "Select a section"}
        </div>

        <div style={{ display: "flex", gap: 8 }}>
          {/* Search */}
          <div style={{ flex: 1, position: "relative" }}>
            <span
              style={{
                position: "absolute",
                left: 10,
                top: "50%",
                transform: "translateY(-50%)",
                fontSize: 13,
                color: "#475569",
              }}
            >
              🔍
            </span>
            <input
              style={{
                width: "100%",
                height: 32,
                padding: "0 10px 0 30px",
                border: "1px solid #1e293b",
                borderRadius: 8,
                background: "#1e293b",
                color: "#e2e8f0",
                fontSize: 13,
                outline: "none",
                boxSizing: "border-box",
              }}
              placeholder="Search questions…"
              value={search}
              onChange={(e) => setSearch(e.target.value)}
            />
          </div>

          {/* Level filter */}
          <select
            style={{
              height: 32,
              padding: "0 6px",
              border: "1px solid #1e293b",
              borderRadius: 8,
              background: "#1e293b",
              color: "#e2e8f0",
              fontSize: 12,
              cursor: "pointer",
            }}
            value={lvlFilter}
            onChange={(e) => setLvlFilter(e.target.value)}
          >
            {LEVELS.map((l) => (
              <option key={l}>{l}</option>
            ))}
          </select>
        </div>
      </div>

      {/* Question cards */}
      <div style={{ flex: 1, overflowY: "auto", padding: 8 }}>
        {filteredQs.length === 0 && (
          <p style={{ color: "#475569", fontSize: 13, textAlign: "center", padding: 24 }}>
            No questions match your filter.
          </p>
        )}
        {filteredQs.map((q) => {
          const k = qKey(activeTopic.id, activeSection.id, q[0]);
          const st = statuses[k] || "To Do";
          return (
            <div
              key={q[0]}
              className="q-card"
              style={{
                display: "flex",
                alignItems: "flex-start",
                gap: 10,
                padding: "10px 12px",
                borderRadius: 8,
                cursor: "pointer",
                border: "1px solid transparent",
                background: "transparent",
                transition: "all .1s",
                marginBottom: 4,
              }}
              onClick={() => onOpenQuestion(activeTopic, activeSection, q)}
            >
              <span
                style={{
                  color: STATUS_CFG[st].color,
                  fontSize: 12,
                  flexShrink: 0,
                  marginTop: 2,
                }}
              >
                {STATUS_CFG[st].icon}
              </span>
              <span style={{ fontSize: 11, color: "#475569", flexShrink: 0, marginTop: 3, minWidth: 20 }}>
                {q[0]}.
              </span>
              <span style={{ fontSize: 13, color: "#e2e8f0", lineHeight: 1.5, flex: 1 }}>
                {q[1]}
                {cached[k] && (
                  <span style={{ marginLeft: 5, fontSize: 11, color: "#22c55e" }} title="Cached locally">
                    ⚡
                  </span>
                )}
              </span>
              <Badge level={q[2]} />
            </div>
          );
        })}
      </div>
    </div>
  );
}
