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
  onBack,
  onSaveStatus,
}) {
  const answerRef = useRef(null);

  // Scroll to top whenever the question changes
  useEffect(() => {
    if (answerRef.current) answerRef.current.scrollTop = 0;
  }, [activeQ]);

  return (
    <div style={{ display: "flex", flexDirection: "column", height: "100%", overflow: "hidden" }}>
      {/* Header: breadcrumb + question */}
      <div
        style={{
          padding: "14px 20px",
          borderBottom: "1px solid #1e293b",
          background: "#0f1117",
          flexShrink: 0,
        }}
      >
        <div
          style={{
            display: "flex",
            alignItems: "center",
            gap: 6,
            fontSize: 11,
            color: "#475569",
            marginBottom: 10,
          }}
        >
          <span>{activeQ.topic_label}</span>
          <span>›</span>
          <span>{activeQ.section_label}</span>
          <span>›</span>
          <span>Q{activeQ.id}</span>
          <button
            style={{
              marginLeft: "auto",
              background: "none",
              border: "none",
              color: "#64748b",
              cursor: "pointer",
              fontSize: 12,
              padding: "2px 6px",
              fontFamily: "inherit",
            }}
            onClick={onBack}
          >
            ← back
          </button>
        </div>

        <div style={{ display: "flex", alignItems: "center", gap: 8, marginBottom: 8 }}>
          <Badge level={activeQ.difficulty} />
        </div>

        <div style={{ fontSize: 17, fontWeight: 600, color: "#f1f5f9", lineHeight: 1.5 }}>
          {activeQ.text}
        </div>
      </div>

      {/* Status bar */}
      <div
        style={{
          display: "flex",
          alignItems: "center",
          gap: 8,
          padding: "10px 20px",
          borderBottom: "1px solid #1e293b",
          background: "#0f1117",
          flexShrink: 0,
          flexWrap: "wrap",
        }}
      >
        <span style={{ fontSize: 12, color: "#475569" }}>Mark as:</span>
        <div
          style={{
            display: "flex",
            border: "1px solid #1e293b",
            borderRadius: 8,
            overflow: "hidden",
            marginLeft: "auto",
          }}
        >
          {["To Do", "In Progress", "Done"].map((s, i) => (
            <button
              key={s}
              className="st-btn"
              style={{
                height: 32,
                padding: "0 10px",
                border: "none",
                background: activeStatus === s ? "#1e293b" : "transparent",
                color: activeStatus === s ? STATUS_CFG[s].color : "#475569",
                fontSize: 12,
                cursor: "pointer",
                fontFamily: "inherit",
                display: "flex",
                alignItems: "center",
                gap: 4,
                borderRight: i < 2 ? "1px solid #1e293b" : "none",
              }}
              onClick={() => onSaveStatus(activeKey, s)}
            >
              {STATUS_CFG[s].icon} {s}
            </button>
          ))}
        </div>
      </div>

      {/* Answer panel */}
      <div
        ref={answerRef}
        style={{ flex: 1, overflowY: "auto", padding: "20px 24px", background: "#0a0c10" }}
      >
        {error && (
          <div
            style={{
              background: "#1f1315",
              border: "1px solid #7f1d1d",
              borderRadius: 8,
              padding: 12,
              color: "#fca5a5",
              fontSize: 13,
            }}
          >
            ⚠ {error}
          </div>
        )}

        {loading && <Spinner />}

        {!loading && !answer && !error && (
          <div
            style={{
              display: "flex",
              flexDirection: "column",
              alignItems: "center",
              justifyContent: "center",
              height: "100%",
            }}
          >
            <div
              style={{
                background: "#0f1117",
                border: "1px dashed #334155",
                borderRadius: 12,
                padding: 32,
                textAlign: "center",
              }}
            >
              <div style={{ fontSize: 28, marginBottom: 12 }}>🔧</div>
              <div style={{ fontSize: 15, fontWeight: 500, color: "#94a3b8", marginBottom: 6 }}>
                Answer coming soon
              </div>
              <div style={{ fontSize: 13, color: "#475569" }}>
                This question hasn&apos;t been added to the database yet. Check back soon!
              </div>
            </div>
          </div>
        )}

        {!loading && answer && (
          <div
            style={{ fontSize: 14, lineHeight: 1.75 }}
            dangerouslySetInnerHTML={{ __html: renderMarkdown(answer) }}
          />
        )}
      </div>
    </div>
  );
}
