import { useState, useEffect, useMemo, useCallback } from "react";
import { useAuth } from "./hooks/useAuth";
import { useStatuses } from "./hooks/useStatuses";
import { useAnswerCache } from "./hooks/useAnswerCache";
import { useStreak } from "./hooks/useStreak";
import { useWeeklyGoal } from "./hooks/useWeeklyGoal";
import { qKey } from "./utils/helpers";
import { fetchTopics, fetchSections, fetchQuestions } from "./services/questionService";
import TopBar from "./components/TopBar";
import Sidebar from "./components/Sidebar";
import QuestionList from "./components/QuestionList";
import QuestionDetail from "./components/QuestionDetail";
import LandingPage from "./pages/LandingPage";
import AuthModal from "./components/AuthModal";
import Toast from "./components/Toast";
import GlobalSearch from "./components/GlobalSearch";

/* ── Simple view router ──────────────────────────────────────────── */
function useRoute(user, isLoading) {
  const [route, setRoute] = useState(() =>
    localStorage.getItem("devready_visited") ? "app" : "landing"
  );

  // When user logs in from any view, move them to app
  useEffect(() => {
    if (!isLoading && user) {
      localStorage.setItem("devready_visited", "1");
      setRoute("app");
    }
  }, [user, isLoading]);

  return {
    route,
    goToApp: () => {
      localStorage.setItem("devready_visited", "1");
      setRoute("app");
    },
    goToLanding: () => setRoute("landing"),
  };
}

/* ── Main App shell (shown after entering the app) ───────────────── */
function AppShell({ user, isGuest, onOpenAuth, onSignOut }) {
  const [topics, setTopics] = useState([]);
  const [activeTopic, setActiveTopic] = useState(null);
  const [activeSection, setActiveSection] = useState(null);
  const [topicSections, setTopicSections] = useState({});
  const [activeQ, setActiveQ] = useState(null);
  const [expanded, setExpanded] = useState({});
  const [sidebarOpen, setSidebarOpen] = useState(false);
  const [searchOpen, setSearchOpen] = useState(false);

  const [sectionQuestions, setSectionQuestions] = useState([]);
  const [questionsLoading, setQuestionsLoading] = useState(false);
  const [questionMeta, setQuestionMeta] = useState({});

  // Pass user into useStatuses so it knows whether to use cloud or localStorage
  const { statuses, saveStatus } = useStatuses(user);
  const { cached, answer, loading: answerLoading, error: answerError, loadAnswer, clearAnswer } = useAnswerCache();

  // Global search keyboard shortcut
  useEffect(() => {
    const handler = (e) => {
      if ((e.metaKey || e.ctrlKey) && e.key === "k") {
        e.preventDefault();
        setSearchOpen((v) => !v);
      }
    };
    window.addEventListener("keydown", handler);
    return () => window.removeEventListener("keydown", handler);
  }, []);

  const { streak, recordActivity } = useStreak();
  const { weekDone, weekGoal, recordWeekActivity } = useWeeklyGoal();

  const [toast, setToast] = useState(null);
  const [celebrated, setCelebrated] = useState(() => {
    try { return new Set(JSON.parse(localStorage.getItem("devready_celebrated") || "[]")); }
    catch { return new Set(); }
  });

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

  useEffect(() => {
    if (!activeSection) { setSectionQuestions([]); return; }
    setQuestionsLoading(true);
    fetchQuestions(activeSection.id)
      .then((data) => { setSectionQuestions(data); setQuestionsLoading(false); })
      .catch(() => setQuestionsLoading(false));
  }, [activeSection?.id]);

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

  // Topic completion toasts
  useEffect(() => {
    topics.forEach((topic) => {
      const done = donePerTopic[topic.id] || 0;
      const total = topic.total_count || 0;
      if (total > 0 && done === total && !celebrated.has(topic.id)) {
        setCelebrated((prev) => {
          const next = new Set(prev);
          next.add(topic.id);
          localStorage.setItem("devready_celebrated", JSON.stringify([...next]));
          return next;
        });
        setToast({ message: `${topic.label} complete!`, sub: `You finished all ${total} questions.` });
      }
    });
  }, [donePerTopic, topics, celebrated]);

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
    setSidebarOpen(false);
  }, [activeTopic?.label, loadAnswer]);

  const closeQuestion = () => { setActiveQ(null); clearAnswer(); };

  function handleSaveStatus(key, status) {
    console.log("[handleSaveStatus] key:", key, "status:", status, "user:", user ? user.id : "NO USER");
    saveStatus(key, status);
    if (status === "Done") {
      recordActivity();
      recordWeekActivity();
    }
  }

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

  const handleSearchSelect = useCallback(async (item) => {
    // item has section_id from the search query. Navigate to the right section/topic.
    const sectionId = item.section_id;
    if (!sectionId) return;

    // Find if we already have the section loaded
    let foundTopic = null;
    let foundSection = null;

    for (const [topicId, sections] of Object.entries(topicSections)) {
      const sec = sections.find((s) => s.id === sectionId);
      if (sec) {
        foundSection = sec;
        foundTopic = topics.find((t) => t.id === Number(topicId));
        break;
      }
    }

    if (!foundSection) {
      // Need to load sections for the topic from the item's nested data
      const topicId = item.sections?.topic_id;
      if (topicId) {
        const sections = await fetchSections(topicId);
        setTopicSections((prev) => ({ ...prev, [topicId]: sections }));
        foundSection = sections.find((s) => s.id === sectionId);
        foundTopic = topics.find((t) => t.id === topicId);
      }
    }

    if (foundSection) {
      if (foundTopic) { setActiveTopic(foundTopic); setExpanded((prev) => ({ ...prev, [foundTopic.id]: true })); }
      setActiveSection(foundSection);
      // Build a minimal question object for openQuestion
      openQuestion(foundSection, { id: item.id, text: item.text, difficulty_levels: { label: "Basic" }, difficulty_id: item.difficulty_id });
    }
  }, [topics, topicSections, openQuestion]);

  const handleTopicClick = async (topic) => {
    setExpanded((prev) => ({ ...prev, [topic.id]: !prev[topic.id] }));
    setActiveTopic(topic);
    closeQuestion();
    if (!topicSections[topic.id]) {
      try {
        const sections = await fetchSections(topic.id);
        setTopicSections((prev) => ({ ...prev, [topic.id]: sections }));
        if (sections.length > 0) setActiveSection(sections[0]);
      } catch (err) { console.error(err); }
    } else if (topicSections[topic.id].length > 0) {
      setActiveSection(topicSections[topic.id][0]);
    }
  };

  const handleSectionClick = (topic, section) => {
    setActiveTopic(topic);
    setActiveSection(section);
    closeQuestion();
    setSidebarOpen(false);
  };

  const activeKey = activeQ ? qKey(activeQ.id) : null;
  const activeStatus = activeKey ? statuses[activeKey] ?? "To Do" : "To Do";

  return (
    <div className="flex flex-col h-full bg-surface text-bright font-sans">
      <TopBar
        totalDone={totalDone}
        totalAll={totalAll}
        streak={streak}
        user={user}
        isGuest={isGuest}
        onMenuClick={() => setSidebarOpen(true)}
        onSearchOpen={() => setSearchOpen(true)}
        onSignIn={() => onOpenAuth("signin")}
        onSignOut={onSignOut}
      />

      <div className="flex flex-1 overflow-hidden relative">
        {/* Mobile overlay */}
        {sidebarOpen && (
          <div
            className="absolute inset-0 z-10 bg-black/50 md:hidden"
            onClick={() => setSidebarOpen(false)}
          />
        )}

        {/* Sidebar */}
        <div
          className={`
            absolute z-20 inset-y-0 left-0 transform transition-transform duration-300
            md:relative md:translate-x-0 md:z-auto
            ${sidebarOpen ? "translate-x-0" : "-translate-x-full"}
          `}
        >
          <Sidebar
            topics={topics}
            topicSections={topicSections}
            activeTopic={activeTopic}
            activeSection={activeSection}
            expanded={expanded}
            donePerTopic={donePerTopic}
            streak={streak}
            weekDone={weekDone}
            weekGoal={weekGoal}
            onTopicClick={handleTopicClick}
            onSectionClick={handleSectionClick}
          />
        </div>

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
              onSaveStatus={handleSaveStatus}
              onPrev={handlePrev}
              onNext={handleNext}
              onJumpTo={handleJumpTo}
              isGuest={isGuest}
              onOpenAuth={onOpenAuth}
              user={user}
            />
          ) : (
            <QuestionList
              activeSection={activeSection}
              questions={sectionQuestions}
              loading={questionsLoading}
              statuses={statuses}
              cached={cached}
              onOpenQuestion={openQuestion}
              isGuest={isGuest}
              onOpenAuth={onOpenAuth}
            />
          )}
        </main>
      </div>

      {toast && (
        <Toast
          message={toast.message}
          sub={toast.sub}
          onDismiss={() => setToast(null)}
        />
      )}

      {searchOpen && (
        <GlobalSearch
          onSelectQuestion={handleSearchSelect}
          onClose={() => setSearchOpen(false)}
          isGuest={isGuest}
          onOpenAuth={onOpenAuth}
        />
      )}
    </div>
  );
}

