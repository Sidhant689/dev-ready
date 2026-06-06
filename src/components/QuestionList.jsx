import { useState, useEffect, useMemo } from "react";
import { STATUS_CFG } from "../constants";
import { qKey } from "../utils/helpers";
import { fetchLevelsList } from "../services/questionService";
import Badge from "./ui/Badge";

export default function QuestionList({
  activeSection,
  questions,
  loading,
  statuses,
  cached,
  onOpenQuestion,
}) {
  const [search, setSearch] = useState("");
  const [lvlFilter, setLvlFilter] = useState("All");
  const [levels, setLevels] = useState(["All"]);

  useEffect(() => {
    fetchLevelsList()
      .then(setLevels)
      .catch(console.error);
  }, []);

  // Reset filters on section change
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

  return (
    <div className="flex flex-col h-full overflow-hidden">
      {/* Header */}
      <div className="shrink-0 bg-panel border-b border-border px-4 py-3 space-y-2">
        <div className="flex items-center justify-between">
          <h2 className="text-sm font-medium text-primary">
            {activeSection?.label || "Select a section"}
          </h2>
          {questions.length > 0 && (
            <span className="text-xs text-muted tabular-nums">
              {doneCount}/{questions.length} done
            </span>
          )}
        </div>

        <div className="flex gap-2">
          {/* Search */}
          <div className="relative flex-1">
            <span className="absolute left-2.5 top-1/2 -translate-y-1/2 text-muted text-xs pointer-events-none">
              🔍
            </span>
            <input
              className="w-full h-8 pl-7 pr-3 rounded-lg bg-hover border border-border text-primary text-xs outline-none focus:border-accent transition-colors"
              placeholder="Search questions…"
              value={search}
              onChange={(e) => setSearch(e.target.value)}
            />
          </div>

          {/* Level filter */}
          <select
            className="h-8 px-2 rounded-lg bg-hover border border-border text-primary text-xs cursor-pointer outline-none focus:border-accent"
            value={lvlFilter}
            onChange={(e) => setLvlFilter(e.target.value)}
          >
            {levels.map((l) => (
              <option key={l} value={l}>{l}</option>
            ))}
          </select>
        </div>
      </div>

      {/* Question cards */}
      <div className="flex-1 overflow-y-auto p-2">
        {loading ? (
          <p className="text-center text-xs text-muted py-12">Loading questions…</p>
        ) : filteredQs.length === 0 ? (
          <p className="text-center text-xs text-muted py-12">
            {questions.length === 0 ? "No questions in this section." : "No questions match your filter."}
          </p>
        ) : (
          filteredQs.map((q) => {
            const k = qKey(q.id);
            const st = statuses[k] || "To Do";
            return (
              <div
                key={q.id}
                className="flex items-start gap-2.5 px-3 py-2.5 rounded-lg cursor-pointer border border-transparent hover:bg-hover hover:border-border transition-all duration-100 mb-1 group"
                onClick={() => onOpenQuestion(activeSection, q)}
              >
                <span
                  className="text-xs shrink-0 mt-0.5"
                  style={{ color: STATUS_CFG[st].color }}
                  title={st}
                >
                  {STATUS_CFG[st].icon}
                </span>
                <span className="text-[11px] text-muted shrink-0 mt-0.5 tabular-nums w-5">
                  {q.serial_number}.
                </span>
                <span className="text-[13px] text-primary leading-relaxed flex-1">
                  {q.text}
                  {cached[k] && (
                    <span className="ml-1.5 text-[11px] text-green-400" title="Cached locally">⚡</span>
                  )}
                </span>
                <Badge
                  level={q.difficulty_levels?.label}
                  bgColor={q.difficulty_levels?.bg_color}
                  textColor={q.difficulty_levels?.text_color}
                />
              </div>
            );
          })
        )}
      </div>
    </div>
  );
}
