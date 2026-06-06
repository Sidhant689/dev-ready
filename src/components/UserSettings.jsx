import { useState, useEffect } from "react";
import { supabase } from "../config/supabaseClient";
import { getSavedGoal } from "../hooks/useWeeklyGoal";

const GOAL_OPTIONS = [5, 10, 15, 20, 25, 30, 40, 50];

function Section({ title, children }) {
  return (
    <div className="border-b border-border last:border-0 px-6 py-5">
      <h3 className="text-xs font-semibold tracking-widest uppercase text-ghost mb-4">{title}</h3>
      <div className="space-y-4">{children}</div>
    </div>
  );
}

function Field({ label, hint, children }) {
  return (
    <div className="flex items-start justify-between gap-6">
      <div className="min-w-0">
        <p className="text-sm font-medium text-primary">{label}</p>
        {hint && <p className="text-xs text-muted mt-0.5 leading-relaxed">{hint}</p>}
      </div>
      <div className="shrink-0">{children}</div>
    </div>
  );
}

export default function UserSettings({ user, theme, onToggleTheme, weekGoal, onSetWeekGoal, onClose, onSignOut }) {
  const displayName = user?.user_metadata?.full_name || user?.email?.split("@")[0] || "";
  const email = user?.email || "";

  const [name, setName] = useState(displayName);
  const [nameSaving, setNameSaving] = useState(false);
  const [nameSaved, setNameSaved] = useState(false);
  const [nameError, setNameError] = useState("");

  const [localGoal, setLocalGoal] = useState(weekGoal || getSavedGoal());

  useEffect(() => { setLocalGoal(weekGoal); }, [weekGoal]);

  async function saveName() {
    if (!name.trim() || name.trim() === displayName) return;
    setNameSaving(true);
    setNameError("");
    try {
      // Update Supabase auth metadata
      const { error: authErr } = await supabase.auth.updateUser({ data: { full_name: name.trim() } });
      if (authErr) throw authErr;
      // Update public.users table
      await supabase.from("users").update({ full_name: name.trim() }).eq("id", user.id);
      setNameSaved(true);
      setTimeout(() => setNameSaved(false), 2500);
    } catch (e) {
      setNameError(e.message || "Failed to save");
    }
    setNameSaving(false);
  }

  function handleGoalChange(val) {
    setLocalGoal(val);
    onSetWeekGoal(val);
  }

  const initials = (name || displayName || "?")
    .split(" ").map((w) => w[0]).join("").slice(0, 2).toUpperCase();

  return (
    <div
      className="fixed inset-0 z-50 flex items-center justify-center p-4"
      style={{ background: "rgba(0,0,0,0.6)", backdropFilter: "blur(4px)" }}
      onClick={(e) => { if (e.target === e.currentTarget) onClose(); }}
    >
      <div className="w-full max-w-md bg-panel border border-border rounded-2xl overflow-hidden"
           style={{ boxShadow: "0 25px 60px rgba(0,0,0,0.5)" }}>

        {/* Header */}
        <div className="flex items-center justify-between px-6 py-4 border-b border-border">
          <h2 className="text-sm font-semibold text-bright">Settings</h2>
          <button onClick={onClose} className="text-ghost hover:text-muted transition-colors cursor-pointer text-lg">✕</button>
        </div>

        <div className="overflow-y-auto max-h-[70vh]">

          {/* Profile */}
          <Section title="Profile">
            {/* Avatar */}
            <div className="flex items-center gap-4">
              <div className="w-14 h-14 rounded-2xl bg-accent/20 border border-accent/30 text-accent font-bold text-xl flex items-center justify-center shrink-0">
                {initials}
              </div>
              <div className="min-w-0">
                <p className="text-sm font-semibold text-bright truncate">{name || displayName}</p>
                <p className="text-xs text-muted truncate">{email}</p>
              </div>
            </div>

            {/* Display name */}
            <Field label="Display Name" hint="Shown in your dashboard greeting and profile.">
              <div className="flex items-center gap-2">
                <input
                  type="text"
                  value={name}
                  onChange={(e) => { setName(e.target.value); setNameSaved(false); }}
                  className="h-8 w-36 px-3 rounded-lg bg-surface border border-border text-primary text-xs outline-none focus:border-accent transition-colors"
                  placeholder="Your name"
                  onKeyDown={(e) => e.key === "Enter" && saveName()}
                />
                <button
                  onClick={saveName}
                  disabled={nameSaving || !name.trim() || name.trim() === displayName}
                  className="h-8 px-3 rounded-lg bg-accent hover:bg-accent-hover text-white text-xs font-medium transition-colors cursor-pointer disabled:opacity-40 disabled:cursor-not-allowed"
                >
                  {nameSaving ? "…" : nameSaved ? "✓" : "Save"}
                </button>
              </div>
              {nameError && <p className="text-[11px] text-danger mt-1">{nameError}</p>}
            </Field>
          </Section>

          {/* Goals */}
          <Section title="Goals">
            <Field
              label="Weekly Question Goal"
              hint="How many questions you aim to answer each week. Resets every Sunday."
            >
              <div className="flex items-center gap-2">
                <span className="text-2xl font-bold text-accent tabular-nums w-8 text-right">{localGoal}</span>
                <span className="text-xs text-muted">/ week</span>
              </div>
            </Field>

            {/* Goal picker chips */}
            <div className="flex flex-wrap gap-2">
              {GOAL_OPTIONS.map((n) => (
                <button
                  key={n}
                  onClick={() => handleGoalChange(n)}
                  className={`h-8 w-12 rounded-lg text-xs font-semibold transition-all cursor-pointer ${
                    localGoal === n
                      ? "bg-accent text-white"
                      : "bg-hover border border-border text-muted hover:border-accent/50 hover:text-primary"
                  }`}
                >
                  {n}
                </button>
              ))}
            </div>

            <p className="text-[11px] text-ghost">
              {localGoal <= 10 ? "Steady pace — great for busy weeks." :
               localGoal <= 20 ? "Balanced — recommended for most learners." :
               localGoal <= 30 ? "Ambitious — you're committed!" :
               "Intense prep mode — interview soon?"}
            </p>
          </Section>

          {/* Preferences */}
          <Section title="Preferences">
            <Field label="Theme" hint="Switch between dark and light mode.">
              <button
                onClick={onToggleTheme}
                className={`relative w-12 h-6 rounded-full transition-colors cursor-pointer ${
                  theme === "light" ? "bg-accent" : "bg-hover border border-border"
                }`}
              >
                <span
                  className={`absolute top-0.5 w-5 h-5 rounded-full bg-white shadow transition-transform ${
                    theme === "light" ? "translate-x-6" : "translate-x-0.5"
                  }`}
                />
              </button>
            </Field>
            <Field label="Current mode" hint="">
              <span className="text-xs text-muted">
                {theme === "dark" ? "🌙 Dark" : "☀️ Light"}
              </span>
            </Field>
          </Section>

          {/* Account */}
          <Section title="Account">
            <Field label="Email" hint="Your sign-in email address.">
              <span className="text-xs text-muted font-mono">{email}</span>
            </Field>
            <Field label="Sign out" hint="Sign out of your account on this device.">
              <button
                onClick={onSignOut}
                className="h-8 px-3 rounded-lg bg-danger/10 hover:bg-danger/20 border border-danger/30 text-danger text-xs font-medium transition-colors cursor-pointer"
              >
                Sign out
              </button>
            </Field>
          </Section>
        </div>
      </div>
    </div>
  );
}
