import { useMemo, useEffect, useState } from "react";
import {
  CheckCircle, Flame, Target, Trophy, Star, ArrowRight,
  Zap, BookOpen, TrendingUp, Award, Lock, Calendar,
  ChevronRight, GitCommit, Lightbulb, BarChart2, Clock, Timer,
} from "lucide-react";
import TopicIcon from "../components/TopicIcon";
import { fetchUserActivity } from "../services/questionService";

// ── Primitive: circular progress ring ────────────────────────────
function Ring({ pct, size = 56, sw = 4.5, color = "var(--color-accent)", bg = "var(--color-hover)" }) {
  const r = (size - sw) / 2;
  const circ = 2 * Math.PI * r;
  const fill = Math.min(pct, 100) / 100 * circ;
  return (
    <svg width={size} height={size} style={{ transform: "rotate(-90deg)", flexShrink: 0 }}>
      <circle cx={size / 2} cy={size / 2} r={r} fill="none" stroke={bg} strokeWidth={sw} />
      <circle cx={size / 2} cy={size / 2} r={r} fill="none" stroke={color} strokeWidth={sw}
        strokeDasharray={`${fill} ${circ}`} strokeLinecap="round"
        style={{ transition: "stroke-dasharray 0.6s cubic-bezier(.4,0,.2,1)" }} />
    </svg>
  );
}

// ── Mini horizontal progress bar ─────────────────────────────────
function Bar({ pct, color = "var(--color-accent)" }) {
  return (
    <div className="h-1.5 bg-hover rounded-full overflow-hidden w-full">
      <div className="h-full rounded-full transition-all duration-700"
        style={{ width: `${Math.min(pct, 100)}%`, background: color }} />
    </div>
  );
}

// ── Divider label ─────────────────────────────────────────────────
function SectionLabel({ children, action, onAction }) {
  return (
    <div className="flex items-center justify-between mb-3">
      <span className="text-[10px] font-bold tracking-[0.12em] uppercase text-ghost">{children}</span>
      {action && (
        <button onClick={onAction}
          className="text-[11px] text-accent hover:text-accent/80 transition-colors flex items-center gap-0.5 cursor-pointer">
          {action} <ChevronRight size={11} />
        </button>
      )}
    </div>
  );
}

// ── KPI Card ──────────────────────────────────────────────────────
function KPICard({ label, value, sub, Icon, iconCls, trend }) {
  return (
    <div className="bg-panel border border-border rounded-xl p-4 flex flex-col gap-3 min-w-0">
      <div className="flex items-start justify-between">
        <div className={`w-8 h-8 rounded-lg border flex items-center justify-center shrink-0 ${iconCls}`}>
          <Icon size={15} strokeWidth={1.8} />
        </div>
        {trend != null && (
          <span className={`text-[11px] font-semibold tabular-nums px-1.5 py-0.5 rounded-md ${
            trend > 0 ? "bg-success/10 text-success" : trend < 0 ? "bg-danger/10 text-danger" : "bg-hover text-muted"
          }`}>
            {trend > 0 ? "+" : ""}{trend}%
          </span>
        )}
      </div>
      <div>
        <p className="text-2xl font-bold text-heading tabular-nums leading-none">{value}</p>
        <p className="text-xs text-soft mt-0.5 font-medium">{label}</p>
        {sub && <p className="text-[11px] text-muted mt-0.5">{sub}</p>}
      </div>
    </div>
  );
}

