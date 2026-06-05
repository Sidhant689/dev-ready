import { useState, useEffect } from "react";
import { TOPIC_STRUCTURE } from "../data/topics";
import { fetchAllQuestions } from "../services/questionService";

// Initialise with empty qs so the sidebar renders immediately while DB loads
const emptyTopics = TOPIC_STRUCTURE.map((t) => ({
  ...t,
  sections: t.sections.map((s) => ({ ...s, qs: [] })),
}));

export function useTopics() {
  const [topics, setTopics] = useState(emptyTopics);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState("");

  useEffect(() => {
    fetchAllQuestions()
      .then((rows) => {
        // Group rows: { [topicId]: { [sectionId]: [[sl, question, level], ...] } }
        const grouped = {};
        rows.forEach(({ topic, section_id, sl, question, level }) => {
          if (!grouped[topic]) grouped[topic] = {};
          if (!grouped[topic][section_id]) grouped[topic][section_id] = [];
          grouped[topic][section_id].push([sl, question, level]);
        });

        // Merge DB questions into static structure (preserves colors, labels, order)
        setTopics(
          TOPIC_STRUCTURE.map((topic) => ({
            ...topic,
            sections: topic.sections.map((section) => ({
              ...section,
              qs: grouped[topic.id]?.[section.id] ?? [],
            })),
          }))
        );
      })
      .catch((e) => setError(e.message))
      .finally(() => setLoading(false));
  }, []);

  return { topics, loading, error };
}
