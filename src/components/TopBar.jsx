export default function TopBar({ totalDone, totalAll, streak = 0, user, isGuest, onMenuClick, onSignIn, onSignOut, onSearchOpen, onSettingsOpen, theme, onToggleTheme, onLogoClick, unreadCount = 0, onNotifOpen }) {
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

        {/* Logo — click to go home/dashboard */}
        <button
          onClick={onLogoClick}
          className="flex items-center gap-2 font-bold text-heading text-base select-none cursor-pointer hover:opacity-80 transition-opacity"
        >
          <div
            className="w-8 h-8 rounded-lg overflow-hidden shrink-0"
            style={{ boxShadow: '0 0 16px rgba(99,102,241,0.35)' }}
          >
            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 64 64" fill="none" width="32" height="32">
              <defs>
                <linearGradient id="tbg" x1="0" y1="0" x2="64" y2="64" gradientUnits="userSpaceOnUse">
                  <stop stopColor="#4f46e5"/><stop offset="1" stopColor="#7c3aed"/>
                </linearGradient>
                <radialGradient id="tglow" cx="30%" cy="25%" r="60%">
                  <stop offset="0%" stopColor="#818cf8" stopOpacity="0.4"/>
                  <stop offset="100%" stopColor="#4f46e5" stopOpacity="0"/>
                </radialGradient>
              </defs>
              <rect width="64" height="64" rx="16" fill="url(#tbg)"/>
              <rect width="64" height="64" rx="16" fill="url(#tglow)"/>
              <path d="M14 32 L22 23 M14 32 L22 41" stroke="white" strokeWidth="4" strokeLinecap="round" strokeLinejoin="round" strokeOpacity="0.55"/>
              <path d="M50 32 L42 23 M50 32 L42 41" stroke="white" strokeWidth="4" strokeLinecap="round" strokeLinejoin="round" strokeOpacity="0.55"/>
              <path d="M22 32 L28.5 39.5 L42 24" stroke="white" strokeWidth="5" strokeLinecap="round" strokeLinejoin="round"/>
            </svg>
          </div>
          <span className="hidden sm:block">DevReady</span>
        </button>

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

          {/* Notification bell — logged-in only */}
          {!isGuest && (
            <button
              onClick={onNotifOpen}
              className="relative w-8 h-8 flex items-center justify-center rounded-md text-muted hover:text-primary hover:bg-hover transition-colors cursor-pointer"
              title="Notifications"
            >
              <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round">
                <path d="M18 8A6 6 0 006 8c0 7-3 9-3 9h18s-3-2-3-9M13.73 21a2 2 0 01-3.46 0"/>
              </svg>
              {unreadCount > 0 && (
                <span className="absolute -top-0.5 -right-0.5 min-w-4 h-4 rounded-full bg-accent text-white text-[9px] font-bold flex items-center justify-center px-0.5 tabular-nums"
                  style={{ boxShadow: "0 0 8px rgba(99,102,241,0.5)" }}>
                  {unreadCount > 9 ? "9+" : unreadCount}
                </span>
              )}
            </button>
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
              <div className="absolute right-0 top-10 w-48 bg-panel border border-border rounded-xl shadow-lg opacity-0 invisible group-hover:opacity-100 group-hover:visible transition-all duration-150 z-50">
                <div className="px-3 py-2.5 border-b border-border">
                  <p className="text-xs font-semibold text-bright truncate">{displayName}</p>
                  <p className="text-[10px] text-muted truncate">{user?.email}</p>
                </div>
                <button
                  onClick={onSettingsOpen}
                  className="w-full text-left px-3 py-2 text-xs text-muted hover:text-primary hover:bg-hover transition-colors cursor-pointer flex items-center gap-2"
                >
                  <svg width="12" height="12" viewBox="0 0 12 12" fill="none"><circle cx="6" cy="6" r="2" stroke="currentColor" strokeWidth="1.2"/><path d="M6 1v1M6 10v1M1 6h1M10 6h1M2.5 2.5l.7.7M8.8 8.8l.7.7M2.5 9.5l.7-.7M8.8 3.2l.7-.7" stroke="currentColor" strokeWidth="1.2" strokeLinecap="round"/></svg>
                  Settings
                </button>
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
