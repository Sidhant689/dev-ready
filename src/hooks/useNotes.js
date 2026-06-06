import { useState, useEffect, useCallback, useRef } from "react";
import { supabase } from "../config/supabaseClient";

const STORAGE_KEY = "dr_notes";

function localKey(questionId) { return `note_${questionId}`; }

export function useNotes(user, questionId) {
  const [note, setNote] = useState("");
  const [saving, setSaving] = useState(false);
  const [saved, setSaved] = useState(false);
  const saveTimer = useRef(null);

  // Load note when question or user changes
  useEffect(() => {
    if (!questionId) { setNote(""); return; }

    if (user) {
      supabase
        .from("user_notes")
        .select("content")
        .eq("user_id", user.id)
        .eq("question_id", questionId)
        .single()
        .then(({ data, error }) => {
          if (error && error.code !== "PGRST116") return;
          setNote(data?.content ?? "");
        });
    } else {
      try {
        const all = JSON.parse(localStorage.getItem(STORAGE_KEY) || "{}");
        setNote(all[localKey(questionId)] ?? "");
      } catch { setNote(""); }
    }
    setSaved(false);
  }, [user?.id, questionId]);

  const saveNote = useCallback((content) => {
    setNote(content);
    setSaved(false);
    clearTimeout(saveTimer.current);

    saveTimer.current = setTimeout(async () => {
      setSaving(true);
      if (user) {
        const { error } = await supabase
          .from("user_notes")
          .upsert(
            { user_id: user.id, question_id: questionId, content, updated_at: new Date().toISOString() },
            { onConflict: "user_id,question_id" }
          );
        if (!error) setSaved(true);
      } else {
        try {
          const all = JSON.parse(localStorage.getItem(STORAGE_KEY) || "{}");
          all[localKey(questionId)] = content;
          localStorage.setItem(STORAGE_KEY, JSON.stringify(all));
          setSaved(true);
        } catch { /* ignore */ }
      }
      setSaving(false);
    }, 800);
  }, [user?.id, questionId]);

  return { note, saving, saved, saveNote };
}
