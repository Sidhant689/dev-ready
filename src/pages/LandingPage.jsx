import { useState, useEffect } from "react";

/* ── Reusable tiny components ───────────────────────────────────── */

function NavLink({ children, href = "#" }) {
  return (
    <a href={href} className="text-sm text-muted hover:text-primary transition-colors">
      {children}
    </a>
  );
}

function PrimaryBtn({ children, onClick, className = "" }) {
  return (
    <button
      onClick={onClick}
      className={`inline-flex items-center gap-2 h-11 px-6 rounded-lg bg-accent hover:bg-accent-hover text-white font-semibold text-sm transition-all duration-150 cursor-pointer ${className}`}
      style={{ boxShadow: '0 0 20px rgba(99,102,241,0.3)' }}
    >
      {children}
    </button>
  );
}

function GhostBtn({ children, onClick, className = "" }) {
  return (
    <button
      onClick={onClick}
      className={`inline-flex items-center gap-2 h-11 px-6 rounded-lg border border-border text-primary font-medium text-sm hover:bg-hover hover:border-subtle transition-all duration-150 cursor-pointer ${className}`}
    >
      {children}
    </button>
  );
}

/* ── Navbar ─────────────────────────────────────────────────────── */
function Navbar({ onSignIn, onGetStarted, scrolled }) {
  return (
    <nav
      className={`fixed top-0 left-0 right-0 z-50 transition-all duration-300 ${
        scrolled
          ? "bg-surface/90 backdrop-blur-xl border-b border-border shadow-md"
          : "bg-transparent"
      }`}
    >
      <div className="max-w-6xl mx-auto px-6 h-16 flex items-center gap-8">
        {/* Logo */}
        <div className="flex items-center gap-2.5 font-bold text-heading text-base select-none mr-auto">
          <div
            className="w-8 h-8 rounded-lg bg-accent flex items-center justify-center text-white text-sm font-bold"
            style={{ boxShadow: '0 0 16px rgba(99,102,241,0.4)' }}
          >
            D
          </div>
          DevReady
        </div>

        {/* Links — hidden on small screens */}
        <div className="hidden md:flex items-center gap-6">
          <NavLink href="#features">Features</NavLink>
          <NavLink href="#topics">Topics</NavLink>
          <NavLink href="#faq">FAQ</NavLink>
        </div>

        <div className="flex items-center gap-3">
          <button
            onClick={onSignIn}
            className="text-sm text-muted hover:text-primary transition-colors cursor-pointer hidden sm:block"
          >
            Sign in
          </button>
          <PrimaryBtn onClick={onGetStarted} className="h-9 px-4 text-xs">
            Start Free →
          </PrimaryBtn>
        </div>
      </div>
    </nav>
  );
}

