import { useMemo } from "react";

function StatCard({ label, value, sub, icon }) {
  return (
    <div className="bg-panel border border-border rounded-xl p-4 flex items-start gap-3">
      <div className="w-9 h-9 rounded-lg bg-accent/10 border border-accent/20 flex items-center justify-center text-lg shrink-0">
        {icon}
      </div>
      <div className="min-w-0">
        <p className="text-2xl font-bold text-heading tabular-nums leading-none">{value}</p>
        <p className="text-xs text-soft mt-0.5 font-medium">{label}</p>
        {sub && <p className="text-[11px] text-muted mt-0.5">{sub}</p>}
      </div>
    </div>
  );
}

function TopicCard({ topic, done, total, onClick }) {
  const pct = total > 0 ? Math.round((done / total) * 100) : 0;
  return (
    <button
      onClick={onClick}
      className="bg-panel border border-border rounded-xl p-4 text-left hover:border-accent/40 hover:bg-hover transition-all cursor-pointer group"
    >
      <div className="flex items-center justify-between mb-3">
        <div className="flex items-center gap-2 min-w-0">
          {topic.icon_emoji && <span>{topic.icon_emoji}</span>}
          <span className="text-sm font-semibold text-primary truncate group-hover:text-bright transition-colors">
            {topic.label}
          </span>
        </div>
        <span className="text-xs text-muted tabular-nums shrink-0 ml-2">
          {done}/{total}
        </span>
      </div>
      <div className="h-1.5 bg-hover rounded-full overflow-hidden">
        <div
          className="h-full rounded-full transition-all duration-500"
          style={{
            width: `${pct}%`,
            background: pct === 100 ? 'var(--color-success)' : pct > 0 ? 'var(--color-accent)' : 'transparent',
          }}
        />
      </div>
      <p className="text-[11px] text-muted mt-1.5">
        {pct === 100 ? "Complete ✓" : pct === 0 ? "Not started" : `${pct}% done`}
      </p>
    </button>
  );
}

export default function Dashboard({
  user,
  topics,
  donePerTopic,
  totalDone,
  totalAll,
  streak,
  weekDone,
  weekGoal,
  bookmarks,
  onSelectTopic,
  onSelectBookmark,
}) {
  const displayName = user?.user_metadata?.full_name?.split(" ")[0] || "there";

  const topicsMastered = useMemo(
    () => topics.filter((t) => {
      const total = t.total_count || 0;
      const done = donePerTopic?.[t.id] || 0;
      return total > 0 && done >= total;
    }).length,
    [topics, donePerTopic]
  );

  const lastQ = (() => {
    try { return JSON.parse(localStorage.getItem("devready_last_q") || "null"); }
    catch { return null; }
  })();

  const hour = new Date().getHours();
  const greeting = hour < 12 ? "Good morning" : hour < 17 ? "Good afternoon" : "Good evening";

  return (
    <div className="flex-1 overflow-y-auto p-6 space-y-7">

      {/* Welcome header */}
      <div>
        <h1 className="text-2xl font-bold text-heading">
          {greeting}, {displayName}! 👋
        </h1>
        <p className="text-sm text-muted mt-1">
          {totalDone === 0
            ? "Ready to start your interview prep? Pick a topic from the sidebar."
            : `You've answered ${totalDone} question${totalDone !== 1 ? "s" : ""} so far. Keep it up!`}
        </p>
      </div>

      {/* Stats row */}
      <div className="grid grid-cols-2 lg:grid-cols-4 gap-3">
        <StatCard icon="✅" label="Questions Done" value={totalDone} sub={`of ${totalAll} total`} />
        <StatCard icon="🔥" label="Day Streak" value={streak > 0 ? `${streak}d` : "—"} sub={streak > 0 ? "Keep it going!" : "Answer today to start"} />
        <StatCard icon="🎯" label="Weekly Goal" value={`${weekDone}/${weekGoal}`} sub={weekDone >= weekGoal ? "Goal reached! 🎉" : `${weekGoal - weekDone} left this week`} />
        <StatCard icon="🏆" label="Topics Mastered" value={`${topicsMastered}/${topics.length}`} sub={topicsMastered > 0 ? "Impressive!" : "Complete a topic to master it"} />
      </div>

      {/* Continue where you left off */}
      {lastQ && (
        <div>
          <h2 className="text-xs font-semibold tracking-widest uppercase text-ghost mb-3">Continue Learning</h2>
          <button
            onClick={() => onSelectBookmark?.(lastQ)}
            className="w-full text-left bg-panel border border-border rounded-xl px-5 py-4 hover:border-accent/40 hover:bg-hover transition-all group cursor-pointer"
          >
            <div className="flex items-center justify-between gap-4">
              <div className="min-w-0">
                <p className="text-[11px] text-muted mb-1">
                  {lastQ.topicLabel}{lastQ.sectionLabel ? ` › ${lastQ.sectionLabel}` : ""}
                </p>
                <p className="text-sm font-semibold text-primary group-hover:text-bright transition-colors leading-snug truncate">
                  {lastQ.questionText}
                </p>
              </div>
              <span className="text-accent text-sm font-medium shrink-0 group-hover:translate-x-0.5 transition-transform">
                Resume →
              </span>
            </div>
          </button>
        </div>
      )}

      {/* Bookmarks */}
      {bookmarks?.length > 0 && (
        <div>
          <h2 className="text-xs font-semibold tracking-widest uppercase text-ghost mb-3">Bookmarked</h2>
          <div className="space-y-1">
            {bookmarks.slice(0, 5).map((b) => (
              <button
                key={b.question_id}
                onClick={() => onSelectBookmark?.(b)}
                className="w-full text-left flex items-center gap-3 px-4 py-2.5 rounded-lg bg-panel border border-border hover:border-accent/30 hover:bg-hover transition-all cursor-pointer group"
              >
                <span className="text-warning text-sm shrink-0">★</span>
                <div className="min-w-0">
                  <p className="text-sm text-primary group-hover:text-bright transition-colors truncate">
                    {b.question_text}
                  </p>
                  <p className="text-[11px] text-muted">
                    {b.topic_label}{b.section_label ? ` › ${b.section_label}` : ""}
                  </p>
                </div>
              </button>
            ))}
          </div>
        </div>
      )}

      {/* Topics progress */}
      <div>
        <h2 className="text-xs font-semibold tracking-widest uppercase text-ghost mb-3">All Topics</h2>
        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-3">
          {topics.map((topic) => (
            <TopicCard
              key={topic.id}
              topic={topic}
              done={donePerTopic?.[topic.id] || 0}
              total={topic.total_count || 0}
              onClick={() => onSelectTopic(topic)}
            />
          ))}
        </div>
      </div>

    </div>
  );
}
