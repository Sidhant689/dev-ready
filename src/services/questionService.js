import { supabase } from "../config/supabaseClient";

// ✅ NEW: Fetch all topics with computed counts
export async function fetchTopics() {
  const { data, error } = await supabase
    .from("topics")
    .select("*")
    .order("display_order");

  if (error) throw new Error(error.message);

  // Attach question counts
  const topicsWithCounts = await Promise.all(
    data.map(async (topic) => {
      const stats = await getTopicStats(topic.id);
      return { ...topic, ...stats };
    })
  );

  return topicsWithCounts;
}

// ✅ NEW: Fetch sections for a topic
export async function fetchSections(topicId) {
  const { data, error } = await supabase
    .from("sections")
    .select("*")
    .eq("topic_id", topicId)
    .order("display_order");

  if (error) throw new Error(error.message);
  return data;
}

// ✅ NEW: Fetch questions for a section
export async function fetchQuestions(sectionId) {
  const { data, error } = await supabase
    .from("questions")
    .select("*, difficulty_levels(slug, label, bg_color, text_color), companies")
    .eq("section_id", sectionId)
    .order("serial_number");

  if (error) throw new Error(error.message);
  return data;
}

// ✅ UPDATED: Fetch answer for a question
export async function fetchAnswer(questionId) {
  const { data, error } = await supabase
    .from("answers")
    .select("content, is_verified, source_url")
    .eq("question_id", questionId)
    .single();

  if (error && error.code !== "PGRST116") {
    throw new Error(error.message);
  }

  return data?.content ?? null;
}

// ✅ NEW: Fetch difficulty levels config
export async function fetchDifficultyLevels() {
  const { data, error } = await supabase
    .from("difficulty_levels")
    .select("*")
    .order("display_order");

  if (error) throw new Error(error.message);

  // Transform to old format for UI compatibility
  const levelConfig = {};
  data.forEach((level) => {
    levelConfig[level.label] = {
      bg: level.bg_color,
      color: level.text_color,
    };
  });

  return levelConfig;
}

// ✅ NEW: Fetch levels as array
export async function fetchLevelsList() {
  const { data, error } = await supabase
    .from("difficulty_levels")
    .select("label")
    .order("display_order");

  if (error) throw new Error(error.message);

  return ["All", ...data.map((d) => d.label)];
}

// ✅ NEW: Update user progress
export async function updateProgress(userId, questionId, status) {
  const { data, error } = await supabase
    .from("user_progress")
    .upsert(
      { user_id: userId, question_id: questionId, status },
      { onConflict: "user_id,question_id" }
    )
    .select()
    .single();

  if (error) throw new Error(error.message);
  return data;
}

// ✅ NEW: Get user statistics
export async function getUserStats(userId) {
  const { data, error } = await supabase
    .from("user_progress")
    .select("status")
    .eq("user_id", userId);

  if (error) throw new Error(error.message);

  const stats = {
    total: 0,
    done: 0,
    inProgress: 0,
    todo: 0,
  };

  data.forEach((row) => {
    stats.total++;
    if (row.status === "Done") stats.done++;
    else if (row.status === "In Progress") stats.inProgress++;
    else stats.todo++;
  });

  return stats;
}

// ✅ HELPER: Get topic statistics (done count, total count)
async function getTopicStats(topicId) {
  const { data: sectionData } = await supabase
    .from("sections")
    .select("id")
    .eq("topic_id", topicId);

  const sectionIds = sectionData?.map((s) => s.id) ?? [];

  if (sectionIds.length === 0) {
    return { total_count: 0, done_count: 0 };
  }

  const { data: questions } = await supabase
    .from("questions")
    .select("id")
    .in("section_id", sectionIds);

  return {
    total_count: questions?.length ?? 0,
    done_count: 0,
  };
}

// ✅ NEW: Fetch random questions for quiz/interview sim
export async function fetchRandomQuestions(topicIds = [], count = 10) {
  let query = supabase
    .from("questions")
    .select("id, text, section_id, difficulty_id, difficulty_levels(label), sections!inner(id, topic_id)")
    .limit(500);

  if (topicIds.length > 0) {
    query = query.in("sections.topic_id", topicIds);
  }

  const { data, error } = await query;
  if (error) throw new Error(error.message);

  // Shuffle and take count
  const shuffled = (data ?? []).sort(() => Math.random() - 0.5);
  return shuffled.slice(0, count);
}

// ✅ NEW: Fetch question by ID (for share URL)
export async function fetchQuestionById(questionId) {
  const { data, error } = await supabase
    .from("questions")
    .select("id, text, difficulty_id, difficulty_levels(label), sections(id, label, topic_id, topics(label))")
    .eq("id", questionId)
    .single();
  if (error) throw new Error(error.message);
  return data;
}

// ✅ NEW: Fetch activity heatmap data (26 weeks back)
export async function fetchUserActivity(userId) {
  const since = new Date();
  since.setDate(since.getDate() - 182);
  const { data } = await supabase
    .from("user_progress")
    .select("updated_at")
    .eq("user_id", userId)
    .eq("status", "Done")
    .gte("updated_at", since.toISOString());

  const counts = {};
  data?.forEach((r) => {
    const d = r.updated_at?.slice(0, 10);
    if (d) counts[d] = (counts[d] || 0) + 1;
  });
  return counts;
}

// ✅ LEGACY: Fetch all questions (for backward compatibility)
export async function fetchAllQuestions() {
  const { data, error } = await supabase
    .from("questions")
    .select("id, text, section_id, difficulty_id, difficulty_levels(label)")
    .order("section_id")
    .order("serial_number");

  if (error) throw new Error(error.message);
  return data;
}