/* ── Hero ───────────────────────────────────────────────────────── */
function Hero({ onGetStarted }) {
  return (
    <section className="relative min-h-screen flex flex-col items-center justify-center text-center px-6 pt-20 pb-16 overflow-hidden">
      {/* Background glow */}
      <div
        className="absolute inset-0 pointer-events-none"
        style={{
          background: 'radial-gradient(ellipse 80% 50% at 50% -10%, rgba(99,102,241,0.15) 0%, transparent 70%)',
        }}
      />

      {/* Badge */}
      <div className="relative inline-flex items-center gap-2 border border-accent/30 bg-accent/10 text-accent text-xs font-medium px-4 py-1.5 rounded-full mb-8">
        <span className="w-1.5 h-1.5 rounded-full bg-accent animate-pulse" />
        500+ curated interview questions
      </div>

      {/* Headline */}
      <h1 className="relative text-5xl md:text-6xl lg:text-7xl font-extrabold text-heading leading-[1.08] tracking-tight max-w-3xl mb-6">
        Master Technical
        <br />
        <span style={{ color: '#818cf8' }}>Interviews.</span> Faster.
      </h1>

      {/* Sub-headline */}
      <p className="relative text-lg text-muted max-w-xl leading-relaxed mb-10">
        Stop bouncing between random YouTube videos and scattered notes.
        DevReady gives you one structured path — from zero to interview-ready.
      </p>

      {/* CTAs */}
      <div className="relative flex flex-col sm:flex-row items-center gap-3 mb-16">
        <PrimaryBtn onClick={onGetStarted} className="h-12 px-8 text-sm">
          Start Preparing Free →
        </PrimaryBtn>
        <GhostBtn onClick={() => document.getElementById('features')?.scrollIntoView({ behavior: 'smooth' })}>
          See How It Works
        </GhostBtn>
      </div>

      {/* Trust strip */}
      <div className="relative flex items-center gap-6 text-sm text-ghost flex-wrap justify-center">
        {["500+ Questions", "15+ Topics", "3 Difficulty Levels", "Progress Tracking", "100% Free"].map((s, i, arr) => (
          <span key={s} className="flex items-center gap-6">
            <span className="text-muted">{s}</span>
            {i < arr.length - 1 && <span className="text-ghost">·</span>}
          </span>
        ))}
      </div>

      {/* Product preview mockup */}
      <div className="relative mt-20 w-full max-w-5xl mx-auto">
        {/* Browser chrome */}
        <div
          className="rounded-xl overflow-hidden border border-border"
          style={{
            boxShadow: '0 40px 100px rgba(0,0,0,0.8), 0 0 0 1px rgba(255,255,255,0.04)',
            transform: 'perspective(1200px) rotateX(2deg)',
          }}
        >
          {/* Chrome bar */}
          <div className="h-9 bg-panel border-b border-border flex items-center px-4 gap-2">
            <span className="w-3 h-3 rounded-full bg-red-500/60" />
            <span className="w-3 h-3 rounded-full bg-yellow-500/60" />
            <span className="w-3 h-3 rounded-full bg-green-500/60" />
            <div className="flex-1 mx-4">
              <div className="h-5 bg-hover rounded-md max-w-48 mx-auto" />
            </div>
          </div>
          {/* App mockup inside */}
          <AppMockup />
        </div>
        {/* Bottom fade */}
        <div
          className="absolute bottom-0 left-0 right-0 h-32 pointer-events-none"
          style={{ background: 'linear-gradient(to top, #0a0c10, transparent)' }}
        />
      </div>
    </section>
  );
}

/* Mini app mockup shown inside browser chrome */
function AppMockup() {
  return (
    <div className="flex h-80 bg-surface text-[10px] select-none overflow-hidden">
      {/* Sidebar */}
      <div className="w-44 bg-panel border-r border-border flex flex-col p-2 gap-1">
        <div className="px-2 pt-1 pb-2 text-ghost font-semibold tracking-widest uppercase text-[8px]">Topics</div>
        {[
          { label: "React", color: "#61dafb", pct: 72 },
          { label: "JavaScript", color: "#f7df1e", pct: 34 },
          { label: "System Design", color: "#6366f1", pct: 10 },
          { label: "DSA", color: "#10b981", pct: 55 },
        ].map((t) => (
          <div key={t.label} className={`px-2 py-1.5 rounded-md ${t.label === "React" ? "bg-hover" : ""}`}>
            <div className="flex items-center gap-1.5 mb-1">
              <span className="w-1.5 h-1.5 rounded-full" style={{ background: t.color }} />
              <span className="text-primary flex-1">{t.label}</span>
              <span className="text-ghost">{t.pct}%</span>
            </div>
            <div className="h-0.5 bg-hover rounded-full overflow-hidden">
              <div className="h-full bg-accent rounded-full" style={{ width: `${t.pct}%` }} />
            </div>
          </div>
        ))}
      </div>

      {/* Question list */}
      <div className="w-56 border-r border-border flex flex-col">
        <div className="p-2 border-b border-border">
          <div className="font-semibold text-bright mb-1.5">JSX & Components</div>
          <div className="h-4 bg-hover rounded-md mb-1.5" />
          <div className="h-1 bg-hover rounded-full overflow-hidden">
            <div className="h-full bg-accent rounded-full" style={{ width: '70%' }} />
          </div>
        </div>
        <div className="flex-1 overflow-hidden p-1.5 space-y-1">
          {[
            { done: true,  text: "What is JSX?" },
            { done: true,  text: "Explain Virtual DOM" },
            { active: true, text: "Class vs Functional components" },
            { done: false, text: "What are React Hooks?" },
            { done: false, text: "Explain useEffect" },
          ].map((q, i) => (
            <div
              key={i}
              className={`flex items-start gap-1.5 px-2 py-1.5 rounded-md ${
                q.active ? "bg-accent/10 border border-accent/20" : "hover:bg-hover"
              }`}
            >
              <span className={`mt-0.5 ${q.done ? "text-success" : q.active ? "text-warning" : "text-ghost"}`}>
                {q.done ? "✓" : q.active ? "◐" : "○"}
              </span>
              <span className={q.active ? "text-bright" : "text-primary"}>{q.text}</span>
            </div>
          ))}
        </div>
      </div>

      {/* Answer panel */}
      <div className="flex-1 flex flex-col overflow-hidden">
        <div className="p-3 border-b border-border bg-panel">
          <div className="flex items-center gap-2 mb-1.5 text-ghost">
            <span>React</span><span>›</span><span>JSX & Components</span>
            <span className="ml-auto border border-warning/50 text-warning bg-warning/10 px-2 py-0.5 rounded-full text-[9px]">◐ In Progress</span>
          </div>
          <div className="text-bright font-semibold leading-snug">Class vs Functional Components</div>
          <div className="text-ghost mt-1">Q3 of 12 · ~2 min read</div>
        </div>
        <div className="flex-1 p-3 space-y-2 overflow-hidden">
          <div className="h-2.5 bg-hover rounded w-full" />
          <div className="h-2.5 bg-hover rounded w-5/6" />
          <div className="h-2.5 bg-hover rounded w-full" />
          <div className="mt-2 bg-panel border border-border rounded-md p-2">
            <div className="h-2 bg-accent/20 rounded w-3/4 mb-1.5" />
            <div className="h-2 bg-accent/10 rounded w-full mb-1" />
            <div className="h-2 bg-accent/10 rounded w-2/3" />
          </div>
          <div className="h-2.5 bg-hover rounded w-full" />
          <div className="h-2.5 bg-hover rounded w-4/5" />
        </div>
      </div>
    </div>
  );
}

