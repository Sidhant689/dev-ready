export default function TopBar({ totalDone, totalAll, cachedCount }) {
  return (
    <header
      style={{
        display: "flex",
        alignItems: "center",
        gap: 12,
        padding: "0 16px",
        height: 48,
        background: "#0f1117",
        borderBottom: "1px solid #1e293b",
        flexShrink: 0,
      }}
    >
      <div style={{ display: "flex", alignItems: "center", gap: 8, fontSize: 15, fontWeight: 600 }}>
        <div
          style={{
            width: 26,
            height: 26,
            borderRadius: 6,
            background: "#6366f1",
            display: "flex",
            alignItems: "center",
            justifyContent: "center",
            fontSize: 14,
          }}
        >
          🎯
        </div>
        DevReady
      </div>

      <div style={{ marginLeft: "auto", display: "flex", gap: 16 }}>
        <span style={{ fontSize: 12, color: "#64748b" }}>
          ✓ {totalDone} / {totalAll} done
        </span>
        <span style={{ fontSize: 12, color: "#64748b" }}>
          ⚡ {cachedCount} cached locally
        </span>
      </div>
    </header>
  );
}
