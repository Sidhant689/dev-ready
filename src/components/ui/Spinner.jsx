export default function Spinner() {
  return (
    <div className="flex flex-col items-center justify-center h-full gap-3 text-subtle">
      <div
        className="w-7 h-7 rounded-full border-2 border-hover border-t-accent"
        style={{ animation: "spin 0.8s linear infinite" }}
      />
      <span className="text-xs">Loading answer…</span>
    </div>
  );
}
