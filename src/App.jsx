import { useState, useEffect, useMemo } from "react";
import { useStatuses } from "./hooks/useStatuses";
import { useAnswerCache } from "./hooks/useAnswerCache";
import { qKey } from "./utils/helpers";
import { fetchTopics, fetchSections } from "./services/questionService";
import TopBar from "./components/TopBar";
import Sidebar from "./components/Sidebar";
import QuestionList from "./components/QuestionList";
import QuestionDetail from "./components/QuestionDetail";

export default function App() {
  const [topics, setTopics] = useState([]);
  const [activeTopic, setActiveTopic] = useState(null);
  const [activeSection, setActiveSection] = useState(null);
  const [topicSections, setTopicSections] = useState({});
  const [activeQ, setActiveQ] = useState(null);
  const [expanded, setExpanded] = useState({});

  const { statuses, saveStatus } = useStatuses();
  const { cached, answer, loading: answerLoading, error: answerError, loadAnswer, clearAnswer } = useAnswerCache();

  // ✅ Fetch topics on mount
  useEffect(() => {
    fetchTopics()
      .then((data) => {
        setTopics(data);
        if (data.length > 0) {
          setActiveTopic(data[0]);
          setExpanded({ [data[0].id]: true });
          // Fetch sections for first topic
          fetchSections(data[0].id).then((sections) => {
            setTopicSections((prev) => ({ ...prev, [data[0].id]: sections }));
            if (sections.length > 0) {
              setActiveSection(sections[0]);
            }
          });
        }
      })
      .catch((err) => {
        console.error("Failed to fetch topics:", err);
      });
  }, []);

  const totalDone = useMemo(
    () => Object.values(statuses).filter((v) => v === "Done").length,
    [statuses]
  );

  const totalAll = useMemo(() => {
    return topics.reduce((acc, t) => acc + (t.total_count || 0), 0);
  }, [topics]);

  const activeKey = activeQ ? qKey(activeQ.id) : null;
  const activeStatus = activeKey ? statuses[activeKey] ?? "To Do" : "To Do";

  const openQuestion = (section, question) => {
    const k = qKey(question.id);
    setActiveQ({
      id: question.id,
      text: question.text,
      difficulty: question.difficulty_levels?.label || "Basic",
      difficulty_id: question.difficulty_id,
      section_label: section.label,
      topic_label: activeTopic?.label,
    });
    loadAnswer(question.id, k);
  };

  const closeQuestion = () => {
    setActiveQ(null);
    clearAnswer();
  };

  const handleTopicClick = async (topic) => {
    setExpanded((prev) => ({ ...prev, [topic.id]: !prev[topic.id] }));
    setActiveTopic(topic);
    closeQuestion();

    // Fetch sections if not already fetched
    if (!topicSections[topic.id]) {
      try {
        const sections = await fetchSections(topic.id);
        setTopicSections((prev) => ({ ...prev, [topic.id]: sections }));
        if (sections.length > 0) {
          setActiveSection(sections[0]);
        }
      } catch (err) {
        console.error("Failed to fetch sections:", err);
      }
    } else if (topicSections[topic.id].length > 0) {
      setActiveSection(topicSections[topic.id][0]);
    }
  };

  const handleSectionClick = (topic, section) => {
    setActiveTopic(topic);
    setActiveSection(section);
    closeQuestion();
  };

  return (
    <div
      style={{
        display: "flex",
        flexDirection: "column",
        height: "100vh",
        background: "#0a0c10",
        fontFamily: "system-ui, sans-serif",
        color: "#f1f5f9",
      }}
    >
      <TopBar
        totalDone={totalDone}
        totalAll={totalAll}
        cachedCount={Object.keys(cached).length}
      />

      <div style={{ display: "flex", flex: 1, overflow: "hidden" }}>
        <Sidebar
          topics={topics}
          topicSections={topicSections}
          activeTopic={activeTopic}
          activeSection={activeSection}
          expanded={expanded}
          onTopicClick={handleTopicClick}
          onSectionClick={handleSectionClick}
        />

        <main style={{ flex: 1, display: "flex", flexDirection: "column", overflow: "hidden" }}>
          {activeQ ? (
            <QuestionDetail
              activeQ={activeQ}
              activeKey={activeKey}
              activeStatus={activeStatus}
              answer={answer}
              loading={answerLoading}
              error={answerError}
              onBack={closeQuestion}
              onSaveStatus={saveStatus}
            />
          ) : (
            <QuestionList
              activeTopic={activeTopic}
              activeSection={activeSection}
              statuses={statuses}
              cached={cached}
              onOpenQuestion={openQuestion}
            />
          )}
        </main>
      </div>
    </div>
  );
}
