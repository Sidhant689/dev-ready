# DevReady — Future Features

Researched from LeetCode, AlgoExpert, GreatFrontEnd, ByteByteGo, Pramp, Educative.

---

## Easy Wins
Low effort, fits current architecture.

- [ ] **Leaderboard** — rank users by questions completed this week/month. Query `user_progress` table, new page/tab
- [ ] **Shareable profile card** — public route `/u/:id` showing streak, badges earned, % done per topic
- [ ] **Curated lists** — admin-created collections like "Blind 75", "System Design Top 20" that users can follow/track
- [ ] **Cheat sheets** — admin-editable markdown reference page per topic

---

## Medium Effort

- [ ] **Weakness report** — after 20+ SR reviews, show which topics have most "Again/Hard" ratings. Pure analytics from existing `user_progress` data
- [ ] **Daily question** — one featured question per day, push notification to subscribers
- [ ] **Study roadmap** — ordered learning path (Beginner → Mid → Senior) with locked/unlocked stages

---

## Bigger Builds

- [ ] **In-browser code runner** — Monaco editor + run code against test cases (needs sandboxed execution backend)
- [ ] **Mock interview pairing** — live peer sessions (needs WebRTC/WebSocket)
- [ ] **Contest mode** — timed competition, all users answer same questions, ranked by score