// ── Activity Heatmap ──────────────────────────────────────────────
function ActivityHeatmap({ activityMap, loading }) {
  const weeks = useMemo(() => {
    const days = [];
    const today = new Date();
    for (let i = 181; i >= 0; i--) {
      const d = new Date(today);
      d.setDate(today.getDate() - i);
      const key = d.toISOString().slice(0, 10);
      days.push({ key, count: activityMap[key] || 0, dow: d.getDay() });
    }
    // Pad start so first week starts on Sunday
    const firstDow = days[0].dow;
    const padded = [...Array(firstDow).fill(null), ...days];
    const ws = [];
    for (let i = 0; i < padded.length; i += 7) ws.push(padded.slice(i, i + 7));
    return ws;
  }, [activityMap]);

  const months = useMemo(() => {
    const labels = [];
    const today = new Date();
    for (let i = 181; i >= 0; i -= 30) {
      const d = new Date(today);
      d.setDate(today.getDate() - i);
      labels.push(d.toLocaleDateString("en", { month: "short" }));
    }
    return [...new Set(labels)];
  }, []);

  function cellColor(count) {
    if (count === 0) return "var(--color-hover)";
    if (count <= 2) return "rgba(99,102,241,0.35)";
    if (count <= 5) return "rgba(99,102,241,0.6)";
    if (count <= 9) return "rgba(99,102,241,0.82)";
    return "var(--color-accent)";
  }

  const totalActive = Object.values(activityMap).filter(v => v > 0).length;
  const maxInDay = Math.max(...Object.values(activityMap), 0);

  return (
    <div className="bg-panel border border-border rounded-xl p-5">
      <div className="flex items-start justify-between mb-4">
        <div>
          <p className="text-sm font-semibold text-soft">Study Activity</p>
          <p className="text-[11px] text-muted mt-0.5">
            {loading ? "Loading…" : `${totalActive} active days · max ${maxInDay} in a day`}
          </p>
        </div>
        <div className="flex items-center gap-1.5 text-[10px] text-muted">
          <span>Less</span>
          {[0, 2, 5, 9, 12].map((v) => (
            <div key={v} className="w-2.5 h-2.5 rounded-sm"
              style={{ background: cellColor(v), border: v === 0 ? "1px solid var(--color-border)" : "none" }} />
          ))}
          <span>More</span>
        </div>
      </div>

      {/* Month labels */}
      <div className="flex gap-0.5 mb-1 pl-0">
        {months.map((m) => (
          <span key={m} className="text-[9px] text-ghost" style={{ flex: 1, textAlign: "center" }}>{m}</span>
        ))}
      </div>

      {/* Grid */}
      <div className="flex gap-0.5 overflow-x-auto pb-1">
        {weeks.map((week, wi) => (
          <div key={wi} className="flex flex-col gap-0.5">
            {week.map((day, di) =>
              day == null ? (
                <div key={di} className="w-2.5 h-2.5" />
              ) : (
                <div
                  key={di}
                  title={`${day.key}: ${day.count} questions`}
                  className="w-2.5 h-2.5 rounded-sm cursor-default transition-all duration-150 hover:ring-1 hover:ring-accent/50"
                  style={{
                    background: cellColor(day.count),
                    border: day.count === 0 ? "1px solid var(--color-border)" : "none",
                    opacity: loading ? 0.4 : 1,
                  }}
                />
              )
            )}
          </div>
        ))}
      </div>

      {/* Day labels */}
      <div className="flex items-center gap-4 mt-2 text-[10px] text-ghost">
        <span>Mon</span><span>Wed</span><span>Fri</span>
      </div>
    </div>
  );
}

// ── Topic Mastery Card ────────────────────────────────────────────
function TopicMasteryCard({ topics, donePerTopic, onSelectTopic }) {
  const sorted = useMemo(() =>
    [...topics]
      .map(t => ({
        ...t,
        done: donePerTopic?.[t.id] || 0,
        total: t.total_count || 0,
        pct: t.total_count > 0 ? Math.round(((donePerTopic?.[t.id] || 0) / t.total_count) * 100) : 0,
      }))
      .sort((a, b) => b.pct - a.pct),
    [topics, donePerTopic]
  );

  function levelLabel(pct) {
    if (pct === 0) return { label: "Not started", cls: "text-ghost" };
    if (pct < 25) return { label: "Beginner", cls: "text-warning" };
    if (pct < 60) return { label: "Intermediate", cls: "text-blue-400" };
    if (pct < 90) return { label: "Advanced", cls: "text-accent" };
    return { label: "Expert", cls: "text-success" };
  }

  function ringColor(pct) {
    if (pct === 0) return "var(--color-ghost)";
    if (pct < 25) return "#f59e0b";
    if (pct < 60) return "#60a5fa";
    if (pct < 90) return "var(--color-accent)";
    return "var(--color-success)";
  }

  return (
    <div className="bg-panel border border-border rounded-xl p-5">
      <SectionLabel>Topic Mastery</SectionLabel>
      <div className="space-y-3 mt-1">
        {sorted.map((t) => {
          const { label: lvl, cls } = levelLabel(t.pct);
          const remaining = t.total - t.done;
          return (
            <button
              key={t.id}
              onClick={() => onSelectTopic(t)}
              className="w-full flex items-center gap-3 group cursor-pointer hover:bg-hover rounded-lg px-2 py-1.5 -mx-2 transition-colors"
            >
              <div className="relative shrink-0">
                <Ring pct={t.pct} size={40} sw={3.5} color={ringColor(t.pct)} />
                <span className="absolute inset-0 flex items-center justify-center text-[9px] font-bold text-soft"
                  style={{ transform: "rotate(0deg)" }}>
                  {t.pct}%
                </span>
              </div>
              <div className="flex-1 min-w-0 text-left">
                <div className="flex items-center gap-1.5 mb-0.5">
                  <span className="text-muted group-hover:text-primary transition-colors shrink-0">
                    <TopicIcon topic={t} size={11} />
                  </span>
                  <span className="text-xs font-semibold text-primary group-hover:text-bright transition-colors truncate">
                    {t.label}
                  </span>
                </div>
                <div className="flex items-center justify-between gap-2">
                  <Bar pct={t.pct} color={ringColor(t.pct)} />
                  <span className={`text-[10px] font-medium shrink-0 ${cls}`}>{lvl}</span>
                </div>
              </div>
              <div className="text-right shrink-0">
                <p className="text-xs font-semibold text-soft tabular-nums">{t.done}/{t.total}</p>
                {remaining > 0 && (
                  <p className="text-[10px] text-muted">{remaining} left</p>
                )}
              </div>
            </button>
          );
        })}
      </div>
    </div>
  );
}

