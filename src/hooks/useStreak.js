import { useState, useCallback } from "react";

function todayKey() {
  return new Date().toISOString().slice(0, 10); // "YYYY-MM-DD"
}

function daysBetween(a, b) {
  const msPerDay = 86400000;
  return Math.round((new Date(b) - new Date(a)) / msPerDay);
}

export function useStreak() {
  const [streak, setStreak] = useState(() => {
    const stored = parseInt(localStorage.getItem("devready_streak") || "0", 10);
    const lastDate = localStorage.getItem("devready_streak_last");
    if (!lastDate) return 0;
    const gap = daysBetween(lastDate, todayKey());
    // Streak alive if activity was today or yesterday
    return gap <= 1 ? stored : 0;
  });

  const recordActivity = useCallback(() => {
    const today = todayKey();
    const lastDate = localStorage.getItem("devready_streak_last");

    if (lastDate === today) return; // already recorded today

    const gap = lastDate ? daysBetween(lastDate, today) : null;
    const newStreak = gap === 1 ? streak + 1 : 1;

    localStorage.setItem("devready_streak", String(newStreak));
    localStorage.setItem("devready_streak_last", today);
    setStreak(newStreak);
  }, [streak]);

  return { streak, recordActivity };
}
