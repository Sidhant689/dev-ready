# DevReady — Feature Tracker

Cross-referenced against the full product research doc. Every feature is either
✅ **Done**, 🔧 **Partial**, or ❌ **Not built** with notes on what's missing.

---

## 1. Landing Page

| Feature | Status | Notes |
|---|---|---|
| Hero section (headline, CTA, product mockup) | ✅ Done | Full hero with AppMockup, PrimaryBtn, GhostBtn |
| Navbar (logo, links, scroll-fade effect) | ✅ Done | Fixed navbar with backdrop-blur on scroll |
| Stats section (question count, topics) | ✅ Done | Numeric stat cards |
| Problem / Solution section | ✅ Done | Pain points vs DevReady solutions |
| Feature showcase sections | ✅ Done | Cards for each capability |
| Product preview / screenshot mockup | ✅ Done | AppMockup component in hero |
| Developer journey / roadmap steps | ✅ Done | Step-by-step horizontal journey section |
| Testimonials | ✅ Done | Quote cards |
| FAQ (expandable) | ✅ Done | Accordion-style FAQ |
| Final CTA section | ✅ Done | Full-width bottom CTA |
| Footer | ✅ Done | Links + copyright |
| Open Graph / SEO meta tags | 🔧 Partial | Title + description in index.html; no per-page OG image or sitemap |

---

## 2. Authentication

| Feature | Status | Notes |
|---|---|---|
| Email + password sign in / sign up | ✅ Done | Via Supabase Auth |
| Google OAuth | ✅ Done | Supabase provider |
| GitHub OAuth | ✅ Done | Supabase provider |
| Auth modal (no full-page redirect) | ✅ Done | Overlay modal, tab-less, mode prop |
| Guest explore (no forced login) | ✅ Done | First 3 questions free per section |
| Guest → sign-in flow from locked content | ✅ Done | GuestGate + QuestionList upsell banner |
| Auto-navigate to app after login | ✅ Done | useRoute hook detects user change |
| Sign-out with avatar dropdown | ✅ Done | TopBar user avatar group-hover dropdown |
| Forgot password flow | ❌ Not built | — |
| Email confirmation notice after signup | ❌ Not built | — |
| Full name field on registration | ❌ Not built | Removed after it broke saving; intentionally kept out |

---

## 3. App Shell & Navigation

| Feature | Status | Notes |
|---|---|---|
| Sidebar with topic list | ✅ Done | w-64 panel with emoji icons, color dots |
| Per-topic progress ring (SVG) | ✅ Done | ProgressRing SVG component |
| Per-topic progress bar (thin line) | ✅ Done | Always visible below topic row |
| Done/total count in sidebar | ✅ Done | Shown when topic is collapsed |
| Section list (collapsible under topic) | ✅ Done | Chevron toggle, border-l-2 active indicator |
| Mobile sidebar drawer | ✅ Done | Absolute positioned + overlay + hamburger |
| TopBar with global progress bar | ✅ Done | Gradient fill, % label, done/total count |
| Streak badge in TopBar | ✅ Done | 🔥 N-day shown on md+ screens |
| Search button in TopBar | ✅ Done | Opens GlobalSearch modal |
| User avatar + sign-out dropdown | ✅ Done | Initials avatar, name/email, sign out |
| Loading spinner while auth resolves | ✅ Done | Spin animation in App root |

---

## 4. Question Browsing & Reading

| Feature | Status | Notes |
|---|---|---|
| Section header with done/total | ✅ Done | QuestionList header |
| Section progress bar | ✅ Done | Thin bar under header |
| Search within section | ✅ Done | Live filter input |
| Difficulty filter within section | ✅ Done | Dropdown select from Supabase difficulty_levels |
| Question list with status dots | ✅ Done | StatusDot component (circle, half, check) |
| Lock icon + "Sign in" for guests | ✅ Done | Beyond GUEST_FREE_LIMIT = 3 |
| Guest upsell banner in list | ✅ Done | Bottom of QuestionList |
| Difficulty badge on each question | ✅ Done | Badge component |
| Cache indicator (⚡) | ✅ Done | Shows when answer is locally cached |
| Question detail — breadcrumb | ✅ Done | Topic › Section |
| Question detail — difficulty badge | ✅ Done | |
| Question detail — status pill (cycling) | ✅ Done | To Do → In Progress → Done → loop |
| Question detail — read time estimate | ✅ Done | Word count → minutes |
| Markdown answer rendering | ✅ Done | renderMarkdown + .prose-answer CSS |
| Code blocks with syntax styling | ✅ Done | .prose-answer pre/code styles |
| Previous / Next navigation buttons | ✅ Done | With disabled state |
| Keyboard shortcuts (← → N P Esc) | ✅ Done | Global keydown listener |
| Jump-to-question dropdown (bottom nav) | ✅ Done | Select with Q index + truncated text |
| "Answer coming soon" empty state | ✅ Done | |
| GuestGate for locked questions | ✅ Done | Full-page lock with sign-in/sign-up CTAs |