/* ── Root ────────────────────────────────────────────────────────── */
export default function App() {
  const { user, isLoading, isGuest, signInWithEmail, signUpWithEmail, signInWithGoogle, signInWithGitHub, signOut } = useAuth();
  const { route, goToApp, goToLanding } = useRoute(user, isLoading);
  const [authModal, setAuthModal] = useState(null); // null | "signin" | "signup"

  function openAuth(mode) { setAuthModal(mode); }
  function closeAuth() { setAuthModal(null); }

  async function handleAuthSuccess() {
    closeAuth();
    // useRoute's useEffect will detect user change and navigate to app
  }

  // Still waiting for Supabase session
  if (isLoading) {
    return (
      <div className="h-full bg-surface flex items-center justify-center">
        <div className="w-6 h-6 rounded-full border-2 border-border border-t-accent"
             style={{ animation: 'spin 0.8s linear infinite' }} />
      </div>
    );
  }

  return (
    <>
      {route === "landing" ? (
        <LandingPage
          onGetStarted={() => goToApp()}
          onSignIn={() => openAuth("signin")}
        />
      ) : (
        <AppShell
          user={user}
          isGuest={isGuest}
          onOpenAuth={openAuth}
          onSignOut={signOut}
        />
      )}

      {authModal && (
        <AuthModal
          mode={authModal}
          onClose={closeAuth}
          onSuccess={handleAuthSuccess}
          signInWithEmail={signInWithEmail}
          signUpWithEmail={signUpWithEmail}
          signInWithGoogle={signInWithGoogle}
          signInWithGitHub={signInWithGitHub}
        />
      )}
    </>
  );
}
