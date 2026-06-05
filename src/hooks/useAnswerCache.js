import { useState, useEffect } from "react";
import { fetchAnswer } from "../services/answerService";

const KEYS_KEY = "dr_ckeys";
const ANS_PREFIX = "dr_ans_";

export function useAnswerCache() {
  const [cached, setCached] = useState({});
  const [answer, setAnswer] = useState("");
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState("");

  // Hydrate cache from localStorage on mount
  useEffect(() => {
    try {
      const keys = JSON.parse(localStorage.getItem(KEYS_KEY) || "[]");
      const entries = {};
      keys.forEach((k) => {
        try {
          const val = localStorage.getItem(ANS_PREFIX + k);
          if (val) entries[k] = val;
        } catch {}
      });
      setCached(entries);
    } catch {}
  }, []);

  const loadAnswer = async (topic, section, q, key) => {
    setError("");

    if (cached[key]) {
      setAnswer(cached[key]);
      return;
    }

    setLoading(true);
    setAnswer("");
    try {
      const ans = await fetchAnswer(topic.id, section.id, q[0]);
      if (ans) {
        setAnswer(ans);
        setCached((prev) => {
          const next = { ...prev, [key]: ans };
          try {
            localStorage.setItem(ANS_PREFIX + key, ans);
            localStorage.setItem(KEYS_KEY, JSON.stringify(Object.keys(next)));
          } catch {}
          return next;
        });
      }
    } catch (e) {
      setError(e.message);
    } finally {
      setLoading(false);
    }
  };

  const clearAnswer = () => {
    setAnswer("");
    setError("");
  };

  return { cached, answer, loading, error, loadAnswer, clearAnswer };
}
