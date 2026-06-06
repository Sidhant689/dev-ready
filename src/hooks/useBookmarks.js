import { useState, useEffect, useCallback } from "react";
import { supabase } from "../config/supabaseClient";

const LS_KEY = "dr_bookmarks";

function loadLocal() {
  try { return JSON.parse(localStorage.getItem(LS_KEY) || "[]"); }
  catch { return []; }
}

export function useBookmarks(user) {
  const [bookmarks, setBookmarks] = useState([]); // [{question_id, question_text, section_label, topic_label}]

  useEffect(() => {
    if (user === undefined) return;

    if (user) {
      supabase
        .from("user_bookmarks")
        .select("question_id, question_text, section_label, topic_label, created_at")
        .eq("user_id", user.id)
        .order("created_at", { ascending: false })
        .then(({ data, error }) => {
          if (!error && data) setBookmarks(data);
        });
    } else {
      setBookmarks(loadLocal());
    }
  }, [user?.id, user === undefined ? "loading" : user ? "in" : "guest"]); // eslint-disable-line

  const isBookmarked = useCallback(
    (qId) => bookmarks.some((b) => b.question_id === qId),
    [bookmarks]
  );

  const toggleBookmark = useCallback(async (qId, meta = {}) => {
    const already = bookmarks.some((b) => b.question_id === qId);

    if (user) {
      if (already) {
        await supabase.from("user_bookmarks").delete().eq("user_id", user.id).eq("question_id", qId);
        setBookmarks((prev) => prev.filter((b) => b.question_id !== qId));
      } else {
        const row = {
          user_id: user.id,
          question_id: qId,
          question_text: meta.text || "",
          section_label: meta.section_label || "",
          topic_label: meta.topic_label || "",
        };
        const { data, error } = await supabase.from("user_bookmarks").insert(row).select().single();
        if (!error && data) setBookmarks((prev) => [data, ...prev]);
      }
    } else {
      const local = loadLocal();
      let next;
      if (already) {
        next = local.filter((b) => b.question_id !== qId);
      } else {
        next = [{ question_id: qId, question_text: meta.text || "", section_label: meta.section_label || "", topic_label: meta.topic_label || "" }, ...local];
      }
      localStorage.setItem(LS_KEY, JSON.stringify(next));
      setBookmarks(next);
    }
  }, [user, bookmarks]);

  return { bookmarks, isBookmarked, toggleBookmark };
}
