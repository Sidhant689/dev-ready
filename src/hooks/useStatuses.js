import { useState, useEffect, useCallback } from "react";
import { supabase } from "../config/supabaseClient";
import { updateProgress } from "../services/questionService";

const STORAGE_KEY = "dr_statuses";

function qIdFromKey(key) {
  return parseInt(key.replace("q_", ""), 10);
}

export function useStatuses(user) {
  const [statuses, setStatuses] = useState({});
  const [synced, setSynced] = useState(false);

  // ── Load statuses ──────────────────────────────────────────────────
  useEffect(() => {
    console.log("[useStatuses] user state:", user === undefined ? "loading" : user ? `logged in (${user.id})` : "guest");

    if (user === undefined) return;

    if (user) {
      console.log("[useStatuses] fetching progress from Supabase for user:", user.id);

      supabase
        .from("user_progress")
        .select("question_id, status")
        .eq("user_id", user.id)
        .then(({ data, error }) => {
          if (error) {
            console.error("[useStatuses] LOAD ERROR:", error.message, error);
            return;
          }

          console.log("[useStatuses] loaded from Supabase:", data?.length, "rows", data);

          const cloudStatuses = {};
          data.forEach(({ question_id, status }) => {
            cloudStatuses[`q_${question_id}`] = status;
          });

          const local = (() => {
            try { return JSON.parse(localStorage.getItem(STORAGE_KEY) || "{}"); }
            catch { return {}; }
          })();

          const merged = { ...cloudStatuses };
          const toSync = [];
          Object.entries(local).forEach(([key, status]) => {
            if (!cloudStatuses[key]) {
              merged[key] = status;
              toSync.push({ key, status });
            }
          });

          console.log("[useStatuses] merged statuses:", Object.keys(merged).length, "total. toSync:", toSync.length);

          setStatuses(merged);
          setSynced(true);

          toSync.forEach(({ key, status }) => {
            const qId = qIdFromKey(key);
            if (!isNaN(qId)) {
              console.log("[useStatuses] syncing local→cloud:", key, "→", status);
              updateProgress(user.id, qId, status).catch((e) => {
                console.error("[useStatuses] sync error for", key, e.message);
              });
            }
          });

          if (toSync.length > 0) {
            localStorage.removeItem(STORAGE_KEY);
          }
        });
    } else {
      // Guest
      try {
        const saved = localStorage.getItem(STORAGE_KEY);
        const parsed = saved ? JSON.parse(saved) : {};
        console.log("[useStatuses] guest — loaded from localStorage:", Object.keys(parsed).length, "statuses");
        setStatuses(parsed);
      } catch {
        /* ignore */
      }
      setSynced(true);
    }
  }, [user?.id, user === undefined ? "loading" : user ? "loggedin" : "guest"]); // eslint-disable-line

  // ── Save a single status ───────────────────────────────────────────
  const saveStatus = useCallback((key, value) => {
    console.log("[saveStatus] key:", key, "value:", value, "user:", user ? user.id : "guest");

    setStatuses((prev) => {
      const next = { ...prev, [key]: value };

      if (user) {
        const qId = qIdFromKey(key);
        console.log("[saveStatus] calling updateProgress — userId:", user.id, "qId:", qId, "status:", value);

        if (!isNaN(qId)) {
          updateProgress(user.id, qId, value)
            .then((result) => {
              console.log("[saveStatus] ✅ saved to Supabase:", result);
            })
            .catch((e) => {
              console.error("[saveStatus] ❌ Supabase save failed:", e.message, e);
            });
        } else {
          console.warn("[saveStatus] ⚠ could not parse qId from key:", key);
        }
      } else {
        try {
          localStorage.setItem(STORAGE_KEY, JSON.stringify(next));
          console.log("[saveStatus] saved to localStorage:", key, value);
        } catch {
          /* ignore */
        }
      }

      return next;
    });
  }, [user]);

  return { statuses, saveStatus, synced };
}
