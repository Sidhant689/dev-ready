import { useState, useCallback } from "react";

const WEEK_GOAL = 20; // target questions per week

function getWeekStart() {
  const d = new Date();
  const day = d.getDay(); // 0 = Sunday
  d.setHours(0, 0, 0, 0);
  d.setDate(d.getDate() - day);
  return d.toISOString().slice(0, 10);
}

export function useWeeklyGoal() {
  const [state, setState] = useState(() => {
    const stored = JSON.parse(localStorage.getItem("devready_week") || "null");
    const currentWeek = getWeekStart();
    if (stored && stored.week === currentWeek) {
      return { weekDone: stored.done, weekGoal: WEEK_GOAL };
    }
    return { weekDone: 0, weekGoal: WEEK_GOAL };
  });

  const recordWeekActivity = useCallback(() => {
    const currentWeek = getWeekStart();
    const stored = JSON.parse(localStorage.getItem("devready_week") || "null");
    const prevDone = stored?.week === currentWeek ? stored.done : 0;
    const newDone = prevDone + 1;
    localStorage.setItem("devready_week", JSON.stringify({ week: currentWeek, done: newDone }));
    setState({ weekDone: newDone, weekGoal: WEEK_GOAL });
  }, []);

  return { ...state, recordWeekActivity };
}
