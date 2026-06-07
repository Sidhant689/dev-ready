import { useState, useEffect } from "react";
import { supabase } from "../config/supabaseClient";

function GoogleIcon() {
  return (
    <svg width="18" height="18" viewBox="0 0 18 18" fill="none">
      <path d="M17.64 9.2c0-.637-.057-1.251-.164-1.84H9v3.481h4.844a4.14 4.14 0 01-1.796 2.716v2.259h2.908c1.702-1.567 2.684-3.875 2.684-6.616z" fill="#4285F4"/>
      <path d="M9 18c2.43 0 4.467-.806 5.956-2.18l-2.908-2.259c-.806.54-1.837.86-3.048.86-2.344 0-4.328-1.584-5.036-3.711H.957v2.332A8.997 8.997 0 009 18z" fill="#34A853"/>
      <path d="M3.964 10.71A5.41 5.41 0 013.682 9c0-.593.102-1.17.282-1.71V4.958H.957A8.996 8.996 0 000 9c0 1.452.348 2.827.957 4.042l3.007-2.332z" fill="#FBBC05"/>
      <path d="M9 3.58c1.321 0 2.508.454 3.44 1.345l2.582-2.58C13.463.891 11.426 0 9 0A8.997 8.997 0 00.957 4.958L3.964 7.29C4.672 5.163 6.656 3.58 9 3.58z" fill="#EA4335"/>
    </svg>
  );
}

function GitHubIcon() {
  return (
    <svg width="18" height="18" viewBox="0 0 24 24" fill="currentColor">
      <path d="M12 2C6.477 2 2 6.484 2 12.017c0 4.425 2.865 8.18 6.839 9.504.5.092.682-.217.682-.483 0-.237-.008-.868-.013-1.703-2.782.605-3.369-1.343-3.369-1.343-.454-1.158-1.11-1.466-1.11-1.466-.908-.62.069-.608.069-.608 1.003.07 1.531 1.032 1.531 1.032.892 1.53 2.341 1.088 2.91.832.092-.647.35-1.088.636-1.338-2.22-.253-4.555-1.113-4.555-4.951 0-1.093.39-1.988 1.029-2.688-.103-.253-.446-1.272.098-2.65 0 0 .84-.27 2.75 1.026A9.564 9.564 0 0112 6.844c.85.004 1.705.115 2.504.337 1.909-1.296 2.747-1.027 2.747-1.027.546 1.379.202 2.398.1 2.651.64.7 1.028 1.595 1.028 2.688 0 3.848-2.339 4.695-4.566 4.943.359.309.678.92.678 1.855 0 1.338-.012 2.419-.012 2.747 0 .268.18.58.688.482A10.019 10.019 0 0022 12.017C22 6.484 17.522 2 12 2z"/>
    </svg>
  );
}