/* ── Problem / Solution ──────────────────────────────────────────── */
function ProblemSolution() {
  const problems = [
    "47 open browser tabs, no structure",
    "YouTube rabbit holes that never end",
    "Can't track what you've actually covered",
    "Random difficulty spikes kill motivation",
    "Starting from scratch every session",
  ];
  const solutions = [
    "Everything in one structured place",
    "Curated, answer-complete questions",
    "See exactly where you stand per topic",
    "Progressive difficulty — Basic to Advanced",
    "Your progress saves automatically",
  ];

  return (
    <section className="py-24 px-6">
      <div className="max-w-5xl mx-auto">
        <div className="text-center mb-16">
          <h2 className="text-4xl font-bold text-heading mb-4">Interview prep is broken.</h2>
          <p className="text-muted text-lg max-w-lg mx-auto">Here's how most developers prepare — and why it doesn't work.</p>
        </div>

        <div className="grid md:grid-cols-2 gap-6">
          {/* Old way */}
          <div className="bg-panel rounded-xl border border-red-900/40 p-6">
            <div className="flex items-center gap-2 mb-6">
              <span className="text-base">😩</span>
              <h3 className="text-sm font-semibold text-soft uppercase tracking-wider">The Old Way</h3>
            </div>
            <div className="space-y-3">
              {problems.map((p) => (
                <div key={p} className="flex items-start gap-3">
                  <span className="text-danger mt-0.5 font-bold shrink-0">✗</span>
                  <span className="text-sm text-muted">{p}</span>
                </div>
              ))}
            </div>
          </div>

          {/* DevReady way */}
          <div
            className="bg-panel rounded-xl border border-success/30 p-6"
            style={{ background: 'linear-gradient(135deg, rgba(16,185,129,0.04), transparent)' }}
          >
            <div className="flex items-center gap-2 mb-6">
              <span className="text-base">🚀</span>
              <h3 className="text-sm font-semibold text-soft uppercase tracking-wider">The DevReady Way</h3>
            </div>
            <div className="space-y-3">
              {solutions.map((s) => (
                <div key={s} className="flex items-start gap-3">
                  <span className="text-success mt-0.5 font-bold shrink-0">✓</span>
                  <span className="text-sm text-primary">{s}</span>
                </div>
              ))}
            </div>
          </div>
        </div>
      </div>
    </section>
  );
}

