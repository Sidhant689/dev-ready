import { supabase } from "../config/supabaseClient";

// ── Stats ─────────────────────────────────────────────────────
export async function getAdminStats() {
  const [topics, sections, questions, answers, users] = await Promise.all([
    supabase.from("topics").select("id", { count: "exact", head: true }),
    supabase.from("sections").select("id", { count: "exact", head: true }),
    supabase.from("questions").select("id", { count: "exact", head: true }),
    supabase.from("answers").select("id", { count: "exact", head: true }),
    supabase.from("users").select("id", { count: "exact", head: true }),
  ]);

  return {
    topics: topics.count ?? 0,
    sections: sections.count ?? 0,
    questions: questions.count ?? 0,
    answers: answers.count ?? 0,
    users: users.count ?? 0,
  };
}

export async function getRecentUsers(limit = 8) {
  const { data, error } = await supabase
    .from("users")
    .select("id, email, full_name, created_at, role")
    .order("created_at", { ascending: false })
    .limit(limit);
  if (error) throw new Error(error.message);
  return data;
}

// ── Topics ────────────────────────────────────────────────────
export async function adminGetTopics() {
  const { data, error } = await supabase
    .from("topics")
    .select("*")
    .order("display_order");
  if (error) throw new Error(error.message);
  return data;
}

export async function adminCreateTopic(payload) {
  const { data, error } = await supabase.from("topics").insert(payload).select().single();
  if (error) throw new Error(error.message);
  return data;
}

export async function adminUpdateTopic(id, payload) {
  const { data, error } = await supabase.from("topics").update(payload).eq("id", id).select().single();
  if (error) throw new Error(error.message);
  return data;
}

export async function adminDeleteTopic(id) {
  const { error } = await supabase.from("topics").delete().eq("id", id);
  if (error) throw new Error(error.message);
}

// ── Sections ──────────────────────────────────────────────────
export async function adminGetSections(topicId) {
  const { data, error } = await supabase
    .from("sections")
    .select("*")
    .eq("topic_id", topicId)
    .order("display_order");
  if (error) throw new Error(error.message);
  return data;
}

export async function adminCreateSection(payload) {
  const { data, error } = await supabase.from("sections").insert(payload).select().single();
  if (error) throw new Error(error.message);
  return data;
}

export async function adminUpdateSection(id, payload) {
  const { data, error } = await supabase.from("sections").update(payload).eq("id", id).select().single();
  if (error) throw new Error(error.message);
  return data;
}

export async function adminDeleteSection(id) {
  const { error } = await supabase.from("sections").delete().eq("id", id);
  if (error) throw new Error(error.message);
}

// ── Questions ─────────────────────────────────────────────────
export async function adminGetQuestions(sectionId) {
  const { data, error } = await supabase
    .from("questions")
    .select("*, difficulty_levels(label)")
    .eq("section_id", sectionId)
    .order("serial_number");
  if (error) throw new Error(error.message);
  return data;
}

export async function adminCreateQuestion(payload) {
  const { data, error } = await supabase.from("questions").insert(payload).select().single();
  if (error) throw new Error(error.message);
  return data;
}

export async function adminUpdateQuestion(id, payload) {
  const { data, error } = await supabase.from("questions").update(payload).eq("id", id).select().single();
  if (error) throw new Error(error.message);
  return data;
}

export async function adminDeleteQuestion(id) {
  const { error } = await supabase.from("questions").delete().eq("id", id);
  if (error) throw new Error(error.message);
}

// ── Answers ───────────────────────────────────────────────────
export async function adminGetAnswer(questionId) {
  const { data, error } = await supabase
    .from("answers")
    .select("id, content, is_verified, source_url")
    .eq("question_id", questionId)
    .single();
  if (error && error.code !== "PGRST116") throw new Error(error.message);
  return data ?? null;
}

export async function adminUpsertAnswer(questionId, content, extra = {}) {
  const payload = { question_id: questionId, content, ...extra };
  const { data, error } = await supabase
    .from("answers")
    .upsert(payload, { onConflict: "question_id" })
    .select()
    .single();
  if (error) throw new Error(error.message);
  return data;
}

// ── Users ─────────────────────────────────────────────────────
export async function adminGetUsers(limit = 50) {
  const { data, error } = await supabase
    .from("users")
    .select("id, email, full_name, role, provider, created_at")
    .order("created_at", { ascending: false })
    .limit(limit);
  if (error) throw new Error(error.message);
  return data;
}

export async function adminGetUserStats(userId) {
  const { data, error } = await supabase
    .from("user_progress")
    .select("status")
    .eq("user_id", userId);
  if (error) throw new Error(error.message);
  const done = data.filter((r) => r.status === "Done").length;
  const inProgress = data.filter((r) => r.status === "In Progress").length;
  return { total: data.length, done, inProgress };
}

export async function adminSetUserRole(userId, role) {
  const { error } = await supabase.from("users").update({ role }).eq("id", userId);
  if (error) throw new Error(error.message);
}

// ── Content health + topic performance ───────────────────────
export async function getContentHealth() {
  const [{ count: totalQ }, { count: totalA }] = await Promise.all([
    supabase.from("questions").select("id", { count: "exact", head: true }),
    supabase.from("answers").select("id", { count: "exact", head: true }),
  ]);
  const total = totalQ ?? 0;
  const answered = totalA ?? 0;
  return {
    totalQuestions: total,
    withAnswers: answered,
    withoutAnswers: total - answered,
    coverage: total > 0 ? Math.round((answered / total) * 100) : 0,
  };
}

export async function getTopicPerformance() {
  const [{ data: topics }, { data: sections }, { data: questions }, { data: answers }] = await Promise.all([
    supabase.from("topics").select("id, label").order("display_order"),
    supabase.from("sections").select("id, topic_id"),
    supabase.from("questions").select("id, section_id"),
    supabase.from("answers").select("question_id"),
  ]);

  const answeredIds = new Set(answers?.map(a => a.question_id) ?? []);
  const sectionsByTopic = {};
  sections?.forEach(s => {
    (sectionsByTopic[s.topic_id] ??= []).push(s.id);
  });
  const qsBySection = {};
  questions?.forEach(q => {
    (qsBySection[q.section_id] ??= []).push(q.id);
  });

  return (topics ?? []).map(t => {
    const sIds = sectionsByTopic[t.id] ?? [];
    const qIds = sIds.flatMap(sid => qsBySection[sid] ?? []);
    const answered = qIds.filter(id => answeredIds.has(id)).length;
    return {
      ...t,
      sections: sIds.length,
      questions: qIds.length,
      answers: answered,
      coverage: qIds.length > 0 ? Math.round((answered / qIds.length) * 100) : 0,
    };
  });
}

// ── Difficulty levels ─────────────────────────────────────────
export async function adminGetDifficultyLevels() {
  const { data, error } = await supabase
    .from("difficulty_levels")
    .select("id, label")
    .order("display_order");
  if (error) throw new Error(error.message);
  return data;
}
