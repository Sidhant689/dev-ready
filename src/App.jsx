import { useState, useEffect, useMemo, useCallback } from "react";
import { useAuth } from "./hooks/useAuth";
import { useStatuses } from "./hooks/useStatuses";
import { useAnswerCache } from "./hooks/useAnswerCache";
import { useStreak } from "./hooks/useStreak";
import { useWeeklyGoal } from "./hooks/useWeeklyGoal";
import { useBookmarks } from "./hooks/useBookmarks";
import { useUserSettings } from "./hooks/useUserSettings";
import { qKey } from "./utils/helpers";
import { fetchTopics, fetchSections, fetchQuestions, fetchQuestionById } from "./services/questionService";
import { supabase } from "./config/supabaseClient";
import TopBar from "./components/TopBar";
import Sidebar from "./components/Sidebar";
import QuestionList from "./components/QuestionList";
import QuestionDetail from "./components/QuestionDetail";
import Dashboard from "./pages/Dashboard";
import QuizMode from "./pages/QuizMode";
import InterviewSim from "./pages/InterviewSim";
import SectionPicker from "./pages/SectionPicker";
import LandingPage from "./pages/LandingPage";
import AuthModal from "./components/AuthModal";
import Toast from "./components/Toast";
import GlobalSearch from "./components/GlobalSearch";
import UserSettings from "./components/UserSettings";
import NotificationDrawer from "./components/NotificationDrawer";
import { useNotifications } from "./hooks/useNotifications";

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
  const [sidebarOpen, setSidebarOpen] = useState(false);
  const [searchOpen, setSearchOpen] = useState(false);
  const [settingsOpen, setSettingsOpen] = useState(false);
  const [quizOpen, setQuizOpen] = useState(false);
  const [simOpen, setSimOpen] = useState(false);
  const [notifOpen, setNotifOpen] = useState(false);
  const { notifications, unreadCount, loading: notifLoading, loadAll: loadNotifs, markRead, markAllRead } = useNotifications(user);
  const [isAdmin, setIsAdmin] = useState(false);
  useEffect(() => {
    if (!user?.id) { setIsAdmin(false); return; }
    supabase.from("users").select("role").eq("id", user.id).single()
      .then(({ data }) => setIsAdmin(data?.role === "admin"))
      .catch(() => {});
  }, [user?.id]);

  const [sectionQuestions, setSectionQuestions] = useState([]);
  const [questionsLoading, setQuestionsLoading] = useState(false);
  const [questionMeta, setQuestionMeta] = useState({});

  const { settings, updateSetting } = useUserSettings(user);
  const theme = settings.theme;

  const { statuses, saveStatus } = useStatuses(user);
  const { bookmarks, isBookmarked, toggleBookmark } = useBookmarks(user);
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
  const { weekDone, recordWeekActivity } = useWeeklyGoal();
  const weekGoal = settings.weekly_goal;

  const [toast, setToast] = useState(null);
  const [celebrated, setCelebrated] = useState(() => {
    try { return new Set(JSON.parse(localStorage.getItem("devready_celebrated") || "[]")); }
    catch { return new Set(); }
  });

  useEffect(() => {
    fetchTopics().then(setTopics).catch(console.error);
  }, []);

  // Handle ?q=ID share URLs
  useEffect(() => {
    const params = new URLSearchParams(window.location.search);
    const qId = params.get("q");
    if (!qId) return;
    // Remove param from URL without reload
    const url = new URL(window.location.href);
    url.searchParams.delete("q");
    window.history.replaceState({}, "", url.toString());
    // Navigate to the shared question
    fetchQuestionById(Number(qId)).then(async (qData) => {
      if (!qData) return;
      const sectionId = qData.sections?.id;
      if (!sectionId) return;
      const topicId = qData.sections?.topic_id;
      const sections = await fetchSections(topicId);
      setTopicSections(prev => ({ ...prev, [topicId]: sections }));
      const foundSection = sections.find(s => s.id === sectionId);
      const foundTopic = topics.find(t => t.id === topicId);
      if (foundSection) {
        if (foundTopic) setActiveTopic(foundTopic);
        setActiveSection(foundSection);
        openQuestion(foundSection, { id: qData.id, text: qData.text, difficulty_levels: qData.difficulty_levels });
      }
    }).catch(() => {});
  // Run once after topics load
  // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [topics.length]);

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
    const qObj = {
      id: question.id,
      text: question.text,
      difficulty: question.difficulty_levels?.label || "Basic",
      difficulty_id: question.difficulty_id,
      section_label: section.label,
      topic_label: activeTopic?.label,
    };
    setActiveQ(qObj);
    loadAnswer(question.id, k);
    setSidebarOpen(false);
    // Save last visited for Dashboard "continue" widget
    try {
      localStorage.setItem("devready_last_q", JSON.stringify({
        questionId: question.id,
        questionText: question.text,
        sectionId: section.id,
        sectionLabel: section.label,
        topicLabel: activeTopic?.label || "",
      }));
    } catch { /* ignore */ }
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

  const handleTopicClick = (topic) => {
    setActiveTopic(topic);
    setActiveSection(null);
    closeQuestion();
    setSidebarOpen(false);
  };

  const handleSectionClick = (section) => {
    setActiveSection(section);
    closeQuestion();
    setSidebarOpen(false);
  };

  const activeKey = activeQ ? qKey(activeQ.id) : null;
  const activeStatus = activeKey ? statuses[activeKey] ?? "To Do" : "To Do";

  // Navigate to a question from bookmark/dashboard (has sectionId stored)
  const handleBookmarkNav = useCallback(async (item) => {
    const sectionId = item.sectionId || item.section_id;
    if (!sectionId) return;

    let foundSection = null;
    let foundTopic = null;

    for (const [topicId, sections] of Object.entries(topicSections)) {
      const sec = sections.find((s) => s.id === sectionId);
      if (sec) { foundSection = sec; foundTopic = topics.find((t) => t.id === Number(topicId)); break; }
    }

    if (!foundSection) {
      // Try every topic's sections (load on demand)
      for (const topic of topics) {
        if (topicSections[topic.id]) continue;
        const sections = await fetchSections(topic.id);
        setTopicSections((prev) => ({ ...prev, [topic.id]: sections }));
        const sec = sections.find((s) => s.id === sectionId);
        if (sec) { foundSection = sec; foundTopic = topic; break; }
      }
    }

    if (foundSection) {
      if (foundTopic) { setActiveTopic(foundTopic); setExpanded((prev) => ({ ...prev, [foundTopic.id]: true })); }
      setActiveSection(foundSection);
      const qId = item.questionId || item.question_id;
      const qText = item.questionText || item.question_text || "";
      openQuestion(foundSection, { id: qId, text: qText, difficulty_levels: { label: "Basic" } });
    }
  }, [topics, topicSections, openQuestion]);

  return (
    <div className="flex flex-col h-full bg-surface text-bright font-sans">
      <TopBar
        totalDone={totalDone}
        totalAll={totalAll}
        streak={streak}
        user={user}
        isGuest={isGuest}
        onMenuClick={() => setSidebarOpen((v) => !v)}
        onLogoClick={() => { setActiveTopic(null); setActiveSection(null); closeQuestion(); }}
        onSearchOpen={() => setSearchOpen(true)}
        onSettingsOpen={() => setSettingsOpen(true)}
        unreadCount={unreadCount}
        onNotifOpen={() => setNotifOpen(true)}
        onSignIn={() => onOpenAuth("signin")}
        onSignOut={onSignOut}
        theme={theme}
        onToggleTheme={() => updateSetting("theme", theme === "dark" ? "light" : "dark")}
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
            activeTopic={activeTopic}
            donePerTopic={donePerTopic}
            streak={streak}
            weekDone={weekDone}
            weekGoal={weekGoal}
            bookmarks={bookmarks}
            onTopicClick={handleTopicClick}
            onHomeClick={() => { setActiveTopic(null); setActiveSection(null); closeQuestion(); setSidebarOpen(false); }}
            onBookmarkClick={handleBookmarkNav}
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
              onBack={() => { closeQuestion(); }}
              onSaveStatus={handleSaveStatus}
              onPrev={handlePrev}
              onNext={handleNext}
              onJumpTo={handleJumpTo}
              isGuest={isGuest}
              onOpenAuth={onOpenAuth}
              user={user}
              isBookmarked={isBookmarked(activeQ.id)}
              onToggleBookmark={toggleBookmark}
              isAdmin={isAdmin}
            />
          ) : activeSection ? (
            <QuestionList
              activeSection={activeSection}
              activeTopic={activeTopic}
              questions={sectionQuestions}
              loading={questionsLoading}
              statuses={statuses}
              cached={cached}
              onOpenQuestion={openQuestion}
              onBack={() => setActiveSection(null)}
              isGuest={isGuest}
              onOpenAuth={onOpenAuth}
            />
          ) : activeTopic ? (
            <SectionPicker
              topic={activeTopic}
              statuses={statuses}
              questionMeta={questionMeta}
              onSelectSection={handleSectionClick}
            />
          ) : !isGuest ? (
            <Dashboard
              user={user}
              topics={topics}
              donePerTopic={donePerTopic}
              totalDone={totalDone}
              totalAll={totalAll}
              streak={streak}
              weekDone={weekDone}
              weekGoal={weekGoal}
              bookmarks={bookmarks}
              onSelectTopic={handleTopicClick}
              onSelectBookmark={handleBookmarkNav}
              onStartQuiz={() => setQuizOpen(true)}
              onStartInterview={() => setSimOpen(true)}
            />
          ) : (
            <div className="flex flex-col items-center justify-center h-full text-center px-8">
              <div className="w-14 h-14 rounded-2xl bg-accent/10 border border-accent/20 flex items-center justify-center mb-4 text-2xl">
                👈
              </div>
              <p className="text-base font-semibold text-soft mb-1">Select a topic to begin</p>
              <p className="text-sm text-muted max-w-xs">
                Choose any topic from the sidebar to see questions and start your preparation.
              </p>
            </div>
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

      <NotificationDrawer
        open={notifOpen}
        onClose={() => setNotifOpen(false)}
        notifications={notifications}
        loading={notifLoading}
        onMarkRead={markRead}
        onMarkAllRead={markAllRead}
        unreadCount={unreadCount}
        onLoad={loadNotifs}
      />

      {quizOpen && (
        <QuizMode
          topics={topics}
          user={user}
          onClose={() => setQuizOpen(false)}
        />
      )}

      {simOpen && (
        <InterviewSim
          topics={topics}
          user={user}
          onClose={() => setSimOpen(false)}
        />
      )}

      {settingsOpen && !isGuest && (
        <UserSettings
          user={user}
          theme={theme}
          onToggleTheme={() => updateSetting("theme", theme === "dark" ? "light" : "dark")}
          weekGoal={weekGoal}
          onSetWeekGoal={(n) => updateSetting("weekly_goal", n)}
          onClose={() => setSettingsOpen(false)}
          onSignOut={onSignOut}
        />
      )}
    </div>
  );
}

/* ── Root ────────────────────────────────────────────────────────── */
export default function App() {
  const { user, isLoading, isGuest, signInWithEmail, signUpWithEmail, signInWithGoogle, signInWithGitHub, signOut } = useAuth();
  const { route, goToApp } = useRoute(user, isLoading);
  const [authModal, setAuthModal] = useState(null);

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