/* ── Features ────────────────────────────────────────────────────── */
function Features() {
  const features = [
    {
      icon: "📚",
      title: "Structured Topics",
      desc: "15+ topics organized from fundamentals to advanced — React, JavaScript, System Design, DSA, and more.",
    },
    {
      icon: "📊",
      title: "Progress Tracking",
      desc: "Visual progress rings and bars per topic. See exactly how much you've covered at a glance.",
    },
    {
      icon: "✓",
      title: "Question Status",
      desc: "Mark questions To Do, In Progress, or Done. Never lose track of where you left off.",
    },
    {
      icon: "⚡",
      title: "Fast Navigation",
      desc: "Keyboard-first design — use arrow keys or N/P shortcuts to move through questions instantly.",
    },
    {
      icon: "🔍",
      title: "Instant Search",
      desc: "Find any question across all topics in milliseconds. Filter by difficulty level too.",
    },
    {
      icon: "🎯",
      title: "Difficulty Levels",
      desc: "Questions tagged Basic, Intermediate, and Advanced. Prepare strategically at your level.",
    },
  ];

  return (
    <section id="features" className="py-24 px-6 bg-panel/40">
      <div className="max-w-5xl mx-auto">
        <div className="text-center mb-16">
          <p className="text-accent text-xs font-semibold tracking-widest uppercase mb-3">Features</p>
          <h2 className="text-4xl font-bold text-heading mb-4">Built for how developers actually prepare</h2>
          <p className="text-muted text-lg max-w-lg mx-auto">Every feature exists to keep you focused and moving forward.</p>
        </div>

        <div className="grid sm:grid-cols-2 lg:grid-cols-3 gap-4">
          {features.map((f) => (
            <div
              key={f.title}
              className="bg-panel border border-border rounded-xl p-6 hover:border-accent/40 transition-colors duration-200"
              style={{ boxShadow: 'var(--shadow-card)' }}
            >
              <div className="w-10 h-10 rounded-lg bg-accent/10 border border-accent/20 flex items-center justify-center text-lg mb-4">
                {f.icon}
              </div>
              <h3 className="text-sm font-semibold text-bright mb-2">{f.title}</h3>
              <p className="text-xs text-muted leading-relaxed">{f.desc}</p>
            </div>
          ))}
        </div>
      </div>
    </section>
  );
}

/* ── Stats ───────────────────────────────────────────────────────── */
function Stats() {
  const stats = [
    { number: "500+", label: "Interview Questions" },
    { number: "15+",  label: "Topics Covered" },
    { number: "3",    label: "Difficulty Levels" },
    { number: "100%", label: "Free to Use" },
  ];

  return (
    <section className="py-16 px-6 border-y border-border bg-panel/60">
      <div className="max-w-4xl mx-auto grid grid-cols-2 md:grid-cols-4 divide-x divide-border">
        {stats.map((s) => (
          <div key={s.label} className="text-center py-6 px-4">
            <div className="text-4xl md:text-5xl font-extrabold text-heading mb-1 tabular-nums">{s.number}</div>
            <div className="text-xs text-muted font-medium">{s.label}</div>
          </div>
        ))}
      </div>
    </section>
  );
}

/* ── Journey ─────────────────────────────────────────────────────── */
function Journey() {
  const steps = [
    { n: "01", label: "Choose Topic",       sub: "Pick what you need to prepare" },
    { n: "02", label: "Read & Learn",        sub: "Detailed answers, not just bullet points" },
    { n: "03", label: "Track Progress",      sub: "Mark questions as you go" },
    { n: "04", label: "Build Confidence",    sub: "Watch your completion grow" },
    { n: "05", label: "Crack Interviews",    sub: "Walk in prepared", highlight: true },
  ];

  return (
    <section className="py-24 px-6">
      <div className="max-w-5xl mx-auto">
        <div className="text-center mb-16">
          <p className="text-accent text-xs font-semibold tracking-widest uppercase mb-3">The Path</p>
          <h2 className="text-4xl font-bold text-heading mb-4">Your path to interview confidence</h2>
        </div>

        {/* Desktop: horizontal */}
        <div className="hidden md:flex items-start gap-0">
          {steps.map((s, i) => (
            <div key={s.n} className="flex-1 flex items-start">
              <div className="flex-1 flex flex-col items-center text-center px-2">
                <div
                  className={`w-12 h-12 rounded-full border-2 flex items-center justify-center text-sm font-bold mb-3 transition-all ${
                    s.highlight
                      ? "bg-accent border-accent text-white"
                      : "bg-accent/10 border-accent/40 text-accent"
                  }`}
                  style={s.highlight ? { boxShadow: 'var(--shadow-glow)' } : {}}
                >
                  {s.n}
                </div>
                <p className={`text-sm font-semibold mb-1 ${s.highlight ? "text-accent" : "text-bright"}`}>{s.label}</p>
                <p className="text-xs text-muted leading-relaxed">{s.sub}</p>
              </div>
              {i < steps.length - 1 && (
                <div className="w-8 h-px bg-border mt-6 shrink-0" />
              )}
            </div>
          ))}
        </div>

        {/* Mobile: vertical */}
        <div className="md:hidden space-y-4">
          {steps.map((s) => (
            <div
              key={s.n}
              className={`flex items-start gap-4 p-4 rounded-xl border ${
                s.highlight ? "border-accent/40 bg-accent/5" : "border-border bg-panel"
              }`}
            >
              <div
                className={`w-10 h-10 rounded-full border-2 flex items-center justify-center text-xs font-bold shrink-0 ${
                  s.highlight ? "bg-accent border-accent text-white" : "bg-accent/10 border-accent/40 text-accent"
                }`}
              >
                {s.n}
              </div>
              <div>
                <p className={`text-sm font-semibold ${s.highlight ? "text-accent" : "text-bright"}`}>{s.label}</p>
                <p className="text-xs text-muted mt-0.5">{s.sub}</p>
              </div>
            </div>
          ))}
        </div>
      </div>
    </section>
  );
}

