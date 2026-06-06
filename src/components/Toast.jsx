import { useEffect } from "react";

export default function Toast({ message, sub, onDismiss, duration = 3500 }) {
  useEffect(() => {
    const t = setTimeout(onDismiss, duration);
    return () => clearTimeout(t);
  }, [onDismiss, duration]);

  return (
    <div
      className="fixed bottom-5 right-5 z-50 flex items-start gap-3 bg-panel border border-success/40 rounded-xl px-5 py-4 max-w-xs"
      style={{ boxShadow: 'var(--shadow-modal), 0 0 20px rgba(16,185,129,0.15)' }}
    >
      <div className="w-8 h-8 rounded-full bg-success/20 border border-success/30 flex items-center justify-center text-success shrink-0 text-sm font-bold mt-0.5">
        ✓
      </div>
      <div className="flex-1 min-w-0">
        <p className="text-sm font-semibold text-bright">{message}</p>
        {sub && <p className="text-xs text-muted mt-0.5">{sub}</p>}
      </div>
      <button
        onClick={onDismiss}
        className="text-ghost hover:text-muted transition-colors cursor-pointer ml-1 shrink-0"
      >
        <svg width="12" height="12" viewBox="0 0 12 12" fill="none">
          <path d="M1 1l10 10M11 1L1 11" stroke="currentColor" strokeWidth="1.5" strokeLinecap="round"/>
        </svg>
      </button>
    </div>
  );
}
