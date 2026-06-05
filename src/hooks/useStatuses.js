import { useState, useEffect } from "react";

const STORAGE_KEY = "dr_statuses";

export function useStatuses() {
  const [statuses, setStatuses] = useState({});

  useEffect(() => {
    try {
      const saved = localStorage.getItem(STORAGE_KEY);
      if (saved) setStatuses(JSON.parse(saved));
    } catch {
      // Ignore hydration errors
    }
  }, []);

  const saveStatus = (key, value) => {
    setStatuses((prev) => {
      const next = { ...prev, [key]: value };
      try {
        localStorage.setItem(STORAGE_KEY, JSON.stringify(next));
      } catch {
        // Ignore storage errors
      }
      return next;
    });
  };

  return { statuses, saveStatus };
}
