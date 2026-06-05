export default function Spinner() {
  return (
    <div
      style={{
        display: "flex",
        flexDirection: "column",
        alignItems: "center",
        justifyContent: "center",
        height: "100%",
        gap: 12,
        color: "#64748b",
      }}
    >
      <div
        style={{
          width: 28,
          height: 28,
          border: "2px solid #1e293b",
          borderTop: "2px solid #6366f1",
          borderRadius: "50%",
          animation: "spin 0.8s linear infinite",
        }}
      />
      <span style={{ fontSize: 13 }}>Loading answer…</span>
    </div>
  );
}
