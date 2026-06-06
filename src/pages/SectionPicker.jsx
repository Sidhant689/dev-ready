import { useEffect, useState } from "react";
import { fetchSections } from "../services/questionService";

export default function SectionPicker({ topic, statuses, questionMeta, onSelectSection }) {
  const [sections, setSections] = useState([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    if (!topic) return;
    setLoading(true);
    fetchSections(topic.id)
      .then((data) => { setSections(data); setLoading(false); })
      .catch(() => setLoading(false));
  }, [topic?.id]);

  // Per-section done count from statuses + questionMeta
  function donForSection(sectionId) {
    return Object.entries(statuses).filter(([key, status]) => {
      if (status !== "Done") return false;
      const qId = parseInt(key.replace("q_", ""), 10);
      return questionMeta[`s_${qId}`] === sectionId;
    }).length;
  }

  if (!topic) return null;

  return (
    <div className="flex-1 overflow-y-auto p-6">
      {/* Header */}
      <div className="mb-6">
        <div className="flex items-center gap-2 mb-1">
          {topic.icon_emoji && <span className="text-2xl">{topic.icon_emoji}</span>}
          <h1 className="text-2xl font-bold text-heading">{topic.label}</h1>
        </div>
        <p className="text-sm text-muted">
          {topic.total_count || 0} questions · Pick a section to start practicing
        </p>
      </div>

      {/* Sections grid */}
      {loading ? (
        <div className="grid grid-cols-2 md:grid-cols-3 gap-3">
          {[1, 2, 3, 4, 5, 6].map((i) => (
            <div key={i} className="h-24 rounded-xl bg-panel border border-border animate-pulse" />
          ))}
        </div>
      ) : sections.length === 0 ? (
        <div className="flex flex-col items-center justify-center py-20 text-center">
          <div className="w-12 h-12 rounded-xl bg-hover flex items-center justify-center text-xl mb-3">📂</div>
          <p className="text-sm text-soft font-medium">No sections yet</p>
          <p className="text-xs text-muted mt-1">Sections will appear here once added.</p>
        </div>
      ) : (
        <div className="grid grid-cols-2 md:grid-cols-3 gap-3">
          {sections.map((section, i) => (
            <button
              key={section.id}
              onClick={() => onSelectSection(section)}
              className="group text-left bg-panel border border-border rounded-xl p-4 hover:border-accent/40 hover:bg-hover transition-all duration-150 cursor-pointer"
            >
              {/* Section number */}
              <span className="text-[11px] font-semibold text-ghost tabular-nums mb-2 block">
                {String(i + 1).padStart(2, "0")}
              </span>

              {/* Section name */}
              <p className="text-sm font-semibold text-primary group-hover:text-bright transition-colors leading-snug">
                {section.label}
              </p>

              {/* Arrow indicator */}
              <div className="flex items-center justify-end mt-3">
                <span className="text-ghost group-hover:text-accent text-xs transition-colors group-hover:translate-x-0.5 inline-block transition-transform">
                  Start →
                </span>
              </div>
            </button>
          ))}
        </div>
      )}
    </div>
  );
}
