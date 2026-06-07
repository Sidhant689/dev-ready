import { useState, useEffect, useMemo } from "react";
import { X, ChevronRight, RotateCcw, Trophy, CheckCircle, XCircle, Zap } from "lucide-react";
import { fetchRandomQuestions } from "../services/questionService";
import { fetchAnswer } from "../services/questionService";
import { renderMarkdown } from "../utils/markdown";
import TopicIcon from "../components/TopicIcon";

const QUIZ_SIZE = 10;

// Score thresholds
function scoreLabel(correct, total) {
  const pct = (correct / total) * 100;
  if (pct === 100) return { label: "Perfect!", color: "text-success", Icon: Trophy };
  if (pct >= 80)   return { label: "Excellent!",  color: "text-success", Icon: Trophy };
  if (pct >= 60)   return { label: "Good job!",   color: "text-accent",  Icon: Zap };
  if (pct >= 40)   return { label: "Keep going",  color: "text-warning", Icon: Zap };
  return { label: "Keep studying", color: "text-danger", Icon: XCircle };
}

export default function QuizMode({ topics, onClose, user }) {
  const [step, setStep] = useState("setup"); // setup | quiz | results
  const [selectedTopics, setSelectedTopics] = useState([]);
  const [questions, setQuestions] = useState([]);
  const [loading, setLoading] = useState(false);
  const [current, setCurrent] = useState(0);
  const [answers, setAnswers] = useState({}); // qId -> "knew" | "didnt"
  const [revealed, setRevealed] = useState(false);
  const [answerHtml, setAnswerHtml] = useState(null);
  const [answerLoading, setAnswerLoading] = useState(false);

  const q = questions[current];

  useEffect(() => {
    if (!q || !revealed) return;
    setAnswerLoading(true);
    fetchAnswer(q.id)
      .then(content => setAnswerHtml(content ? renderMarkdown(content) : null))
      .catch(() => setAnswerHtml(null))
      .finally(() => setAnswerLoading(false));
  }, [q?.id, revealed]);

  async function startQuiz() {
    setLoading(true);
    try {
      const topicIds = selectedTopics.length > 0 ? selectedTopics.map(Number) : [];
      const qs = await fetchRandomQuestions(topicIds, QUIZ_SIZE);
      if (qs.length === 0) { alert("No questions found. Try selecting different topics."); setLoading(false); return; }
      setQuestions(qs);
      setAnswers({});
      setCurrent(0);
      setRevealed(false);
      setAnswerHtml(null);
      setStep("quiz");
    } catch (e) { alert(e.message); }
    setLoading(false);
  }

  function answer(verdict) {
    setAnswers(prev => ({ ...prev, [q.id]: verdict }));
    if (current + 1 < questions.length) {
      setCurrent(c => c + 1);
      setRevealed(false);
      setAnswerHtml(null);
    } else {
      setStep("results");
    }
  }

  function restart() { setStep("setup"); setSelectedTopics([]); }

  const { correct, total } = useMemo(() => ({
    correct: Object.values(answers).filter(v => v === "knew").length,
    total: questions.length,
  }), [answers, questions]);

  function toggleTopic(id) {
    setSelectedTopics(prev =>
      prev.includes(id) ? prev.filter(t => t !== id) : [...prev, id]
    );
  }

  if (step === "setup") return (
    <div className="fixed inset-0 z-50 flex items-center justify-center p-4" style={{ background: "rgba(0,0,0,0.7)", backdropFilter: "blur(6px)" }}>
      <div className="bg-panel border border-border rounded-2xl w-full max-w-lg" style={{ boxShadow: "var(--shadow-modal)" }}>
        <div className="flex items-center justify-between px-6 py-5 border-b border-border">
          <div className="flex items-center gap-2">
            <div className="w-8 h-8 rounded-lg bg-accent/10 border border-accent/20 text-accent flex items-center justify-center">
              <Zap size={15} strokeWidth={1.8} />
            </div>
            <div>
              <h2 className="text-sm font-bold text-heading">Quiz Mode</h2>
              <p className="text-[11px] text-muted">{QUIZ_SIZE} random questions</p>
            </div>
          </div>
          <button onClick={onClose} className="w-7 h-7 rounded-md text-ghost hover:text-muted hover:bg-hover flex items-center justify-center cursor-pointer transition-colors">
            <X size={14} strokeWidth={2} />
          </button>
        </div>

        <div className="p-6 space-y-5">
          <div>
            <p className="text-xs font-semibold text-soft mb-3">Filter by topic <span className="text-ghost font-normal">(optional — leave empty for all)</span></p>
            <div className="grid grid-cols-2 gap-2">
              {topics.map(t => (
                <button
                  key={t.id}
                  onClick={() => toggleTopic(String(t.id))}
                  className={`flex items-center gap-2 px-3 py-2 rounded-lg border text-xs font-medium transition-all cursor-pointer ${
                    selectedTopics.includes(String(t.id))
                      ? "bg-accent/10 border-accent/40 text-accent"
                      : "bg-hover border-border text-muted hover:border-accent/30 hover:text-primary"
                  }`}
                >
                  <span className="text-muted"><TopicIcon topic={t} size={12} /></span>
                  {t.label}
                </button>
              ))}
            </div>
          </div>

          <div className="bg-hover/40 border border-border rounded-xl p-4 text-xs text-muted space-y-1">
            <p>• {QUIZ_SIZE} random questions from your selection</p>
            <p>• Reveal the answer, then rate yourself</p>
            <p>• See your score and accuracy at the end</p>
          </div>

          <button
            onClick={startQuiz}
            disabled={loading}
            className="w-full h-11 rounded-xl bg-accent hover:bg-accent-hover text-white font-semibold text-sm transition-all cursor-pointer disabled:opacity-60"
            style={{ boxShadow: "0 0 16px rgba(99,102,241,0.25)" }}
          >
            {loading ? "Loading questions…" : `Start Quiz →`}
          </button>
        </div>
      </div>
    </div>
  );

  if (step === "quiz") return (
    <div className="fixed inset-0 z-50 flex flex-col bg-surface" style={{ backdropFilter: "blur(6px)" }}>
      {/* Header */}
      <div className="flex items-center gap-4 px-6 py-4 border-b border-border bg-panel shrink-0">
        <button onClick={onClose} className="w-7 h-7 rounded-md text-ghost hover:text-muted hover:bg-hover flex items-center justify-center cursor-pointer transition-colors">
          <X size={14} strokeWidth={2} />
        </button>
        <div className="flex-1">
          <div className="flex items-center justify-between mb-1.5">
            <span className="text-xs font-semibold text-muted">Q{current + 1} / {questions.length}</span>
            <span className="text-xs text-success font-semibold">
              {Object.values(answers).filter(v => v === "knew").length} correct so far
            </span>
          </div>
          <div className="h-1.5 bg-hover rounded-full overflow-hidden">
            <div className="h-full bg-accent rounded-full transition-all duration-500"
              style={{ width: `${(current / questions.length) * 100}%` }} />
          </div>
        </div>
      </div>

      <div className="flex-1 overflow-y-auto p-6 max-w-3xl mx-auto w-full">
        {/* Question */}
        <div className="bg-panel border border-border rounded-2xl p-6 mb-4">
          <p className="text-[11px] font-semibold text-ghost uppercase tracking-wide mb-3">Question {current + 1}</p>
          <h2 className="text-lg font-semibold text-heading leading-relaxed">{q?.text}</h2>
          {q?.difficulty_levels?.label && (
            <span className={`inline-block mt-3 text-[10px] font-bold px-2 py-0.5 rounded-md uppercase tracking-wide ${
              q.difficulty_levels.label === "Basic" ? "bg-success/10 text-success" :
              q.difficulty_levels.label === "Intermediate" ? "bg-warning/10 text-warning" :
              "bg-danger/10 text-danger"
            }`}>{q.difficulty_levels.label}</span>
          )}
        </div>

        {/* Reveal button */}
        {!revealed ? (
          <button
            onClick={() => setRevealed(true)}
            className="w-full h-12 rounded-xl border-2 border-dashed border-accent/40 text-accent font-semibold text-sm hover:bg-accent/5 transition-all cursor-pointer"
          >
            Reveal Answer
          </button>
        ) : (
          <div className="space-y-4">
            {/* Answer */}
            <div className="bg-panel border border-border rounded-2xl p-6">
              {answerLoading ? (
                <div className="flex items-center gap-2 text-xs text-muted py-4">
                  <div className="w-3 h-3 rounded-full border border-accent border-t-transparent" style={{ animation: "spin 0.8s linear infinite" }} />
                  Loading answer…
                </div>
              ) : answerHtml ? (
                <div className="prose-answer" dangerouslySetInnerHTML={{ __html: answerHtml }} />
              ) : (
                <p className="text-sm text-muted italic">No answer available yet.</p>
              )}
            </div>

            {/* Rate yourself */}
            <div>
              <p className="text-xs font-semibold text-ghost mb-3 uppercase tracking-wide">Did you know this?</p>
              <div className="grid grid-cols-2 gap-3">
                <button
                  onClick={() => answer("knew")}
                  className="flex items-center justify-center gap-2 h-12 rounded-xl bg-success/10 border border-success/30 text-success font-semibold text-sm hover:bg-success/20 transition-all cursor-pointer"
                >
                  <CheckCircle size={16} strokeWidth={2} />
                  Yes, I knew it!
                </button>
                <button
                  onClick={() => answer("didnt")}
                  className="flex items-center justify-center gap-2 h-12 rounded-xl bg-danger/10 border border-danger/30 text-danger font-semibold text-sm hover:bg-danger/20 transition-all cursor-pointer"
                >
                  <XCircle size={16} strokeWidth={2} />
                  No, I didn&apos;t
                </button>
              </div>
            </div>
          </div>
        )}
      </div>
    </div>
  );

  // Results
  const { label: scoreText, color: scoreColor, Icon: ScoreIcon } = scoreLabel(correct, total);
  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center p-4" style={{ background: "rgba(0,0,0,0.7)", backdropFilter: "blur(6px)" }}>
      <div className="bg-panel border border-border rounded-2xl w-full max-w-md" style={{ boxShadow: "var(--shadow-modal)" }}>
        <div className="p-8 text-center">
          <div className={`w-16 h-16 rounded-2xl mx-auto mb-4 flex items-center justify-center ${scoreColor.replace("text-", "bg-")}/10 border ${scoreColor.replace("text-", "border-")}/20`}>
            <ScoreIcon size={28} strokeWidth={1.5} className={scoreColor} />
          </div>
          <h2 className={`text-2xl font-bold mb-1 ${scoreColor}`}>{scoreText}</h2>
          <p className="text-5xl font-bold text-heading tabular-nums my-4">{correct}<span className="text-2xl text-muted">/{total}</span></p>
          <p className="text-sm text-muted">{Math.round((correct / total) * 100)}% accuracy</p>

          <div className="grid grid-cols-2 gap-3 mt-6">
            {questions.map((q, i) => (
              <div key={q.id} className={`flex items-center gap-2 px-3 py-2 rounded-lg text-xs ${
                answers[q.id] === "knew" ? "bg-success/10 border border-success/20 text-success" : "bg-danger/10 border border-danger/20 text-danger"
              }`}>
                {answers[q.id] === "knew"
                  ? <CheckCircle size={11} strokeWidth={2.5} />
                  : <XCircle size={11} strokeWidth={2.5} />}
                <span className="truncate">{q.text.slice(0, 35)}{q.text.length > 35 ? "…" : ""}</span>
              </div>
            ))}
          </div>

          <div className="flex gap-3 mt-6">
            <button onClick={restart} className="flex-1 flex items-center justify-center gap-2 h-10 rounded-xl border border-border bg-hover text-sm font-semibold text-muted hover:text-primary cursor-pointer transition-colors">
              <RotateCcw size={14} strokeWidth={2} />
              Try again
            </button>
            <button onClick={onClose} className="flex-1 h-10 rounded-xl bg-accent hover:bg-accent-hover text-white text-sm font-semibold cursor-pointer transition-colors">
              Done
            </button>
          </div>
        </div>
      </div>
    </div>
  );
}
