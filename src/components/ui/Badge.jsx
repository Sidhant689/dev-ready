import { LEVEL_CFG } from "../../constants";

export default function Badge({ level }) {
  const cfg = LEVEL_CFG[level] ?? { bg: "#1e293b", color: "#94a3b8" };
  return (
    <span
      style={{
        flexShrink: 0,
        fontSize: 10,
        padding: "2px 6px",
        borderRadius: 100,
        fontWeight: 500,
        background: cfg.bg,
        color: cfg.color,
      }}
    >
      {level}
    </span>
  );
}