// ── Achievements ──────────────────────────────────────────────────
const ACHIEVEMENT_DEFS = [
  { id: "first",    icon: Zap,        label: "First Step",       desc: "Complete your first question",     req: (d) => d.totalDone >= 1       },
  { id: "streak3",  icon: Flame,      label: "On Fire",          desc: "Maintain a 3-day streak",          req: (d) => d.streak >= 3          },
  { id: "ten",      icon: TrendingUp, label: "Quick Learner",    desc: "Complete 10 questions",            req: (d) => d.totalDone >= 10      },
  { id: "streak7",  icon: Star,       label: "Dedicated",        desc: "Achieve a 7-day streak",           req: (d) => d.streak >= 7          },
  { id: "fifty",    icon: Award,      label: "Halfway Club",     desc: "Complete 50 questions",            req: (d) => d.totalDone >= 50      },
  { id: "topic1",   icon: Trophy,     label: "Topic Complete",   desc: "Finish an entire topic",           req: (d) => d.topicsMastered >= 1  },
  { id: "hundred",  icon: BookOpen,   label: "Century Club",     desc: "Complete 100 questions",           req: (d) => d.totalDone >= 100     },
  { id: "streak30", icon: Calendar,   label: "Unstoppable",      desc: "Achieve a 30-day streak",          req: (d) => d.streak >= 30         },
];

function Achievements({ totalDone, streak, topicsMastered }) {
  const ctx = { totalDone, streak, topicsMastered };
  return (
    <div className="bg-panel border border-border rounded-xl p-5">
      <SectionLabel>Achievements</SectionLabel>
      <div className="grid grid-cols-4 gap-2 mt-1">
        {ACHIEVEMENT_DEFS.map((a) => {
          const unlocked = a.req(ctx);
          const Icon = a.icon;
          return (
            <div key={a.id} title={a.desc}
              className={`flex flex-col items-center gap-1.5 p-2.5 rounded-xl border text-center transition-all ${
                unlocked
                  ? "bg-accent/5 border-accent/20 opacity-100"
                  : "bg-hover/50 border-border opacity-40 grayscale"
              }`}
            >
              <div className={`w-8 h-8 rounded-lg flex items-center justify-center ${
                unlocked ? "bg-accent/15 text-accent" : "bg-hover text-muted"
              }`}>
                {unlocked ? <Icon size={15} strokeWidth={1.7} /> : <Lock size={12} strokeWidth={1.7} />}
              </div>
              <p className="text-[9px] font-semibold text-soft leading-tight">{a.label}</p>
            </div>
          );
        })}
      </div>
    </div>
  );
}

// ── Upcoming Milestones ───────────────────────────────────────────
function UpcomingMilestones({ totalDone, streak, weekDone, weekGoal, topics, donePerTopic }) {
  const milestones = useMemo(() => {
    const list = [];

    // Weekly goal
    const weekLeft = weekGoal - weekDone;
    if (weekLeft > 0) list.push({ label: `Weekly Goal`, desc: `${weekLeft} more to hit ${weekGoal}/week`, Icon: Target, color: "text-accent" });

    // Next question milestone
    const counts = [10, 25, 50, 100, 200, 300, 500];
    const nextCount = counts.find(c => c > totalDone);
    if (nextCount) list.push({ label: `${nextCount} Questions`, desc: `${nextCount - totalDone} away`, Icon: Zap, color: "text-warning" });

    // Topic closest to completion
    const topicProgress = topics
      .map(t => ({ ...t, done: donePerTopic?.[t.id] || 0, total: t.total_count || 0 }))
      .filter(t => t.total > 0 && t.done > 0 && t.done < t.total)
      .sort((a, b) => (b.done / b.total) - (a.done / a.total));

    if (topicProgress[0]) {
      const t = topicProgress[0];
      const left = t.total - t.done;
      list.push({ label: `Complete ${t.label}`, desc: `${left} question${left !== 1 ? "s" : ""} remaining`, Icon: Trophy, color: "text-success" });
    }

    // Streak milestone
    const streakTargets = [3, 7, 14, 30, 60, 100];
    const nextStreak = streakTargets.find(s => s > streak);
    if (nextStreak) list.push({ label: `${nextStreak}-Day Streak`, desc: `${nextStreak - streak} more day${nextStreak - streak !== 1 ? "s" : ""}`, Icon: Flame, color: "text-orange-400" });

    return list.slice(0, 4);
  }, [totalDone, streak, weekDone, weekGoal, topics, donePerTopic]);

  if (!milestones.length) return null;
  return (
    <div className="bg-panel border border-border rounded-xl p-5">
      <SectionLabel>Upcoming Milestones</SectionLabel>
      <div className="space-y-2 mt-1">
        {milestones.map((m, i) => {
          const Icon = m.icon ?? m.Icon;
          return (
            <div key={i} className="flex items-center gap-3 py-1.5">
              <div className={`w-6 h-6 rounded-md bg-hover flex items-center justify-center shrink-0 ${m.color}`}>
                <Icon size={12} strokeWidth={2} />
              </div>
              <div className="flex-1 min-w-0">
                <p className="text-xs font-semibold text-soft">{m.label}</p>
                <p className="text-[11px] text-muted">{m.desc}</p>
              </div>
            </div>
          );
        })}
      </div>
    </div>
  );
}

