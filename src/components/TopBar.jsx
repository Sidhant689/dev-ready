export default function TopBar({ totalDone, totalAll, cachedCount }) {
  const pct = totalAll > 0 ? Math.round((totalDone / totalAll) * 100) : 0;

  return (
    <header className="shrink-0 bg-panel border-b border-border">
      <div className="flex items-center gap-3 px-4 h-12">
        {/* Logo */}
        <div className="flex items-center gap-2 text-sm font-semibold text-bright">
          <div className="w-7 h-7 rounded-md bg-accent flex items-center justify-center text-sm">
            🎯
          </div>
          DevReady
        </div>

        {/* Progress bar */}
        <div className="flex-1 flex items-center gap-3 ml-4">
          <div className="flex-1 h-1.5 bg-hover rounded-full overflow-hidden">
            <div
              className="h-full bg-accent rounded-full transition-all duration-500"
              style={{ width: `${pct}%` }}
            />
          </div>
          <span className="text-xs text-subtle whitespace-nowrap">
            {pct}%
          </span>
        </div>

        {/* Stats */}
        <div className="flex items-center gap-4 ml-2">
          <span className="text-xs text-subtle">
            <span className="text-green-500 font-medium">✓</span>{" "}
            {totalDone} <span className="text-muted">/ {totalAll}</span>
          </span>
          {cachedCount > 0 && (
            <span className="text-xs text-subtle">
              <span className="text-green-400">⚡</span> {cachedCount} cached
            </span>
          )}
        </div>
      </div>
    </header>
  );
}