export default function AuthModal({
  mode = "signin",
  onClose,
  onSuccess,
  signInWithEmail,
  signUpWithEmail,
  signInWithGoogle,
  signInWithGitHub,
}) {
  const [view, setView] = useState(mode); // signin | signup | forgot | email-sent | check-email
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState("");
  const [resetSent, setResetSent] = useState(false);

  useEffect(() => {
    const handler = (e) => { if (e.key === "Escape") onClose(); };
    window.addEventListener("keydown", handler);
    return () => window.removeEventListener("keydown", handler);
  }, [onClose]);

  function switchView(v) { setView(v); setError(""); }

  async function handleSubmit(e) {
    e.preventDefault();
    setError("");

    if (!email.trim() || !password.trim()) { setError("Please fill in all fields."); return; }
    if (password.length < 6) { setError("Password must be at least 6 characters."); return; }

    setLoading(true);
    try {
      if (view === "signin") {
        await signInWithEmail(email.trim(), password);
        onSuccess?.();
      } else {
        const result = await signUpWithEmail(email.trim(), password);
        // If no session returned, email confirmation is required
        if (!result?.session) {
          setView("check-email");
        } else {
          onSuccess?.();
        }
      }
    } catch (err) {
      setError(err.message || "Something went wrong. Please try again.");
    } finally {
      setLoading(false);
    }
  }

  async function handleForgotPassword(e) {
    e.preventDefault();
    setError("");
    if (!email.trim()) { setError("Enter your email address."); return; }
    setLoading(true);
    try {
      const { error } = await supabase.auth.resetPasswordForEmail(email.trim(), {
        redirectTo: window.location.origin,
      });
      if (error) throw error;
      setResetSent(true);
    } catch (err) {
      setError(err.message || "Could not send reset email.");
    } finally {
      setLoading(false);
    }
  }

  async function handleGoogle() {
    setError("");
    try { await signInWithGoogle(); }
    catch (err) { setError(err.message); }
  }

  async function handleGitHub() {
    setError("");
    try { await signInWithGitHub(); }
    catch (err) { setError(err.message); }
  }

  // Email confirmation notice screen
  if (view === "check-email") return (
    <div className="fixed inset-0 z-100 flex items-start justify-center px-4 pt-16 pb-8"
      style={{ background: "rgba(0,0,0,0.65)", backdropFilter: "blur(6px)" }}
      onClick={(e) => { if (e.target === e.currentTarget) onClose(); }}>
      <div className="w-full max-w-sm bg-panel rounded-2xl p-7 relative text-center"
        style={{ boxShadow: "var(--shadow-modal)" }}
        onClick={(e) => e.stopPropagation()}>
        <button onClick={onClose}
          className="absolute top-4 right-4 w-7 h-7 flex items-center justify-center rounded-md text-muted hover:text-primary hover:bg-hover transition-colors cursor-pointer">
          <svg width="14" height="14" viewBox="0 0 14 14" fill="none">
            <path d="M1 1l12 12M13 1L1 13" stroke="currentColor" strokeWidth="1.5" strokeLinecap="round"/>
          </svg>
        </button>
        <div className="w-14 h-14 rounded-2xl bg-accent/10 border border-accent/20 flex items-center justify-center mx-auto mb-4">
          <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="var(--color-accent)" strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round">
            <path d="M4 4h16c1.1 0 2 .9 2 2v12c0 1.1-.9 2-2 2H4c-1.1 0-2-.9-2-2V6c0-1.1.9-2 2-2z"/>
            <polyline points="22,6 12,13 2,6"/>
          </svg>
        </div>
        <h2 className="text-xl font-bold text-heading mb-2">Check your email</h2>
        <p className="text-sm text-muted mb-1">We sent a confirmation link to:</p>
        <p className="text-sm font-semibold text-accent mb-4">{email}</p>
        <p className="text-xs text-ghost mb-6">Click the link in the email to activate your account. Check your spam folder if you don&apos;t see it.</p>
        <button onClick={onClose}
          className="w-full h-11 rounded-lg bg-accent hover:bg-accent-hover text-white font-semibold text-sm cursor-pointer transition-colors"
          style={{ boxShadow: "0 0 16px rgba(99,102,241,0.25)" }}>
          Got it
        </button>
        <button onClick={() => switchView("signin")}
          className="text-xs text-muted hover:text-accent mt-3 block mx-auto cursor-pointer transition-colors">
          Back to sign in
        </button>
      </div>
    </div>
  );

  // Forgot password screen
  if (view === "forgot") return (
    <div className="fixed inset-0 z-100 flex items-start justify-center px-4 pt-16 pb-8"
      style={{ background: "rgba(0,0,0,0.65)", backdropFilter: "blur(6px)" }}
      onClick={(e) => { if (e.target === e.currentTarget) onClose(); }}>
      <div className="w-full max-w-sm bg-panel rounded-2xl p-7 relative"
        style={{ boxShadow: "var(--shadow-modal)" }}
        onClick={(e) => e.stopPropagation()}>
        <button onClick={onClose}
          className="absolute top-4 right-4 w-7 h-7 flex items-center justify-center rounded-md text-muted hover:text-primary hover:bg-hover transition-colors cursor-pointer">
          <svg width="14" height="14" viewBox="0 0 14 14" fill="none">
            <path d="M1 1l12 12M13 1L1 13" stroke="currentColor" strokeWidth="1.5" strokeLinecap="round"/>
          </svg>
        </button>

        <div className="flex items-center gap-2 mb-6">
          <div className="w-7 h-7 rounded-lg bg-accent flex items-center justify-center text-white text-xs font-bold"
               style={{ boxShadow: "var(--shadow-glow)" }}>D</div>
          <span className="font-bold text-sm text-heading">DevReady</span>
        </div>

        {resetSent ? (
          <div className="text-center py-4">
            <div className="w-12 h-12 rounded-xl bg-success/10 border border-success/20 flex items-center justify-center mx-auto mb-4">
              <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="var(--color-success)" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                <polyline points="20 6 9 17 4 12"/>
              </svg>
            </div>
            <h2 className="text-lg font-bold text-heading mb-2">Email sent!</h2>
            <p className="text-sm text-muted mb-4">Check your inbox for a password reset link. It expires in 1 hour.</p>
            <button onClick={() => switchView("signin")}
              className="text-xs text-accent hover:underline cursor-pointer">
              Back to sign in
            </button>
          </div>
        ) : (
          <>
            <h2 className="text-xl font-bold text-heading mb-1">Reset your password</h2>
            <p className="text-sm text-muted mb-6">We&apos;ll email you a link to reset it.</p>

            <form onSubmit={handleForgotPassword} className="space-y-4">
              <div>
                <label className="text-xs font-medium text-subtle block mb-1.5">Email address</label>
                <input
                  type="email"
                  className="w-full h-11 bg-hover border border-border rounded-lg px-4 text-sm text-primary outline-none focus:border-accent transition-colors placeholder:text-ghost"
                  placeholder="you@example.com"
                  value={email}
                  onChange={(e) => setEmail(e.target.value)}
                  autoFocus
                />
              </div>

              {error && (
                <div className="flex items-start gap-2 bg-danger/10 border border-danger/20 rounded-lg px-3 py-2.5">
                  <span className="text-danger shrink-0">⚠</span>
                  <p className="text-xs text-danger leading-relaxed">{error}</p>
                </div>
              )}

              <button type="submit" disabled={loading}
                className="w-full h-11 rounded-lg bg-accent hover:bg-accent-hover text-white font-semibold text-sm transition-all cursor-pointer disabled:opacity-60"
                style={{ boxShadow: "0 0 16px rgba(99,102,241,0.25)" }}>
                {loading ? "Sending…" : "Send reset link"}
              </button>
            </form>

            <p className="text-xs text-center text-muted mt-5">
              <button onClick={() => switchView("signin")} className="text-accent hover:underline cursor-pointer">
                Back to sign in
              </button>
            </p>
          </>
        )}
      </div>
    </div>
  );

  // Sign in / Sign up
  return (
    <div
      className="fixed inset-0 z-100 flex items-start justify-center px-4 pt-16 pb-8"
      style={{ background: "rgba(0,0,0,0.65)", backdropFilter: "blur(6px)" }}
      onClick={(e) => { if (e.target === e.currentTarget) onClose(); }}
    >
      <div
        className="w-full max-w-sm bg-panel rounded-2xl p-7 relative"
        style={{ boxShadow: "var(--shadow-modal)" }}
        onClick={(e) => e.stopPropagation()}
      >
        <button onClick={onClose}
          className="absolute top-4 right-4 w-7 h-7 flex items-center justify-center rounded-md text-muted hover:text-primary hover:bg-hover transition-colors cursor-pointer">
          <svg width="14" height="14" viewBox="0 0 14 14" fill="none">
            <path d="M1 1l12 12M13 1L1 13" stroke="currentColor" strokeWidth="1.5" strokeLinecap="round"/>
          </svg>
        </button>

        <div className="flex items-center gap-2 mb-6">
          <div className="w-7 h-7 rounded-lg bg-accent flex items-center justify-center text-white text-xs font-bold"
               style={{ boxShadow: "var(--shadow-glow)" }}>D</div>
          <span className="font-bold text-sm text-heading">DevReady</span>
        </div>

        <h2 className="text-xl font-bold text-heading mb-1">
          {view === "signin" ? "Welcome back" : "Create your account"}
        </h2>
        <p className="text-sm text-muted mb-6">
          {view === "signin"
            ? "Sign in to access all questions and sync your progress"
            : "Start your interview preparation — free forever"}
        </p>

        <div className="space-y-2.5 mb-5">
          <button onClick={handleGoogle} disabled={loading}
            className="w-full h-11 flex items-center justify-center gap-3 rounded-lg bg-white text-[#1a1a1a] text-sm font-medium hover:bg-gray-100 transition-colors cursor-pointer border border-white/10 disabled:opacity-50">
            <GoogleIcon />
            Continue with Google
          </button>
          <button onClick={handleGitHub} disabled={loading}
            className="w-full h-11 flex items-center justify-center gap-3 rounded-lg text-sm font-medium transition-colors cursor-pointer border border-border text-primary hover:bg-hover disabled:opacity-50"
            style={{ background: "#21262d" }}>
            <GitHubIcon />
            Continue with GitHub
          </button>
        </div>

        <div className="flex items-center gap-3 mb-5">
          <div className="flex-1 h-px bg-border" />
          <span className="text-xs text-ghost">or</span>
          <div className="flex-1 h-px bg-border" />
        </div>

        <form onSubmit={handleSubmit} className="space-y-3">
          <div>
            <label className="text-xs font-medium text-subtle block mb-1.5">Email address</label>
            <input
              type="email"
              className="w-full h-11 bg-hover border border-border rounded-lg px-4 text-sm text-primary outline-none focus:border-accent transition-colors placeholder:text-ghost"
              placeholder="you@example.com"
              value={email}
              onChange={(e) => setEmail(e.target.value)}
              autoFocus
              autoComplete="email"
            />
          </div>
          <div>
            <div className="flex items-center justify-between mb-1.5">
              <label className="text-xs font-medium text-subtle">Password</label>
              {view === "signin" && (
                <button type="button" onClick={() => switchView("forgot")}
                  className="text-[11px] text-accent hover:underline cursor-pointer">
                  Forgot password?
                </button>
              )}
            </div>
            <input
              type="password"
              className="w-full h-11 bg-hover border border-border rounded-lg px-4 text-sm text-primary outline-none focus:border-accent transition-colors placeholder:text-ghost"
              placeholder="••••••••"
              value={password}
              onChange={(e) => setPassword(e.target.value)}
              autoComplete={view === "signin" ? "current-password" : "new-password"}
            />
          </div>

          {error && (
            <div className="flex items-start gap-2 bg-danger/10 border border-danger/20 rounded-lg px-3 py-2.5">
              <span className="text-danger shrink-0">⚠</span>
              <p className="text-xs text-danger leading-relaxed">{error}</p>
            </div>
          )}

          <button type="submit" disabled={loading}
            className="w-full h-11 rounded-lg bg-accent hover:bg-accent-hover text-white font-semibold text-sm transition-all duration-150 cursor-pointer mt-1 disabled:opacity-60 disabled:cursor-not-allowed"
            style={{ boxShadow: "0 0 16px rgba(99,102,241,0.25)" }}>
            {loading ? "Please wait…" : view === "signin" ? "Sign In" : "Create Account"}
          </button>
        </form>

        <p className="text-xs text-muted text-center mt-5">
          {view === "signin" ? (
            <>Don&apos;t have an account?{" "}
              <button onClick={() => switchView("signup")} className="text-accent hover:underline cursor-pointer font-medium">
                Sign up free
              </button>
            </>
          ) : (
            <>Already have an account?{" "}
              <button onClick={() => switchView("signin")} className="text-accent hover:underline cursor-pointer font-medium">
                Sign in
              </button>
            </>
          )}
        </p>
      </div>
    </div>
  );
}
