import { Flame } from "lucide-react";
import TopicIcon from "./TopicIcon";

function ProgressRing({ pct, size = 18 }) {
  const r = (size - 3) / 2;
  const circ = 2 * Math.PI * r;
  const fill = (pct / 100) * circ;

  if (pct === 100) {
    return (
      <span className="w-4 h-4 rounded-full bg-success/20 text-success flex items-center justify-center text-[9px] font-bold shrink-0">
        ✓
      </span>
    );
  }

  return (
    <svg width={size} height={size} className="shrink-0 -rotate-90">
      <circle cx={size / 2} cy={size / 2} r={r} fill="none" stroke="var(--color-hover)" strokeWidth="2" />
      <circle
        cx={size / 2} cy={size / 2} r={r}
        fill="none"
        stroke={pct > 0 ? "var(--color-accent)" : "transparent"}
        strokeWidth="2"
        strokeDasharray={`${fill} ${circ}`}
        strokeLinecap="round"
        style={{ transition: "stroke-dasharray 0.4s ease" }}
      />
    </svg>
  );
}

export default function Sidebar({
  topics,
  activeTopic,
  donePerTopic,
  streak,
  weekDone,
  weekGoal,
  bookmarks,
  onTopicClick,
  onHomeClick,
  onBookmarkClick,
}) {
  return (
    <aside className="w-56 shrink-0 bg-panel border-r border-border flex flex-col overflow-hidden select-none">

      {/* Home / Dashboard */}
      <div className="px-2 pt-3 pb-2">
        <button
          onClick={onHomeClick}
          className={`flex items-center gap-2.5 w-full px-3 py-2 rounded-lg text-left transition-all duration-150 cursor-pointer group ${
            !activeTopic
              ? "bg-accent/10 border border-accent/20 text-accent"
              : "hover:bg-hover text-muted border border-transparent hover:text-primary"
          }`}
        >
          <svg width="13" height="13" viewBox="0 0 13 13" fill="none" className="shrink-0">
            <path d="M1 5.5L6.5 1L12 5.5V12H8.5V8.5H4.5V12H1V5.5Z" stroke="currentColor" strokeWidth="1.3" strokeLinejoin="round"/>
          </svg>
          <span className="text-xs font-medium">Dashboard</span>
        </button>
      </div>

      <div className="mx-4 h-px bg-border mb-2" />

      {/* Topics label */}
      <div className="px-4 pb-1.5">
        <span className="text-[10px] font-semibold tracking-widest uppercase text-ghost">Topics</span>
      </div>

      {/* Flat topic list */}
      <div className="flex-1 overflow-y-auto px-2 pb-2">
        {topics.map((topic) => {
          const total = topic.total_count || 0;
          const done = donePerTopic?.[topic.id] || 0;
          const pct = total > 0 ? Math.round((done / total) * 100) : 0;
          const isActive = activeTopic?.id === topic.id;

          return (
            <button
              key={topic.id}
              onClick={() => onTopicClick(topic)}
              className={`flex items-center gap-2.5 w-full px-3 py-2 rounded-lg text-left transition-all duration-150 cursor-pointer group mb-0.5 ${
                isActive
                  ? "bg-accent/10 border border-accent/20 text-bright"
                  : "hover:bg-hover text-muted border border-transparent hover:text-primary"
              }`}
            >
              {/* Topic icon */}
              <span
                className={`shrink-0 transition-colors ${isActive ? "text-accent" : "text-muted group-hover:text-primary"}`}
              >
                <TopicIcon topic={topic} size={14} />
              </span>

              {/* Label */}
              <span className={`flex-1 text-xs font-medium truncate leading-snug ${isActive ? "text-bright" : ""}`}>
                {topic.label}
              </span>

              {/* Progress ring */}
              <ProgressRing pct={pct} />
            </button>
          );
        })}
      </div>

      {/* Footer — streak + weekly goal */}
      <div className="shrink-0 border-t border-border bg-panel/80 px-4 py-3 space-y-2.5">
        {streak > 0 && (
          <div className="flex items-center gap-2">
            <span className="w-7 h-7 rounded-lg bg-warning/10 border border-warning/20 flex items-center justify-center shrink-0 text-warning">
              <Flame size={14} strokeWidth={1.6} />
            </span>
            <div>
              <p className="text-xs font-semibold text-soft">{streak}-day streak</p>
              <p className="text-[10px] text-muted">Keep it going!</p>
            </div>
          </div>
        )}
        {weekGoal > 0 && (
          <div>
            <div className="flex items-center justify-between mb-1">
              <span className="text-[10px] font-semibold tracking-widest uppercase text-ghost">Week</span>
              <span className="text-[10px] text-muted tabular-nums">{weekDone}/{weekGoal}</span>
            </div>
            <div className="h-1 bg-hover rounded-full overflow-hidden">
              <div
                className="h-full rounded-full transition-all duration-500"
                style={{
                  width: `${Math.min(100, Math.round((weekDone / weekGoal) * 100))}%`,
                  background: weekDone >= weekGoal ? "var(--color-success)" : "var(--color-accent)",
                }}
              />
            </div>
          </div>
        )}
      </div>
    </aside>
  );
}
