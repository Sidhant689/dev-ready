import { useState, useEffect, useRef, useCallback } from "react";
import { X, Timer, ChevronRight, RotateCcw, Award, AlertCircle, Pause, Play, SkipForward } from "lucide-react";
import { fetchRandomQuestions } from "../services/questionService";
import { fetchAnswer } from "../services/questionService";
import { renderMarkdown } from "../utils/markdown";
import TopicIcon from "../components/TopicIcon";

const PRESETS = [
  { label: "Quick (5 min)", questions: 5, seconds: 300 },
  { label: "Standard (15 min)", questions: 10, seconds: 900 },
  { label: "Full round (30 min)", questions: 15, seconds: 1800 },
];

function fmt(s) {
  const m = Math.floor(s / 60).toString().padStart(2, "0");
  const sec = (s % 60).toString().padStart(2, "0");
  return `${m}:${sec}`;
}

export default function InterviewSim({ topics, onClose, user }) {
  const [step, setStep] = useState("setup"); // setup | sim | results
  const [preset, setPreset] = useState(1);
  const [selectedTopics, setSelectedTopics] = useState([]);
  const [questions, setQuestions] = useState([]);
  const [loading, setLoading] = useState(false);

  // Sim state
  const [current, setCurrent] = useState(0);
  const [timeLeft, setTimeLeft] = useState(0);
  const [totalTime, setTotalTime] = useState(0);
  const [paused, setPaused] = useState(false);
  const [revealed, setRevealed] = useState(false);
  const [answerHtml, setAnswerHtml] = useState(null);
  const [answerLoading, setAnswerLoading] = useState(false);
  const [skipped, setSkipped] = useState(new Set());
  const [finished, setFinished] = useState(false);
  const timerRef = useRef(null);

  const q = questions[current];

  // Timer
  useEffect(() => {
    if (step !== "sim" || paused || finished) return;
    timerRef.current = setInterval(() => {
      setTimeLeft(t => {
        if (t <= 1) { clearInterval(timerRef.current); setFinished(true); setStep("results"); return 0; }
        return t - 1;
      });
    }, 1000);
    return () => clearInterval(timerRef.current);
  }, [step, paused, finished]);

  // Load answer on reveal
  useEffect(() => {
    if (!q || !revealed) return;
    setAnswerLoading(true);
    fetchAnswer(q.id)
      .then(c => setAnswerHtml(c ? renderMarkdown(c) : null))
      .catch(() => setAnswerHtml(null))
      .finally(() => setAnswerLoading(false));
  }, [q?.id, revealed]);

  async function startSim() {
    setLoading(true);
    try {
      const p = PRESETS[preset];
      const topicIds = selectedTopics.length > 0 ? selectedTopics.map(Number) : [];
      const qs = await fetchRandomQuestions(topicIds, p.questions);
      if (qs.length === 0) { alert("No questions found for selected topics."); setLoading(false); return; }
      setQuestions(qs);
      setCurrent(0);
      setTimeLeft(p.seconds);
      setTotalTime(p.seconds);
      setSkipped(new Set());
      setRevealed(false);
      setAnswerHtml(null);
      setPaused(false);
      setFinished(false);
      setStep("sim");
    } catch (e) { alert(e.message); }
    setLoading(false);
  }

  function next(skip = false) {
    if (skip) setSkipped(prev => new Set([...prev, q.id]));
    if (current + 1 < questions.length) {
      setCurrent(c => c + 1);
      setRevealed(false);
      setAnswerHtml(null);
    } else {
      clearInterval(timerRef.current);
      setStep("results");
    }
  }

  function togglePause() { setPaused(p => !p); }
  function restart() { setStep("setup"); setSelectedTopics([]); }
  function toggleTopic(id) {
    setSelectedTopics(prev => prev.includes(id) ? prev.filter(t => t !== id) : [...prev, id]);
  }

  const answered = questions.length - skipped.size - (step === "sim" ? (questions.length - current - (revealed ? 0 : 0)) : 0);
  const timeUsed = totalTime - timeLeft;
  const timePct = totalTime > 0 ? Math.min(100, (timeUsed / totalTime) * 100) : 0;
  const timerDanger = timeLeft < 60 && step === "sim";

  // Setup screen
  if (step === "setup") return (
    <div className="fixed inset-0 z-50 flex items-center justify-center p-4" style={{ background: "rgba(0,0,0,0.7)", backdropFilter: "blur(6px)" }}>
      <div className="bg-panel border border-border rounded-2xl w-full max-w-lg" style={{ boxShadow: "var(--shadow-modal)" }}>
        <div className="flex items-center justify-between px-6 py-5 border-b border-border">
          <div className="flex items-center gap-2">
            <div className="w-8 h-8 rounded-lg bg-warning/10 border border-warning/20 text-warning flex items-center justify-center">
              <Timer size={15} strokeWidth={1.8} />
            </div>
            <div>
              <h2 className="text-sm font-bold text-heading">Interview Simulation</h2>
              <p className="text-[11px] text-muted">Timed mock interview</p>
            </div>
          </div>
          <button onClick={onClose} className="w-7 h-7 rounded-md text-ghost hover:text-muted hover:bg-hover flex items-center justify-center cursor-pointer transition-colors">
            <X size={14} strokeWidth={2} />
          </button>
        </div>

        <div className="p-6 space-y-5">
          {/* Preset */}
          <div>
            <p className="text-xs font-semibold text-soft mb-3">Session format</p>
            <div className="flex gap-2">
              {PRESETS.map((p, i) => (
                <button key={i} onClick={() => setPreset(i)}
                  className={`flex-1 py-3 px-2 rounded-xl border text-xs font-semibold text-center transition-all cursor-pointer ${
                    preset === i ? "bg-warning/10 border-warning/40 text-warning" : "bg-hover border-border text-muted hover:border-warning/30 hover:text-primary"
                  }`}>
                  {p.label}
                </button>
              ))}
            </div>
          </div>

          {/* Topics */}
          <div>
            <p className="text-xs font-semibold text-soft mb-3">Focus topics <span className="text-ghost font-normal">(optional)</span></p>
            <div className="grid grid-cols-2 gap-2">
              {topics.map(t => (
                <button key={t.id} onClick={() => toggleTopic(String(t.id))}
                  className={`flex items-center gap-2 px-3 py-2 rounded-lg border text-xs font-medium transition-all cursor-pointer ${
                    selectedTopics.includes(String(t.id))
                      ? "bg-warning/10 border-warning/40 text-warning"
                      : "bg-hover border-border text-muted hover:border-warning/30 hover:text-primary"
                  }`}>
                  <span className="text-muted"><TopicIcon topic={t} size={12} /></span>
                  {t.label}
                </button>
              ))}
            </div>
          </div>

          <div className="bg-hover/40 border border-border rounded-xl p-4 text-xs text-muted space-y-1">
            <p>• {PRESETS[preset].questions} questions, {fmt(PRESETS[preset].seconds)} time limit</p>
            <p>• Pause anytime — timer stops while paused</p>
            <p>• Skip questions and revisit at end of time</p>
          </div>

          <button onClick={startSim} disabled={loading}
            className="w-full h-11 rounded-xl bg-warning hover:bg-warning/90 text-white font-semibold text-sm transition-all cursor-pointer disabled:opacity-60"
            style={{ boxShadow: "0 0 16px rgba(245,158,11,0.25)" }}>
            {loading ? "Preparing session…" : `Start Interview →`}
          </button>
        </div>
      </div>
    </div>
  );

  // Sim screen
  if (step === "sim") return (
    <div className="fixed inset-0 z-50 flex flex-col bg-surface">
      {/* Header bar */}
      <div className="flex items-center gap-4 px-6 py-4 border-b border-border bg-panel shrink-0">
        <button onClick={onClose} className="w-7 h-7 rounded-md text-ghost hover:text-muted hover:bg-hover flex items-center justify-center cursor-pointer transition-colors">
          <X size={14} strokeWidth={2} />
        </button>

        {/* Progress */}
        <div className="flex-1">
          <div className="flex items-center justify-between mb-1.5">
            <span className="text-xs font-semibold text-muted">Q{current + 1}/{questions.length}</span>
            <span className={`font-mono text-sm font-bold tabular-nums ${timerDanger ? "text-danger" : "text-heading"}`}
              style={timerDanger ? { animation: "pulse 1s ease-in-out infinite" } : {}}>
              {fmt(timeLeft)}
            </span>
          </div>
          <div className="h-1.5 bg-hover rounded-full overflow-hidden">
            <div className={`h-full rounded-full transition-all duration-1000 ${timerDanger ? "bg-danger" : "bg-warning"}`}
              style={{ width: `${100 - timePct}%` }} />
          </div>
        </div>

        <button onClick={togglePause}
          className="w-8 h-8 rounded-lg bg-hover border border-border text-muted hover:text-primary flex items-center justify-center cursor-pointer transition-colors">
          {paused ? <Play size={14} strokeWidth={2} /> : <Pause size={14} strokeWidth={2} />}
        </button>
      </div>

      {/* Pause overlay */}
      {paused && (
        <div className="absolute inset-0 z-60 flex items-center justify-center" style={{ background: "rgba(0,0,0,0.6)", backdropFilter: "blur(8px)" }}>
          <div className="text-center space-y-4">
            <div className="w-16 h-16 rounded-2xl bg-panel border border-border flex items-center justify-center mx-auto">
              <Pause size={28} strokeWidth={1.5} className="text-muted" />
            </div>
            <p className="text-lg font-bold text-heading">Interview Paused</p>
            <p className="text-sm text-muted">Timer is stopped</p>
            <button onClick={togglePause}
              className="flex items-center gap-2 px-6 py-3 rounded-xl bg-warning text-white font-semibold text-sm cursor-pointer mx-auto">
              <Play size={14} strokeWidth={2} />
              Resume
            </button>
          </div>
        </div>
      )}

      <div className="flex-1 overflow-y-auto p-6 max-w-3xl mx-auto w-full">
        <div className="bg-panel border border-border rounded-2xl p-6 mb-4">
          <div className="flex items-start justify-between gap-4 mb-4">
            <p className="text-[11px] font-semibold text-ghost uppercase tracking-wide">Question {current + 1}</p>
            {skipped.has(q?.id) && (
              <span className="text-[10px] font-bold px-2 py-0.5 rounded-md bg-warning/10 text-warning border border-warning/20">Skipped</span>
            )}
          </div>
          <h2 className="text-lg font-semibold text-heading leading-relaxed">{q?.text}</h2>
          {q?.difficulty_levels?.label && (
            <span className={`inline-block mt-3 text-[10px] font-bold px-2 py-0.5 rounded-md uppercase tracking-wide ${
              q.difficulty_levels.label === "Basic" ? "bg-success/10 text-success" :
              q.difficulty_levels.label === "Intermediate" ? "bg-warning/10 text-warning" :
              "bg-danger/10 text-danger"
            }`}>{q.difficulty_levels.label}</span>
          )}
        </div>

        {/* Actions */}
        {!revealed ? (
          <div className="grid grid-cols-2 gap-3">
            <button onClick={() => next(true)}
              className="flex items-center justify-center gap-2 h-11 rounded-xl border border-border bg-hover text-sm font-semibold text-muted hover:text-primary cursor-pointer transition-colors">
              <SkipForward size={14} strokeWidth={2} />
              Skip
            </button>
            <button onClick={() => setRevealed(true)}
              className="flex items-center justify-center gap-2 h-11 rounded-xl bg-warning hover:bg-warning/90 text-white font-semibold text-sm cursor-pointer transition-colors">
              Reveal Answer
              <ChevronRight size={14} strokeWidth={2} />
            </button>
          </div>
        ) : (
          <div className="space-y-4">
            <div className="bg-panel border border-border rounded-2xl p-6">
              {answerLoading ? (
                <div className="flex items-center gap-2 text-xs text-muted py-4">
                  <div className="w-3 h-3 rounded-full border border-warning border-t-transparent" style={{ animation: "spin 0.8s linear infinite" }} />
                  Loading answer…
                </div>
              ) : answerHtml ? (
                <div className="prose-answer" dangerouslySetInnerHTML={{ __html: answerHtml }} />
              ) : (
                <p className="text-sm text-muted italic">No answer available yet.</p>
              )}
            </div>
            <button onClick={() => next(false)}
              className="w-full flex items-center justify-center gap-2 h-11 rounded-xl bg-accent hover:bg-accent-hover text-white font-semibold text-sm cursor-pointer transition-colors">
              {current + 1 < questions.length ? <>Next Question <ChevronRight size={14} strokeWidth={2} /></> : "Finish Interview"}
            </button>
          </div>
        )}
      </div>
    </div>
  );

  // Results
  const answered2 = questions.length - skipped.size;
  const skippedCount = skipped.size;
  const timeUsedFinal = totalTime - timeLeft;
  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center p-4" style={{ background: "rgba(0,0,0,0.7)", backdropFilter: "blur(6px)" }}>
      <div className="bg-panel border border-border rounded-2xl w-full max-w-md max-h-[90vh] overflow-y-auto" style={{ boxShadow: "var(--shadow-modal)" }}>
        <div className="p-8">
          <div className="text-center mb-6">
            <div className="w-16 h-16 rounded-2xl mx-auto mb-4 bg-warning/10 border border-warning/20 flex items-center justify-center">
              <Award size={28} strokeWidth={1.5} className="text-warning" />
            </div>
            <h2 className="text-2xl font-bold text-heading mb-1">Interview Complete</h2>
            <p className="text-sm text-muted">
              {timeLeft === 0 ? "Time's up!" : `Finished with ${fmt(timeLeft)} to spare`}
            </p>
          </div>

          <div className="grid grid-cols-3 gap-3 mb-6">
            {[
              { label: "Questions", value: questions.length, color: "text-accent" },
              { label: "Answered", value: answered2, color: "text-success" },
              { label: "Skipped", value: skippedCount, color: "text-warning" },
            ].map(s => (
              <div key={s.label} className="bg-hover border border-border rounded-xl p-4 text-center">
                <p className={`text-2xl font-bold tabular-nums ${s.color}`}>{s.value}</p>
                <p className="text-[11px] text-ghost mt-1">{s.label}</p>
              </div>
            ))}
          </div>

          <div className="bg-hover/40 border border-border rounded-xl p-4 mb-6">
            <div className="flex items-center justify-between text-xs mb-2">
              <span className="text-muted">Time used</span>
              <span className="font-semibold text-heading tabular-nums">{fmt(timeUsedFinal)} / {fmt(totalTime)}</span>
            </div>
            <div className="h-2 bg-hover rounded-full overflow-hidden">
              <div className="h-full bg-warning rounded-full" style={{ width: `${(timeUsedFinal / totalTime) * 100}%` }} />
            </div>
          </div>

          {/* Q breakdown */}
          <div className="space-y-2 mb-6">
            {questions.map((q, i) => (
              <div key={q.id} className="flex items-center gap-3 text-xs">
                <span className="w-5 h-5 rounded-md bg-hover border border-border text-ghost flex items-center justify-center font-semibold shrink-0">{i + 1}</span>
                <span className="flex-1 text-muted truncate">{q.text.slice(0, 55)}{q.text.length > 55 ? "…" : ""}</span>
                {skipped.has(q.id)
                  ? <span className="text-warning font-semibold shrink-0">Skipped</span>
                  : <span className="text-success font-semibold shrink-0">Done</span>}
              </div>
            ))}
          </div>

          <div className="flex gap-3">
            <button onClick={restart}
              className="flex-1 flex items-center justify-center gap-2 h-10 rounded-xl border border-border bg-hover text-sm font-semibold text-muted hover:text-primary cursor-pointer transition-colors">
              <RotateCcw size={14} strokeWidth={2} />
              Try again
            </button>
            <button onClick={onClose}
              className="flex-1 h-10 rounded-xl bg-accent hover:bg-accent-hover text-white text-sm font-semibold cursor-pointer transition-colors">
              Done
            </button>
          </div>
        </div>
      </div>
    </div>
  );
}