/* ── Testimonials ────────────────────────────────────────────────── */
function Testimonials() {
  const testimonials = [
    {
      stars: 5,
      quote: "Finally an interview prep tool that doesn't feel like homework. The structured path kept me consistent for 3 weeks straight. Got my Flipkart offer.",
      name: "Rahul M.",
      role: "SDE-2 at Flipkart",
      initials: "RM",
      color: "#6366f1",
    },
    {
      stars: 5,
      quote: "I love that I can see exactly what I've covered. The difficulty levels helped me stop wasting time on things I already know solid.",
      name: "Priya K.",
      role: "Frontend Engineer at Razorpay",
      initials: "PK",
      color: "#10b981",
    },
    {
      stars: 5,
      quote: "Used this alongside LeetCode for campus placements. The conceptual questions here filled the gaps that pure coding practice never could.",
      name: "Arjun S.",
      role: "CS Graduate, now at Infosys",
      initials: "AS",
      color: "#f59e0b",
    },
  ];

  return (
    <section className="py-24 px-6 bg-panel/40">
      <div className="max-w-5xl mx-auto">
        <div className="text-center mb-16">
          <p className="text-accent text-xs font-semibold tracking-widest uppercase mb-3">Testimonials</p>
          <h2 className="text-4xl font-bold text-heading mb-4">Developers who cracked it</h2>
        </div>

        <div className="grid md:grid-cols-3 gap-5">
          {testimonials.map((t) => (
            <div
              key={t.name}
              className="bg-panel border border-border rounded-xl p-6 flex flex-col gap-4"
              style={{ boxShadow: 'var(--shadow-card)' }}
            >
              <div className="flex gap-0.5">
                {Array.from({ length: t.stars }).map((_, i) => (
                  <span key={i} className="text-warning text-sm">★</span>
                ))}
              </div>
              <p className="text-sm text-muted leading-relaxed flex-1">"{t.quote}"</p>
              <div className="flex items-center gap-3">
                <div
                  className="w-9 h-9 rounded-full flex items-center justify-center text-xs font-bold text-white shrink-0"
                  style={{ background: t.color + '33', color: t.color, border: `1px solid ${t.color}40` }}
                >
                  {t.initials}
                </div>
                <div>
                  <p className="text-xs font-semibold text-bright">{t.name}</p>
                  <p className="text-[11px] text-muted">{t.role}</p>
                </div>
              </div>
            </div>
          ))}
        </div>
      </div>
    </section>
  );
}

