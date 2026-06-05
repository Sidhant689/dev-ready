export default function Badge({ level, bgColor = "#1e293b", textColor = "#94a3b8" }) {
  return (
    <span
      style={{
        flexShrink: 0,
        fontSize: 10,
        padding: "2px 6px",
        borderRadius: 100,
        fontWeight: 500,
        background: bgColor,
        color: textColor,
      }}
    >
      {level}
    </span>
  );
}