// ── Study Insights ────────────────────────────────────────────────
function StudyInsights({ totalDone, totalAll, streak, weekDone, weekGoal, topics, donePerTopic }) {
  const insights = useMemo(() => {
    const list = [];
    const pct = totalAll > 0 ? Math.round((totalDone / totalAll) * 100) : 0;

    if (pct > 0) list.push(`You've covered ${pct}% of the entire question bank.`);

    const sorted = [...topics]
      .map(t => ({ ...t, pct: t.total_count > 0 ? (donePerTopic?.[t.id] || 0) / t.total_count : 0 }))
      .sort((a, b) => b.pct - a.pct);

    if (sorted[0]?.pct > 0) list.push(`${sorted[0].label} is your strongest topic at ${Math.round(sorted[0].pct * 100)}%.`);

    const leastStarted = sorted.filter(t => t.pct === 0 && t.total_count > 0).at(-1);
    if (leastStarted) list.push(`${leastStarted.label} hasn't been started yet — ${leastStarted.total_count} questions waiting.`);

    if (streak > 1) list.push(`You're on a ${streak}-day streak. Don't break the chain!`);
    if (weekGoal > 0 && weekDone >= weekGoal) list.push(`Weekly goal achieved! You completed ${weekDone} of ${weekGoal} target questions this week.`);
    if (weekGoal > 0 && weekDone < weekGoal) list.push(`${weekGoal - weekDone} more question${weekGoal - weekDone !== 1 ? "s" : ""} to hit your weekly goal of ${weekGoal}.`);

    return list.slice(0, 3);
  }, [totalDone, totalAll, streak, weekDone, weekGoal, topics, donePerTopic]);

  if (!insights.length) return null;
  return (
    <div className="bg-panel border border-border rounded-xl p-5">
      <SectionLabel>Study Insights</SectionLabel>
      <div className="space-y-2.5 mt-1">
        {insights.map((text, i) => (
          <div key={i} className="flex items-start gap-2.5">
            <div className="w-5 h-5 rounded-md bg-accent/10 text-accent flex items-center justify-center shrink-0 mt-0.5">
              <Lightbulb size={10} strokeWidth={2} />
            </div>
            <p className="text-xs text-soft leading-relaxed">{text}</p>
          </div>
        ))}
      </div>
    </div>
  );
}

// ── Continue Learning Card ────────────────────────────────────────
function ContinueLearning({ onSelectBookmark }) {
  const lastQ = useMemo(() => {
    try { return JSON.parse(localStorage.getItem("devready_last_q") || "null"); }
    catch { return null; }
  }, []);

  if (!lastQ) return null;
  return (
    <div>
      <SectionLabel>Continue Learning</SectionLabel>
      <button
        onClick={() => onSelectBookmark?.(lastQ)}
        className="w-full text-left bg-panel border border-border rounded-xl p-4 hover:border-accent/40 hover:bg-hover transition-all group cursor-pointer"
      >
        <div className="flex items-center gap-3">
          <div className="w-9 h-9 rounded-lg bg-accent/10 border border-accent/20 flex items-center justify-center shrink-0 text-accent">
            <BookOpen size={16} strokeWidth={1.7} />
          </div>
          <div className="flex-1 min-w-0">
            <p className="text-[10px] text-muted mb-0.5 font-medium">
              {lastQ.topicLabel}{lastQ.sectionLabel ? ` › ${lastQ.sectionLabel}` : ""}
            </p>
            <p className="text-sm font-semibold text-primary group-hover:text-bright transition-colors leading-snug line-clamp-1">
              {lastQ.questionText}
            </p>
          </div>
          <div className="flex items-center gap-2 shrink-0">
            <span className="text-[11px] font-semibold text-accent bg-accent/10 border border-accent/20 px-2.5 py-1 rounded-lg">
              Resume
            </span>
            <ArrowRight size={14} className="text-accent group-hover:translate-x-0.5 transition-transform" />
          </div>
        </div>
      </button>
    </div>
  );
}