/* ── FAQ ─────────────────────────────────────────────────────────── */
function FAQ() {
  const [open, setOpen] = useState(null);
  const items = [
    {
      q: "Is DevReady free to use?",
      a: "Yes, completely free. No credit card, no trial — just sign up and start preparing.",
    },
    {
      q: "What topics are covered?",
      a: "React, JavaScript, TypeScript, System Design, DSA, CSS, Node.js, Git, and more. New topics are added regularly.",
    },
    {
      q: "How is progress tracked?",
      a: "Mark each question as To Do, In Progress, or Done. Your progress syncs to your account so it's available everywhere.",
    },
    {
      q: "Does it work on mobile?",
      a: "Yes. DevReady is fully responsive — the sidebar becomes a slide-in drawer on mobile so you have the full screen for reading.",
    },
    {
      q: "How is this different from GeeksForGeeks?",
      a: "DevReady is curated and structured, not a wiki. Every answer is written for interview context, difficulty is clearly labeled, and your progress is tracked end-to-end.",
    },
    {
      q: "Do I need to create an account?",
      a: "You can explore without an account, but signing in syncs your progress to the cloud so you don't lose it.",
    },
  ];

  return (
    <section id="faq" className="py-24 px-6">
      <div className="max-w-2xl mx-auto">
        <div className="text-center mb-16">
          <h2 className="text-4xl font-bold text-heading mb-4">Questions?</h2>
          <p className="text-muted text-lg">We've got answers.</p>
        </div>

        <div className="space-y-1">
          {items.map((item, i) => (
            <div key={i} className="border-b border-border">
              <button
                className="flex items-center justify-between w-full py-4 text-left cursor-pointer group"
                onClick={() => setOpen(open === i ? null : i)}
              >
                <span className={`text-sm font-medium transition-colors ${open === i ? "text-bright" : "text-primary group-hover:text-bright"}`}>
                  {item.q}
                </span>
                <svg
                  width="16" height="16" viewBox="0 0 16 16" fill="none"
                  className={`shrink-0 text-muted transition-transform duration-200 ml-4 ${open === i ? "rotate-180" : ""}`}
                >
                  <path d="M4 6l4 4 4-4" stroke="currentColor" strokeWidth="1.5" strokeLinecap="round" strokeLinejoin="round"/>
                </svg>
              </button>
              {open === i && (
                <p className="text-sm text-muted leading-relaxed pb-4">{item.a}</p>
              )}
            </div>
          ))}
        </div>
      </div>
    </section>
  );
}

/* ── Final CTA ───────────────────────────────────────────────────── */
function FinalCTA({ onGetStarted }) {
  return (
    <section className="py-32 px-6 text-center relative overflow-hidden">
      <div
        className="absolute inset-0 pointer-events-none"
        style={{
          background: 'radial-gradient(ellipse 80% 60% at 50% 110%, rgba(99,102,241,0.15) 0%, transparent 65%)',
        }}
      />
      <div className="relative max-w-2xl mx-auto">
        <h2 className="text-4xl md:text-5xl font-extrabold text-heading mb-5 leading-tight">
          Ready to prepare<br />the right way?
        </h2>
        <p className="text-lg text-muted mb-10 max-w-md mx-auto">
          Join developers who chose structure over chaos. Start for free — no signup friction.
        </p>
        <PrimaryBtn onClick={onGetStarted} className="h-13 px-10 text-base">
          Start Preparing — It's Free →
        </PrimaryBtn>
        <p className="text-xs text-ghost mt-4">No credit card. No trial. Just prep.</p>
      </div>
    </section>
  );
}

/* ── Footer ──────────────────────────────────────────────────────── */
function Footer() {
  return (
    <footer className="border-t border-border py-10 px-6 bg-panel/60">
      <div className="max-w-5xl mx-auto flex flex-col md:flex-row items-center justify-between gap-4">
        <div className="flex items-center gap-2 font-bold text-soft select-none">
          <div className="w-6 h-6 rounded-md bg-accent flex items-center justify-center text-white text-xs font-bold">D</div>
          DevReady
        </div>
        <p className="text-xs text-ghost text-center">
          Made for developers, by developers. &copy; {new Date().getFullYear()} DevReady.
        </p>
        <div className="flex gap-5">
          <a href="#" className="text-xs text-muted hover:text-primary transition-colors">Privacy</a>
          <a href="#" className="text-xs text-muted hover:text-primary transition-colors">Terms</a>
          <a href="#" className="text-xs text-muted hover:text-primary transition-colors">Contact</a>
        </div>
      </div>
    </footer>
  );
}

/* ── LandingPage (root export) ───────────────────────────────────── */
export default function LandingPage({ onGetStarted, onSignIn }) {
  const [scrolled, setScrolled] = useState(false);

  useEffect(() => {
    const el = document.querySelector(".landing-scroll");
    if (!el) return;
    const handler = () => setScrolled(el.scrollTop > 40);
    el.addEventListener("scroll", handler, { passive: true });
    return () => el.removeEventListener("scroll", handler);
  }, []);

  return (
    <div className="landing-scroll bg-surface text-primary" style={{ height: '100vh', overflowY: 'auto' }}>
      <Navbar onSignIn={onSignIn} onGetStarted={onGetStarted} scrolled={scrolled} />
      <Hero onGetStarted={onGetStarted} />
      <Stats />
      <ProblemSolution />
      <Features />
      <Journey />
      <Testimonials />
      <FAQ />
      <FinalCTA onGetStarted={onGetStarted} />
      <Footer />
    </div>
  );
}
