import { useState, useEffect, useCallback } from "react";
import { supabase } from "../config/supabaseClient";

const DEFAULTS = { weekly_goal: 20, theme: "dark" };

function applyTheme(theme) {
  document.documentElement.setAttribute("data-theme", theme);
  localStorage.setItem("devready_theme", theme);
}

export function useUserSettings(user) {
  // Initialise from localStorage cache so there's no flash on load
  const [settings, setSettings] = useState(() => ({
    ...DEFAULTS,
    theme: localStorage.getItem("devready_theme") || "dark",
    weekly_goal: parseInt(localStorage.getItem("devready_week_goal") || "20", 10),
  }));
  const [loaded, setLoaded] = useState(false);

  useEffect(() => {
    if (!user) {
      // Guest: just use localStorage, apply theme
      applyTheme(settings.theme);
      setLoaded(true);
      return;
    }

    supabase
      .from("user_settings")
      .select("weekly_goal, theme")
      .eq("user_id", user.id)
      .single()
      .then(async ({ data, error }) => {
        if (error?.code === "PGRST116") {
          // No row yet — create one with current cached values
          const row = { user_id: user.id, ...DEFAULTS, theme: settings.theme, weekly_goal: settings.weekly_goal };
          await supabase.from("user_settings").insert(row);
          applyTheme(row.theme);
          setSettings((prev) => ({ ...prev, ...row }));
        } else if (data) {
          applyTheme(data.theme);
          localStorage.setItem("devready_week_goal", String(data.weekly_goal));
          setSettings((prev) => ({ ...prev, ...data }));
        }
        setLoaded(true);
      });
  }, [user?.id]); // eslint-disable-line

  const updateSetting = useCallback(async (key, value) => {
    setSettings((prev) => ({ ...prev, [key]: value }));

    if (key === "theme") applyTheme(value);
    if (key === "weekly_goal") localStorage.setItem("devready_week_goal", String(value));

    if (user) {
      await supabase
        .from("user_settings")
        .upsert({ user_id: user.id, [key]: value, updated_at: new Date().toISOString() }, { onConflict: "user_id" });
    }
  }, [user?.id]); // eslint-disable-line

  return { settings, loaded, updateSetting };
}
