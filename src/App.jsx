import { useState, useEffect, useMemo, useCallback } from "react";
import { useStatuses } from "./hooks/useStatuses";
import { useAnswerCache } from "./hooks/useAnswerCache";
import { qKey } from "./utils/helpers";
import { fetchTopics, fetchSections, fetchQuestions } from "./services/questionService";
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

  // Lifted questions state – shared between list and detail views
  const [sectionQuestions, setSectionQuestions] = useState([]);
  const [questionsLoading, setQuestionsLoading] = useState(false);

  // question id → topic id mapping, built up as sections are visited
  const [questionMeta, setQuestionMeta] = useState({});

  const { statuses, saveStatus } = useStatuses();
  const { cached, answer, loading: answerLoading, error: answerError, loadAnswer, clearAnswer } = useAnswerCache();

  // Fetch topics on mount
  useEffect(() => {
    fetchTopics()
      .then((data) => {
        setTopics(data);
        if (data.length > 0) {
          setActiveTopic(data[0]);
          setExpanded({ [data[0].id]: true });
          fetchSections(data[0].id).then((sections) => {
            setTopicSections((prev) => ({ ...prev, [data[0].id]: sections }));
            if (sections.length > 0) setActiveSection(sections[0]);
          });
        }
      })
      .catch(console.error);
  }, []);

  // Fetch questions whenever active section changes
  useEffect(() => {
    if (!activeSection) { setSectionQuestions([]); return; }
    setQuestionsLoading(true);
    fetchQuestions(activeSection.id)
      .then((data) => { setSectionQuestions(data); setQuestionsLoading(false); })
      .catch(() => setQuestionsLoading(false));
  }, [activeSection?.id]);

  // Track which topic each question belongs to (for per-topic progress)
  useEffect(() => {
    if (!activeTopic || !sectionQuestions.length) return;
    const updates = Object.fromEntries(sectionQuestions.map((q) => [q.id, activeTopic.id]));
    setQuestionMeta((prev) => ({ ...prev, ...updates }));
  }, [sectionQuestions, activeTopic?.id]);

  const totalDone = useMemo(
    () => Object.values(statuses).filter((v) => v === "Done").length,
    [statuses]
  );

  const totalAll = useMemo(
    () => topics.reduce((acc, t) => acc + (t.total_count || 0), 0),
    [topics]
  );

  // Per-topic done counts derived from localStorage statuses + questionMeta map
  const donePerTopic = useMemo(() => {
    const counts = {};
    Object.entries(statuses).forEach(([key, status]) => {
      if (status !== "Done") return;
      const qId = parseInt(key.replace("q_", ""), 10);
      const topicId = questionMeta[qId];
      if (topicId) counts[topicId] = (counts[topicId] || 0) + 1;
    });
    return counts;
  }, [statuses, questionMeta]);

  // Index of the active question within the current section's list
  const activeQIndex = useMemo(() => {
    if (!activeQ) return -1;
    return sectionQuestions.findIndex((q) => q.id === activeQ.id);
  }, [activeQ?.id, sectionQuestions]);

  const openQuestion = useCallback((section, question) => {
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
  }, [activeTopic?.label, loadAnswer]);

  const closeQuestion = () => { setActiveQ(null); clearAnswer(); };

  const handlePrev = () => {
    if (activeQIndex > 0) openQuestion(activeSection, sectionQuestions[activeQIndex - 1]);
  };

  const handleNext = () => {
    if (activeQIndex < sectionQuestions.length - 1) openQuestion(activeSection, sectionQuestions[activeQIndex + 1]);
  };

  const handleJumpTo = (idx) => {
    const q = sectionQuestions[Number(idx)];
    if (q) openQuestion(activeSection, q);
  };

  const handleTopicClick = async (topic) => {
    setExpanded((prev) => ({ ...prev, [topic.id]: !prev[topic.id] }));
    setActiveTopic(topic);
    closeQuestion();

    if (!topicSections[topic.id]) {
      try {
        const sections = await fetchSections(topic.id);
        setTopicSections((prev) => ({ ...prev, [topic.id]: sections }));
        if (sections.length > 0) setActiveSection(sections[0]);
      } catch (err) {
        console.error(err);
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

  const activeKey = activeQ ? qKey(activeQ.id) : null;
  const activeStatus = activeKey ? statuses[activeKey] ?? "To Do" : "To Do";

  return (
    <div className="flex flex-col h-full bg-surface text-bright font-sans">
      <TopBar
        totalDone={totalDone}
        totalAll={totalAll}
        cachedCount={Object.keys(cached).length}
      />

      <div className="flex flex-1 overflow-hidden">
        <Sidebar
          topics={topics}
          topicSections={topicSections}
          activeTopic={activeTopic}
          activeSection={activeSection}
          expanded={expanded}
          donePerTopic={donePerTopic}
          onTopicClick={handleTopicClick}
          onSectionClick={handleSectionClick}
        />

        <main className="flex-1 flex flex-col overflow-hidden">
          {activeQ ? (
            <QuestionDetail
              activeQ={activeQ}
              activeKey={activeKey}
              activeStatus={activeStatus}
              answer={answer}
              loading={answerLoading}
              error={answerError}
              currentIndex={activeQIndex}
              totalCount={sectionQuestions.length}
              sectionQuestions={sectionQuestions}
              onBack={closeQuestion}
              onSaveStatus={saveStatus}
              onPrev={handlePrev}
              onNext={handleNext}
              onJumpTo={handleJumpTo}
            />
          ) : (
            <QuestionList
              activeSection={activeSection}
              questions={sectionQuestions}
              loading={questionsLoading}
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
