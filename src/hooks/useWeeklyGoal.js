import { useState, useCallback } from "react";

const DEFAULT_GOAL = 20;
const GOAL_KEY = "devready_week_goal";

function getWeekStart() {
  const d = new Date();
  const day = d.getDay();
  d.setHours(0, 0, 0, 0);
  d.setDate(d.getDate() - day);
  return d.toISOString().slice(0, 10);
}

export function getSavedGoal() {
  return parseInt(localStorage.getItem(GOAL_KEY) || String(DEFAULT_GOAL), 10);
}

export function saveGoal(n) {
  localStorage.setItem(GOAL_KEY, String(n));
}

export function useWeeklyGoal() {
  const [state, setState] = useState(() => {
    const goal = getSavedGoal();
    const stored = JSON.parse(localStorage.getItem("devready_week") || "null");
    const currentWeek = getWeekStart();
    const weekDone = stored?.week === currentWeek ? stored.done : 0;
    return { weekDone, weekGoal: goal };
  });

  const recordWeekActivity = useCallback(() => {
    const currentWeek = getWeekStart();
    const stored = JSON.parse(localStorage.getItem("devready_week") || "null");
    const prevDone = stored?.week === currentWeek ? stored.done : 0;
    const newDone = prevDone + 1;
    localStorage.setItem("devready_week", JSON.stringify({ week: currentWeek, done: newDone }));
    setState((prev) => ({ ...prev, weekDone: newDone }));
  }, []);

  const setWeekGoal = useCallback((n) => {
    saveGoal(n);
    setState((prev) => ({ ...prev, weekGoal: n }));
  }, []);

  return { ...state, recordWeekActivity, setWeekGoal };
}
