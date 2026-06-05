// ✅ Status config (fixed - not from database)
export const STATUS_CFG = {
  "To Do":       { color: "#94a3b8", icon: "○" },
  "In Progress": { color: "#f59e0b", icon: "◐" },
  "Done":        { color: "#22c55e", icon: "✓" },
};

// ✅ REMOVED: LEVEL_CFG - now fetched from difficulty_levels table
// ✅ REMOVED: LEVELS - now fetched from API via fetchLevelsList()