---

## 5. Three New Features (just shipped)

| Feature | Status | Notes |
|---|---|---|
| **Global Search (Cmd+K / Ctrl+K)** | ✅ Done | Modal, live ilike Supabase query, keyboard nav, guest-lock after 3 |
| **Notes per Question** | ✅ Done | Auto-save textarea; Supabase `user_notes` for logged-in, localStorage for guests. **Needs DB migration** — run `supabase/04_user_notes_table.sql` |
| **Interview Mode** | ✅ Done | Toggle with I key or button; hides answer; Reveal on click or Space; per-question reset |
| Answer / Notes tab switcher | ✅ Done | Inline tab pills in question header |

---

## 6. Progress & Gamification

| Feature | Status | Notes |
|---|---|---|
| Question status tracking (3 states) | ✅ Done | Cloud-synced for users, localStorage for guests |
| Cloud progress sync (Supabase) | ✅ Done | user_progress table, upsert on conflict |
| Local→cloud sync on first login | ✅ Done | useStatuses merges localStorage into Supabase |
| Learning streak (daily) | ✅ Done | useStreak hook, localStorage |
| Weekly goal tracking | ✅ Done | useWeeklyGoal, resets Sunday, sidebar bar |
| Topic completion toast | ✅ Done | Fire when done === total, celebrated Set |
| Streak + weekly goal in sidebar footer | ✅ Done | |
| Badges / achievements system | ❌ Not built | "First 10 questions", "Topic Master", etc. |
| Topic completion summary page | ❌ Not built | Stats modal on 100% topic, shareable |
| Daily question / "question of the day" | ❌ Not built | |
| Continue where you left off | ❌ Not built | Needs `last_question_id` in users table |
| Confetti / milestone animations | ❌ Not built | |

---

## 7. Admin Portal

> Nothing in `/admin` exists yet. Full build needed.

| Feature | Status | Notes |
|---|---|---|
| Secure `/admin` route (role-gated) | ❌ Not built | Need `user_role` JWT claim + route guard |
| Admin login (only role=admin allowed) | ❌ Not built | |
| RBAC — `user_role` in JWT / RLS policies | ❌ Not built | Supabase custom claim + DB policies |
| Admin dashboard (stats overview) | ❌ Not built | Total users, questions, active users, charts |
| Topic CRUD (create/edit/delete/reorder) | ❌ Not built | |
| Section CRUD (per topic) | ❌ Not built | |
| Question CRUD (with difficulty, tags) | ❌ Not built | |
| Markdown editor + live preview (answers) | ❌ Not built | Split-pane editor for answer content |
| Bulk import questions (CSV/JSON) | ❌ Not built | |
| Bulk export questions | ❌ Not built | |
| Bulk actions (select many → change/delete) | ❌ Not built | |
| User management (list, search, filter) | ❌ Not built | View join date, stats, last active |
| View individual user profile/stats | ❌ Not built | |
| Suspend / delete user | ❌ Not built | |
| Analytics — DAU / WAU / MAU charts | ❌ Not built | |
| Analytics — top topics/questions | ❌ Not built | |
| Analytics — retention / cohorts | ❌ Not built | |
| Moderation / feedback inbox | ❌ Not built | |
| Announcements / site-wide banners | ❌ Not built | |
| SEO settings (meta/OG per page) | ❌ Not built | |
| Site config (logo, title, footer) | ❌ Not built | |
| Audit log (who edited what, when) | ❌ Not built | |
| Drag-and-drop reorder topics/sections | ❌ Not built | |

---

## 8. User Dashboard (Post-Login)

> Currently there is no personal dashboard — user goes straight to the question browser after login.

| Feature | Status | Notes |
|---|---|---|
| Welcome screen / personal dashboard | ❌ Not built | "Hello [Name]! Ready to practice today?" |
| Overall stats cards (done, %, streak) | ❌ Not built | Currently only in TopBar and Sidebar |
| Continue where you left off | ❌ Not built | |
| Recently viewed questions | ❌ Not built | localStorage-only, no UI |
| Recommended next topic | ❌ Not built | Surface topics with 0% progress |
| Activity timeline / history | ❌ Not built | |