// ── Recommended Next ──────────────────────────────────────────────
function RecommendedNext({ topics, donePerTopic, onSelectTopic }) {
  const picks = useMemo(() => {
    return [...topics]
      .map(t => ({
        ...t,
        done: donePerTopic?.[t.id] || 0,
        total: t.total_count || 0,
        pct: t.total_count > 0 ? (donePerTopic?.[t.id] || 0) / t.total_count : 0,
      }))
      .filter(t => t.total > 0 && t.pct < 1)
      .sort((a, b) => {
        // Prefer in-progress topics (0 < pct < 1), then unstarted
        const aInProgress = a.pct > 0 && a.pct < 1;
        const bInProgress = b.pct > 0 && b.pct < 1;
        if (aInProgress !== bInProgress) return aInProgress ? -1 : 1;
        // Among in-progress, prefer highest completion
        return b.pct - a.pct;
      })
      .slice(0, 3);
  }, [topics, donePerTopic]);

  if (!picks.length) return null;

  const reasonFor = (t) => {
    if (t.pct === 0) return "Start here";
    if (t.pct < 0.3) return "Just getting started";
    if (t.pct < 0.7) return "Keep going";
    return "Almost done!";
  };

  return (
    <div>
      <SectionLabel>Recommended Next</SectionLabel>
      <div className="space-y-2">
        {picks.map((t, i) => (
          <button
            key={t.id}
            onClick={() => onSelectTopic(t)}
            className="w-full text-left flex items-center gap-3 bg-panel border border-border rounded-xl px-4 py-3 hover:border-accent/40 hover:bg-hover transition-all group cursor-pointer"
          >
            <div className="w-7 h-7 rounded-lg bg-hover flex items-center justify-center text-muted group-hover:text-accent transition-colors shrink-0">
              <TopicIcon topic={t} size={14} />
            </div>
            <div className="flex-1 min-w-0">
              <p className="text-xs font-semibold text-primary group-hover:text-bright transition-colors">{t.label}</p>
              <p className="text-[10px] text-muted">{reasonFor(t)} · {t.total - t.done} questions left</p>
            </div>
            <div className="shrink-0 text-right">
              <div className="flex items-center gap-1.5">
                <div className="w-12 h-1 bg-hover rounded-full overflow-hidden">
                  <div className="h-full rounded-full bg-accent/60 transition-all"
                    style={{ width: `${Math.round(t.pct * 100)}%` }} />
                </div>
                <span className="text-[10px] text-muted tabular-nums w-8">{Math.round(t.pct * 100)}%</span>
              </div>
            </div>
          </button>
        ))}
      </div>
    </div>
  );
}

