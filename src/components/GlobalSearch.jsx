import { useState, useEffect, useRef, useCallback } from "react";
import { supabase } from "../config/supabaseClient";

function useSearchResults(query) {
  const [results, setResults] = useState([]);
  const [loading, setLoading] = useState(false);
  const timerRef = useRef(null);

  useEffect(() => {
    if (!query.trim()) { setResults([]); return; }

    clearTimeout(timerRef.current);
    timerRef.current = setTimeout(async () => {
      setLoading(true);
      const { data, error } = await supabase
        .from("questions")
        .select("id, text, difficulty_id, section_id, sections(label, topic_id, topics(label))")
        .ilike("text", `%${query.trim()}%`)
        .limit(20);

      setLoading(false);
      if (!error && data) setResults(data);
    }, 250);

    return () => clearTimeout(timerRef.current);
  }, [query]);

  return { results, loading };
}

export default function GlobalSearch({ onSelectQuestion, onClose, isGuest, onOpenAuth }) {
  const [query, setQuery] = useState("");
  const [cursor, setCursor] = useState(0);
  const { results, loading } = useSearchResults(query);
  const inputRef = useRef(null);
  const listRef = useRef(null);

  useEffect(() => {
    inputRef.current?.focus();
  }, []);

  useEffect(() => {
    setCursor(0);
  }, [results]);

  const handleSelect = useCallback((item, index) => {
    if (isGuest && index >= 3) {
      onOpenAuth("signup");
      onClose();
      return;
    }
    onSelectQuestion(item);
    onClose();
  }, [isGuest, onSelectQuestion, onClose, onOpenAuth]);

  useEffect(() => {
    const handler = (e) => {
      if (e.key === "ArrowDown") {
        e.preventDefault();
        setCursor((c) => Math.min(c + 1, results.length - 1));
      } else if (e.key === "ArrowUp") {
        e.preventDefault();
        setCursor((c) => Math.max(c - 1, 0));
      } else if (e.key === "Enter" && results.length > 0) {
        handleSelect(results[cursor], cursor);
      } else if (e.key === "Escape") {
        onClose();
      }
    };
    window.addEventListener("keydown", handler);
    return () => window.removeEventListener("keydown", handler);
  }, [results, cursor, handleSelect, onClose]);

  // Scroll cursor item into view
  useEffect(() => {
    const el = listRef.current?.children[cursor];
    el?.scrollIntoView({ block: "nearest" });
  }, [cursor]);

  return (
    <div
      className="fixed inset-0 z-50 flex items-start justify-center pt-[10vh] px-4"
      style={{ background: "rgba(0,0,0,0.7)", backdropFilter: "blur(4px)" }}
      onClick={(e) => { if (e.target === e.currentTarget) onClose(); }}
    >
      <div
        className="w-full max-w-xl rounded-2xl overflow-hidden"
        style={{ background: "var(--color-panel)", border: "1px solid var(--color-border)", boxShadow: "0 25px 60px rgba(0,0,0,0.5)" }}
      >
        {/* Search input */}
        <div className="flex items-center gap-3 px-4 py-3 border-b border-border">
          <svg width="16" height="16" viewBox="0 0 16 16" fill="none" className="text-muted shrink-0">
            <circle cx="6.5" cy="6.5" r="4.5" stroke="currentColor" strokeWidth="1.5"/>
            <path d="M10.5 10.5L14 14" stroke="currentColor" strokeWidth="1.5" strokeLinecap="round"/>
          </svg>
          <input
            ref={inputRef}
            type="text"
            placeholder="Search questions…"
            value={query}
            onChange={(e) => setQuery(e.target.value)}
            className="flex-1 bg-transparent text-sm text-bright placeholder-ghost outline-none"
          />
          {loading && (
            <div className="w-4 h-4 rounded-full border-2 border-border border-t-accent shrink-0"
                 style={{ animation: "spin 0.7s linear infinite" }} />
          )}
          <kbd className="hidden sm:flex items-center text-[10px] text-ghost font-mono px-1.5 py-0.5 rounded bg-hover border border-border">
            esc
          </kbd>
        </div>

        {/* Results */}
        <div
          ref={listRef}
          className="max-h-80 overflow-y-auto py-2"
        >
          {!query.trim() && (
            <p className="text-xs text-ghost text-center py-8">Type to search across all questions</p>
          )}

          {query.trim() && !loading && results.length === 0 && (
            <p className="text-xs text-ghost text-center py-8">No questions found for "{query}"</p>
          )}

          {results.map((item, i) => {
            const topicLabel = item.sections?.topics?.label ?? "";
            const sectionLabel = item.sections?.label ?? "";
            const locked = isGuest && i >= 3;

            return (
              <button
                key={item.id}
                className={`w-full text-left px-4 py-2.5 transition-colors cursor-pointer ${
                  i === cursor ? "bg-accent/10" : "hover:bg-hover"
                }`}
                onMouseEnter={() => setCursor(i)}
                onClick={() => handleSelect(item, i)}
              >
                <div className="flex items-center gap-2">
                  {locked && <span className="text-[11px] text-ghost shrink-0">🔒</span>}
                  <p className={`text-sm font-medium leading-snug ${locked ? "text-ghost" : "text-primary"}`}>
                    {item.text}
                  </p>
                </div>
                <p className="text-[11px] text-muted mt-0.5">
                  {topicLabel}{sectionLabel ? ` › ${sectionLabel}` : ""}
                </p>
              </button>
            );
          })}
        </div>

        {/* Footer hint */}
        <div className="flex items-center gap-3 px-4 py-2 border-t border-border">
          <span className="text-[10px] text-ghost flex items-center gap-1">
            <kbd className="font-mono px-1 py-0.5 rounded bg-hover border border-border">↑↓</kbd> navigate
          </span>
          <span className="text-[10px] text-ghost flex items-center gap-1">
            <kbd className="font-mono px-1 py-0.5 rounded bg-hover border border-border">↵</kbd> open
          </span>
          {isGuest && (
            <span className="ml-auto text-[10px] text-accent">Sign in to unlock all results</span>
          )}
        </div>
      </div>
    </div>
  );
}