---

## 9. Bookmarks & Discovery

| Feature | Status | Notes |
|---|---|---|
| Bookmark / save a question | ❌ Not built | Needs `user_bookmarks` table + UI |
| Bookmarks section in sidebar | ❌ Not built | |
| Company-based question tags/filter | ❌ Not built | Needs `company_tags TEXT[]` column on questions |
| Interview checklist by role (FE/BE/FS) | ❌ Not built | |

---

## 10. Practice Modes

| Feature | Status | Notes |
|---|---|---|
| Interview Mode (hide/reveal answer) | ✅ Done | See §5 |
| Topic-based quiz mode (10 Qs, scored) | ❌ Not built | Random Qs, end-of-session score |
| Difficulty-based study plan | ❌ Not built | "N days to interview" daily plan generator |
| Spaced repetition | ❌ Not built | Resurface "In Progress" after N days |
| Timed interview simulation | ❌ Not built | No-going-back, timer-per-question |

---

## 11. Sharing & Growth

| Feature | Status | Notes |
|---|---|---|
| Share a question (public URL /q/:id) | ❌ Not built | OG tags for social preview |
| Referral / invite link | ❌ Not built | |
| Topic completion shareable image | ❌ Not built | |

---

## 12. Design System & UI Polish

| Feature | Status | Notes |
|---|---|---|
| Dark theme (hardcoded) | ✅ Done | CSS variables in @theme |
| Inter font + JetBrains Mono | ✅ Done | Google Fonts preconnect in index.html |
| Design tokens (accent, success, warning, danger…) | ✅ Done | Extended @theme in index.css |
| .prose-answer markdown styles | ✅ Done | Full h1-table-blockquote styles |
| Badge component (difficulty) | ✅ Done | |
| Spinner component | ✅ Done | |
| Toast notification | ✅ Done | Auto-dismiss 3500ms |
| Light / Dark mode toggle | ❌ Not built | Currently hardcoded dark only |
| Mobile responsive (core flows) | ✅ Done | Sidebar drawer, TopBar hamburger |
| Micro-animations (hover, transitions) | 🔧 Partial | Transitions on buttons/bars; no entry animations |

---

## 13. Database / Backend

| Migration file | Status | Notes |
|---|---|---|
| `01_users_table.sql` | ✅ Done | public.users with RLS |
| `02_user_progress_table.sql` | ✅ Done | UNIQUE(user_id, question_id), RLS |
| `03_auto_create_profile_trigger.sql` | ✅ Done | handle_new_user SECURITY DEFINER |
| `04_user_notes_table.sql` | ⚠️ Needs running | File exists — paste into Supabase SQL editor |
| `user_bookmarks` table | ❌ Not built | Needed for bookmarks feature |
| `last_question_id` on users table | ❌ Not built | Needed for "continue" feature |
| `company_tags TEXT[]` on questions | ❌ Not built | Needed for company filter |
| Admin role claim + RLS policies | ❌ Not built | Needed for admin portal |

---

## Priority Order for Next Builds

### Phase 1 — High value, lower effort
1. **Run `04_user_notes_table.sql`** in Supabase (5 min) — unblocks Notes feature
2. **User dashboard page** — personal home after login with stats, streak, continue
3. **Bookmarks** — star icon + `user_bookmarks` table + sidebar section
4. **Dark/Light mode toggle** — CSS variable swap, localStorage preference

### Phase 2 — Admin (biggest effort, enables content management)
5. **RBAC setup** — `user_role` JWT claim, Supabase function, seed admin user
6. **Admin route guard** — `/admin` protected by role check
7. **Admin: Topic + Section CRUD**
8. **Admin: Question + Answer editor** (split-pane markdown)
9. **Admin: User list**
10. **Admin: Basic analytics** (counts + simple charts)

### Phase 3 — Growth & engagement
11. **Share a question** — `/q/:id` public route + OG tags
12. **Badges / achievements**
13. **Quiz mode** (topic-based, scored)
14. **Company filter** on questions
15. **Bulk import** (CSV → questions table)

---

## Ideas Pool (Undecided)

- AI "Explain differently" button per question (OpenAI / Claude API)
- Voice read-aloud for answers
- Peer-submitted answer variants (moderated)
- Interview readiness score per topic (% done × difficulty weight)
- Offline mode (service worker + cached questions)