// ── Weekly Goal Widget ────────────────────────────────────────────
function WeeklyGoalWidget({ weekDone, weekGoal }) {
  const pct = weekGoal > 0 ? Math.min(Math.round((weekDone / weekGoal) * 100), 100) : 0;
  const dayOfWeek = new Date().getDay(); // 0 = Sun
  const daysLeft = 7 - dayOfWeek;
  const needed = Math.max(0, weekGoal - weekDone);
  const onTrack = daysLeft > 0 ? weekDone / (7 - daysLeft + 1) >= weekGoal / 7 : weekDone >= weekGoal;

  return (
    <div className="bg-panel border border-border rounded-xl p-5">
      <SectionLabel>Weekly Goal</SectionLabel>
      <div className="flex items-center gap-4 mt-2">
        <div className="relative shrink-0">
          <Ring pct={pct} size={64} sw={5}
            color={pct >= 100 ? "var(--color-success)" : "var(--color-accent)"} />
          <div className="absolute inset-0 flex flex-col items-center justify-center" style={{ transform: "none" }}>
            <span className="text-sm font-bold text-heading tabular-nums">{weekDone}</span>
            <span className="text-[9px] text-muted">/{weekGoal}</span>
          </div>
        </div>
        <div className="flex-1 min-w-0">
          <p className="text-xs font-semibold text-soft mb-1">
            {pct >= 100 ? "Goal reached!" : `${pct}% complete`}
          </p>
          <div className="space-y-1">
            <div className="flex items-center justify-between text-[11px]">
              <span className="text-muted">Completed</span>
              <span className="font-semibold text-soft tabular-nums">{weekDone}</span>
            </div>
            <div className="flex items-center justify-between text-[11px]">
              <span className="text-muted">Remaining</span>
              <span className="font-semibold text-soft tabular-nums">{needed}</span>
            </div>
            <div className="flex items-center justify-between text-[11px]">
              <span className="text-muted">Days left</span>
              <span className={`font-semibold tabular-nums ${onTrack ? "text-success" : "text-warning"}`}>{daysLeft}</span>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}

// ── Bookmarks Quick Access ────────────────────────────────────────
function BookmarksPanel({ bookmarks, onSelectBookmark }) {
  if (!bookmarks?.length) return null;
  return (
    <div className="bg-panel border border-border rounded-xl p-5">
      <SectionLabel action="View all">Bookmarked Questions</SectionLabel>
      <div className="space-y-1 mt-1">
        {bookmarks.slice(0, 6).map((b) => (
          <button
            key={b.question_id}
            onClick={() => onSelectBookmark?.(b)}
            className="w-full text-left flex items-center gap-3 px-3 py-2 rounded-lg hover:bg-hover transition-colors group cursor-pointer"
          >
            <Star size={11} className="text-warning shrink-0 fill-current" />
            <div className="flex-1 min-w-0">
              <p className="text-xs text-primary group-hover:text-bright transition-colors truncate">
                {b.question_text}
              </p>
              <p className="text-[10px] text-muted truncate">
                {b.topic_label}{b.section_label ? ` › ${b.section_label}` : ""}
              </p>
            </div>
          </button>
        ))}
      </div>
    </div>
  );
}

// ── Productivity Stats ────────────────────────────────────────────
function ProductivityPanel({ totalDone, totalAll, streak, weekDone, weekGoal }) {
  const completionRate = totalAll > 0 ? ((totalDone / totalAll) * 100).toFixed(1) : "0.0";
  const avgPerWeek = streak > 0 ? Math.round(weekDone / Math.max(new Date().getDay(), 1)) : 0;
  return (
    <div className="bg-panel border border-border rounded-xl p-5">
      <SectionLabel>Productivity</SectionLabel>
      <div className="grid grid-cols-2 gap-3 mt-1">
        {[
          { label: "Completion Rate", value: `${completionRate}%`, Icon: BarChart2, cls: "text-accent" },
          { label: "Streak", value: streak > 0 ? `${streak}d` : "—", Icon: Flame, cls: "text-warning" },
          { label: "This Week", value: weekDone, Icon: TrendingUp, cls: "text-success" },
          { label: "Daily Avg", value: avgPerWeek || "—", Icon: Clock, cls: "text-blue-400" },
        ].map(({ label, value, Icon, cls }) => (
          <div key={label} className="flex items-center gap-2.5 py-1">
            <div className={`w-7 h-7 rounded-lg bg-hover flex items-center justify-center shrink-0 ${cls}`}>
              <Icon size={13} strokeWidth={1.8} />
            </div>
            <div>
              <p className="text-sm font-bold text-heading tabular-nums leading-none">{value}</p>
              <p className="text-[10px] text-muted mt-0.5">{label}</p>
            </div>
          </div>
        ))}
      </div>
    </div>
  );
}

// ── Smart hero message ────────────────────────────────────────────
function heroMessage({ totalDone, totalAll, streak, weekDone, weekGoal, topics, donePerTopic }) {
  if (totalDone === 0) return "Ready to start your prep? Pick a topic from the sidebar.";
  if (weekGoal > 0 && weekDone >= weekGoal) return `Weekly goal smashed — ${weekDone} questions done this week!`;
  if (weekGoal > 0 && weekGoal - weekDone <= 3 && weekGoal - weekDone > 0)
    return `Only ${weekGoal - weekDone} more question${weekGoal - weekDone !== 1 ? "s" : ""} to hit your weekly goal.`;
  if (streak >= 7) return `${streak}-day streak! You're building an incredible habit.`;
  if (streak >= 3) return `${streak}-day streak going strong. Keep it up!`;

  const sorted = [...topics]
    .map(t => ({ ...t, pct: t.total_count > 0 ? (donePerTopic?.[t.id] || 0) / t.total_count : 0 }))
    .filter(t => t.pct > 0)
    .sort((a, b) => b.pct - a.pct);
  if (sorted[0]?.pct > 0.5) return `${sorted[0].label} is looking strong at ${Math.round(sorted[0].pct * 100)}%.`;

  const pct = totalAll > 0 ? Math.round((totalDone / totalAll) * 100) : 0;
  return `You've completed ${totalDone} question${totalDone !== 1 ? "s" : ""} — ${pct}% of the full library.`;
}

// ── Main Dashboard ────────────────────────────────────────────────
export default function Dashboard({
  user, topics, donePerTopic, totalDone, totalAll,
  streak, weekDone, weekGoal, bookmarks, onSelectTopic, onSelectBookmark,
  onStartQuiz, onStartInterview,
}) {
  const [activityMap, setActivityMap] = useState({});
  const [heatmapLoading, setHeatmapLoading] = useState(true);
  const [badgeToast, setBadgeToast] = useState(null);

  useEffect(() => {
    if (!user?.id) { setHeatmapLoading(false); return; }
    fetchUserActivity(user.id)
      .then((map) => { setActivityMap(map); setHeatmapLoading(false); })
      .catch(() => setHeatmapLoading(false));
  }, [user?.id]);

  const displayName = user?.user_metadata?.full_name?.split(" ")[0] || "there";
  const hour = new Date().getHours();
  const greeting = hour < 12 ? "Good morning" : hour < 17 ? "Good afternoon" : "Good evening";

  const topicsMastered = useMemo(
    () => topics.filter(t => {
      const total = t.total_count || 0;
      return total > 0 && (donePerTopic?.[t.id] || 0) >= total;
    }).length,
    [topics, donePerTopic]
  );

  // Badge unlock toast notifications
  useEffect(() => {
    if (totalDone === 0 && streak === 0 && topicsMastered === 0) return;
    const ctx = { totalDone, streak, topicsMastered };
    let stored;
    try { stored = new Set(JSON.parse(localStorage.getItem("devready_badges") || "[]")); }
    catch { stored = new Set(); }
    const newlyUnlocked = ACHIEVEMENT_DEFS.filter(a => a.req(ctx) && !stored.has(a.id));
    if (newlyUnlocked.length > 0) {
      const updated = new Set([...stored, ...newlyUnlocked.map(a => a.id)]);
      localStorage.setItem("devready_badges", JSON.stringify([...updated]));
      setBadgeToast(newlyUnlocked[0]); // show first new badge
    }
  }, [totalDone, streak, topicsMastered]);

  const overallPct = totalAll > 0 ? Math.round((totalDone / totalAll) * 100) : 0;
  const message = heroMessage({ totalDone, totalAll, streak, weekDone, weekGoal, topics, donePerTopic });

  return (
    <div className="flex-1 overflow-y-auto relative">

      {/* ── Badge unlock toast ───────────────────────────────────── */}
      {badgeToast && (() => {
        const Icon = badgeToast.icon;
        return (
          <div className="fixed bottom-6 right-6 z-50 flex items-center gap-3 bg-panel border border-accent/30 rounded-2xl px-4 py-3 shadow-xl"
            style={{ animation: "slideInRight 0.3s ease-out", boxShadow: "0 0 24px rgba(99,102,241,0.2)" }}>
            <div className="w-10 h-10 rounded-xl bg-accent/15 border border-accent/25 flex items-center justify-center shrink-0">
              <Icon size={18} strokeWidth={1.7} className="text-accent" />
            </div>
            <div className="min-w-0">
              <p className="text-[11px] font-bold text-ghost uppercase tracking-wide">Badge unlocked!</p>
              <p className="text-sm font-semibold text-heading">{badgeToast.label}</p>
              <p className="text-[11px] text-muted">{badgeToast.desc}</p>
            </div>
            <button onClick={() => setBadgeToast(null)}
              className="w-6 h-6 rounded-md text-ghost hover:text-muted flex items-center justify-center cursor-pointer shrink-0 ml-1">
              <svg width="10" height="10" viewBox="0 0 10 10" fill="none">
                <path d="M1 1l8 8M9 1L1 9" stroke="currentColor" strokeWidth="1.5" strokeLinecap="round"/>
              </svg>
            </button>
          </div>
        );
      })()}

      {/* ── Hero Banner ─────────────────────────────────────────── */}
      <div className="px-6 py-6 border-b border-border"
        style={{ background: "linear-gradient(135deg, rgba(99,102,241,0.06) 0%, transparent 60%)" }}>
        <div className="flex items-start justify-between gap-4 flex-wrap">
          <div>
            <h1 className="text-2xl font-bold text-heading">
              {greeting}, {displayName}
            </h1>
            <p className="text-sm text-soft mt-1 max-w-md">{message}</p>
          </div>
          {/* Compact progress ring */}
          <div className="flex items-center gap-3 bg-panel border border-border rounded-xl px-4 py-3 shrink-0">
            <div className="relative">
              <Ring pct={overallPct} size={48} sw={4}
                color={overallPct >= 100 ? "var(--color-success)" : "var(--color-accent)"} />
              <div className="absolute inset-0 flex items-center justify-center">
                <span className="text-[10px] font-bold text-soft">{overallPct}%</span>
              </div>
            </div>
            <div>
              <p className="text-xs font-semibold text-soft">Overall</p>
              <p className="text-[11px] text-muted">{totalDone}/{totalAll} done</p>
            </div>
          </div>
        </div>
      </div>

      {/* ── Practice Modes ──────────────────────────────────────── */}
      <div className="px-6 py-3 border-b border-border flex items-center gap-3">
        <span className="text-[10px] font-bold tracking-widest uppercase text-ghost">Practice</span>
        <button onClick={onStartQuiz}
          className="flex items-center gap-1.5 px-3 py-1.5 rounded-lg bg-accent/10 border border-accent/20 text-accent text-xs font-semibold hover:bg-accent/20 transition-all cursor-pointer">
          <Zap size={12} strokeWidth={2} />
          Quiz Mode
        </button>
        <button onClick={onStartInterview}
          className="flex items-center gap-1.5 px-3 py-1.5 rounded-lg bg-warning/10 border border-warning/20 text-warning text-xs font-semibold hover:bg-warning/20 transition-all cursor-pointer">
          <Timer size={12} strokeWidth={2} />
          Interview Sim
        </button>
      </div>

      <div className="p-6 space-y-6">

        {/* ── KPI Row ─────────────────────────────────────────── */}
        <div className="grid grid-cols-2 lg:grid-cols-4 gap-3">
          <KPICard
            label="Questions Done"
            value={totalDone}
            sub={`of ${totalAll} total`}
            Icon={CheckCircle}
            iconCls="bg-success/10 border-success/20 text-success"
          />
          <KPICard
            label="Day Streak"
            value={streak > 0 ? `${streak}d` : "—"}
            sub={streak >= 7 ? "On fire!" : streak > 0 ? "Keep going!" : "Answer today to start"}
            Icon={Flame}
            iconCls="bg-warning/10 border-warning/20 text-warning"
          />
          <KPICard
            label="Weekly Goal"
            value={`${weekDone}/${weekGoal}`}
            sub={weekDone >= weekGoal ? "Goal reached!" : `${Math.max(0, weekGoal - weekDone)} remaining`}
            Icon={Target}
            iconCls="bg-accent/10 border-accent/20 text-accent"
          />
          <KPICard
            label="Topics Mastered"
            value={`${topicsMastered}/${topics.length}`}
            sub={topicsMastered > 0 ? "Keep completing!" : "Finish all questions in a topic"}
            Icon={Trophy}
            iconCls="bg-violet-500/10 border-violet-500/20 text-violet-400"
          />
        </div>

        {/* ── Continue + Recommended ──────────────────────────── */}
        <div className="grid grid-cols-1 lg:grid-cols-2 gap-5">
          <ContinueLearning onSelectBookmark={onSelectBookmark} />
          <RecommendedNext topics={topics} donePerTopic={donePerTopic} onSelectTopic={onSelectTopic} />
        </div>

        {/* ── Heatmap ─────────────────────────────────────────── */}
        <ActivityHeatmap activityMap={activityMap} loading={heatmapLoading} />

        {/* ── Topic Mastery + Right column ────────────────────── */}
        <div className="grid grid-cols-1 lg:grid-cols-[1fr_360px] gap-5">
          <TopicMasteryCard topics={topics} donePerTopic={donePerTopic} onSelectTopic={onSelectTopic} />

          <div className="space-y-5">
            <WeeklyGoalWidget weekDone={weekDone} weekGoal={weekGoal} />
            <ProductivityPanel
              totalDone={totalDone} totalAll={totalAll}
              streak={streak} weekDone={weekDone} weekGoal={weekGoal}
            />
          </div>
        </div>

        {/* ── Achievements + Milestones ────────────────────────── */}
        <div className="grid grid-cols-1 lg:grid-cols-2 gap-5">
          <Achievements totalDone={totalDone} streak={streak} topicsMastered={topicsMastered} />
          <div className="space-y-5">
            <UpcomingMilestones
              totalDone={totalDone} streak={streak}
              weekDone={weekDone} weekGoal={weekGoal}
              topics={topics} donePerTopic={donePerTopic}
            />
            <StudyInsights
              totalDone={totalDone} totalAll={totalAll}
              streak={streak} weekDone={weekDone} weekGoal={weekGoal}
              topics={topics} donePerTopic={donePerTopic}
            />
          </div>
        </div>

        {/* ── Bookmarks ───────────────────────────────────────── */}
        {bookmarks?.length > 0 && (
          <BookmarksPanel bookmarks={bookmarks} onSelectBookmark={onSelectBookmark} />
        )}

      </div>
    </div>
  );
}
