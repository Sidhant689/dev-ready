export default function Badge({ level, bgColor = "#1e293b", textColor = "#94a3b8" }) {
  return (
    <span
      className="shrink-0 text-[10px] px-1.5 py-0.5 rounded-full font-medium"
      style={{ background: bgColor, color: textColor }}
    >
      {level}
    </span>
  );
}
