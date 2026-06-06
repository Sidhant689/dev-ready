export default function TopBar({ totalDone, totalAll, streak = 0, user, isGuest, onMenuClick, onSignIn, onSignOut, onSearchOpen, theme, onToggleTheme }) {
  const pct = totalAll > 0 ? Math.round((totalDone / totalAll) * 100) : 0;

  // Derive display name / initials from user metadata
  const displayName = user?.user_metadata?.full_name || user?.email || "";
  const initials = displayName
    ? displayName.split(" ").map((w) => w[0]).join("").slice(0, 2).toUpperCase()
    : "?";

  return (
    <header className="shrink-0 bg-panel border-b border-border">
      <div className="flex items-center gap-3 px-4 h-14">

        {/* Mobile hamburger */}
        <button
          className="md:hidden w-8 h-8 flex items-center justify-center rounded-md text-muted hover:text-primary hover:bg-hover transition-colors cursor-pointer"
          onClick={onMenuClick}
          aria-label="Open navigation"
        >
          <svg width="16" height="16" viewBox="0 0 16 16" fill="none">
            <path d="M2 4h12M2 8h12M2 12h12" stroke="currentColor" strokeWidth="1.5" strokeLinecap="round"/>
          </svg>
        </button>

        {/* Logo */}
        <div className="flex items-center gap-2 font-bold text-heading text-base select-none">
          <div
            className="w-8 h-8 rounded-lg bg-accent flex items-center justify-center text-white text-sm font-bold"
            style={{ boxShadow: '0 0 16px rgba(99,102,241,0.35)' }}
          >
            D
          </div>
          <span className="hidden sm:block">DevReady</span>
        </div>

        {/* Progress bar — only meaningful for logged-in users */}
        {!isGuest && (
          <div className="flex-1 flex items-center gap-3 ml-2">
            <div className="flex-1 h-2 bg-hover rounded-full overflow-hidden max-w-xs">
              <div
                className="h-full rounded-full transition-all duration-700"
                style={{
                  width: `${pct}%`,
                  background: pct === 100
                    ? 'var(--color-success)'
                    : 'linear-gradient(90deg, #6366f1, #818cf8)',
                }}
              />
            </div>
            <span className="text-xs text-subtle tabular-nums whitespace-nowrap font-medium">
              {pct}%
            </span>
          </div>
        )}

        {/* Spacer for guests */}
        {isGuest && <div className="flex-1" />}

        {/* Search trigger */}
        <button
          onClick={onSearchOpen}
          className="hidden sm:flex items-center gap-2 h-8 px-3 rounded-lg border border-border text-ghost hover:text-muted hover:border-subtle text-xs transition-colors cursor-pointer"
          title="Search (Ctrl+K / ⌘K)"
        >
          <svg width="12" height="12" viewBox="0 0 12 12" fill="none">
            <circle cx="5" cy="5" r="3.5" stroke="currentColor" strokeWidth="1.3"/>
            <path d="M8 8L11 11" stroke="currentColor" strokeWidth="1.3" strokeLinecap="round"/>
          </svg>
          <span>Search</span>
          <kbd className="font-mono text-[10px] px-1 rounded bg-hover border border-border ml-1">⌘K</kbd>
        </button>

        {/* Right section */}
        <div className="flex items-center gap-3">

          {/* Done count — logged in only */}
          {!isGuest && (
            <span className="hidden sm:flex items-center gap-1.5 text-xs text-subtle">
              <span className="w-4 h-4 rounded-full bg-success/20 text-success flex items-center justify-center text-[10px] font-bold">✓</span>
              <span className="text-soft font-medium tabular-nums">{totalDone}</span>
              <span className="text-ghost">/</span>
              <span className="text-muted tabular-nums">{totalAll}</span>
            </span>
          )}

          {/* Streak — logged in only */}
          {!isGuest && streak > 0 && (
            <span className="hidden md:flex items-center gap-1 text-xs text-warning font-medium">
              🔥 {streak}d
            </span>
          )}

          {/* Theme toggle */}
          <button
            onClick={onToggleTheme}
            className="w-8 h-8 flex items-center justify-center rounded-md text-muted hover:text-primary hover:bg-hover transition-colors cursor-pointer"
            title={theme === "dark" ? "Switch to light mode" : "Switch to dark mode"}
          >
            {theme === "dark" ? (
              <svg width="15" height="15" viewBox="0 0 15 15" fill="none">
                <circle cx="7.5" cy="7.5" r="3" stroke="currentColor" strokeWidth="1.3"/>
                <path d="M7.5 1v1.5M7.5 12.5V14M1 7.5h1.5M12.5 7.5H14M2.9 2.9l1.06 1.06M11.04 11.04l1.06 1.06M2.9 12.1l1.06-1.06M11.04 3.96l1.06-1.06" stroke="currentColor" strokeWidth="1.3" strokeLinecap="round"/>
              </svg>
            ) : (
              <svg width="14" height="14" viewBox="0 0 14 14" fill="none">
                <path d="M12.5 8.5A5.5 5.5 0 0 1 5.5 1.5a5.5 5.5 0 1 0 7 7z" stroke="currentColor" strokeWidth="1.3" strokeLinecap="round" strokeLinejoin="round"/>
              </svg>
            )}
          </button>

          {/* Auth: guest → Sign In button | user → avatar */}
          {isGuest ? (
            <button
              onClick={onSignIn}
              className="flex items-center gap-1.5 h-8 px-4 rounded-lg bg-accent hover:bg-accent-hover text-white text-xs font-semibold transition-colors cursor-pointer"
              style={{ boxShadow: '0 0 12px rgba(99,102,241,0.3)' }}
            >
              Sign In
            </button>
          ) : (
            <div className="relative group">
              <button
                className="w-8 h-8 rounded-full bg-accent/20 border border-accent/40 text-accent text-xs font-bold flex items-center justify-center cursor-pointer hover:bg-accent/30 transition-colors"
                title={displayName}
              >
                {initials}
              </button>
              {/* Dropdown */}
              <div className="absolute right-0 top-10 w-44 bg-panel border border-border rounded-xl shadow-lg opacity-0 invisible group-hover:opacity-100 group-hover:visible transition-all duration-150 z-50">
                <div className="px-3 py-2.5 border-b border-border">
                  <p className="text-xs font-semibold text-bright truncate">{displayName}</p>
                  <p className="text-[10px] text-muted truncate">{user?.email}</p>
                </div>
                <button
                  onClick={onSignOut}
                  className="w-full text-left px-3 py-2 text-xs text-muted hover:text-danger hover:bg-danger/5 transition-colors cursor-pointer rounded-b-xl"
                >
                  Sign out
                </button>
              </div>
            </div>
          )}
        </div>

      </div>
    </header>
  );
}
