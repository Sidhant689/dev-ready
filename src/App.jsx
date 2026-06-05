import { useState, useMemo } from "react";
import { TOPICS } from "./data/topics";
import { useStatuses } from "./hooks/useStatuses";
import { useAnswerCache } from "./hooks/useAnswerCache";
import { qKey, totalQs } from "./utils/helpers";
import TopBar from "./components/TopBar";
import Sidebar from "./components/Sidebar";
import QuestionList from "./components/QuestionList";
import QuestionDetail from "./components/QuestionDetail";

export default function App() {
  const [activeTopic, setActiveTopic] = useState(TOPICS[0]);
  const [activeSection, setActiveSection] = useState(TOPICS[0].sections[0]);
  const [activeQ, setActiveQ] = useState(null);
  const [expanded, setExpanded] = useState({ ".NET": true });

  const { statuses, saveStatus } = useStatuses();
  const { cached, answer, loading, error, loadAnswer, clearAnswer } = useAnswerCache();

  const totalDone = useMemo(
    () => Object.values(statuses).filter((v) => v === "Done").length,
    [statuses]
  );
  const totalAll = useMemo(
    () => TOPICS.reduce((acc, t) => acc + totalQs(t), 0),
    []
  );

  const activeKey = activeQ ? qKey(activeQ.tid, activeQ.sid, activeQ.sl) : null;
  const activeStatus = activeKey ? statuses[activeKey] ?? "To Do" : "To Do";

  const openQuestion = (topic, section, q) => {
    const k = qKey(topic.id, section.id, q[0]);
    setActiveQ({
      tid: topic.id,
      sid: section.id,
      sl: q[0],
      q: q[1],
      level: q[2],
      slabel: section.label,
      tlabel: topic.label,
    });
    loadAnswer(topic, section, q, k);
  };

  const closeQuestion = () => {
    setActiveQ(null);
    clearAnswer();
  };

  const handleTopicClick = (topic) => {
    setExpanded((prev) => ({ ...prev, [topic.id]: !prev[topic.id] }));
    setActiveTopic(topic);
    if (topic.sections.length) {
      setActiveSection(topic.sections[0]);
      closeQuestion();
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
          topics={TOPICS}
          activeTopic={activeTopic}
          activeSection={activeSection}
          expanded={expanded}
          statuses={statuses}
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
              loading={loading}
              error={error}
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
