import { supabase } from "../config/supabaseClient";

// ── Fetch comments for a question (with likes + user metadata) ────────────────
export async function fetchComments(questionId) {
  const { data, error } = await supabase
    .from("comments")
    .select(`
      id, question_id, parent_id, content, is_pinned, is_deleted, created_at, updated_at,
      user_id,
      comment_likes(count)
    `)
    .eq("question_id", questionId)
    .eq("is_deleted", false)
    .order("is_pinned", { ascending: false })
    .order("created_at", { ascending: true });

  if (error) throw new Error(error.message);

  // Fetch display names from user_profiles
  const userIds = [...new Set((data || []).map(c => c.user_id))];
  let userMap = {};
  if (userIds.length > 0) {
    const { data: profiles } = await supabase
      .from("user_profiles")
      .select("id, display_name, avatar_url")
      .in("id", userIds);
    (profiles || []).forEach(p => { userMap[p.id] = p; });
  }

  return (data || []).map(c => ({
    ...c,
    likes_count: c.comment_likes?.[0]?.count ?? 0,
    user: userMap[c.user_id] || { display_name: "User", avatar_url: null },
  }));
}

// ── Fetch the user's own likes for a question's comments ──────────────────────
export async function fetchMyLikes(questionId, userId) {
  if (!userId) return new Set();
  const { data } = await supabase
    .from("comment_likes")
    .select("comment_id")
    .eq("user_id", userId);
  return new Set((data || []).map(r => r.comment_id));
}

// ── Post a new comment ────────────────────────────────────────────────────────
export async function postComment(questionId, userId, content, parentId = null) {
  const { data, error } = await supabase
    .from("comments")
    .insert({ question_id: questionId, user_id: userId, content: content.trim(), parent_id: parentId })
    .select()
    .single();
  if (error) throw new Error(error.message);
  return data;
}

// ── Edit a comment ────────────────────────────────────────────────────────────
export async function editComment(commentId, content) {
  const { data, error } = await supabase
    .from("comments")
    .update({ content: content.trim(), updated_at: new Date().toISOString() })
    .eq("id", commentId)
    .select()
    .single();
  if (error) throw new Error(error.message);
  return data;
}

// ── Soft-delete a comment ─────────────────────────────────────────────────────
export async function deleteComment(commentId) {
  const { error } = await supabase
    .from("comments")
    .update({ is_deleted: true })
    .eq("id", commentId);
  if (error) throw new Error(error.message);
}

// ── Pin / unpin a comment (admin) ─────────────────────────────────────────────
export async function togglePin(commentId, isPinned) {
  const { error } = await supabase
    .from("comments")
    .update({ is_pinned: !isPinned })
    .eq("id", commentId);
  if (error) throw new Error(error.message);
}

// ── Toggle like on a comment ──────────────────────────────────────────────────
export async function toggleLike(commentId, userId, liked) {
  if (liked) {
    await supabase.from("comment_likes").delete().match({ comment_id: commentId, user_id: userId });
  } else {
    await supabase.from("comment_likes").insert({ comment_id: commentId, user_id: userId });
  }
}

// ── Answer rating ─────────────────────────────────────────────────────────────
export async function fetchAnswerRating(questionId) {
  const [{ data: agg }, { data: mine }] = await Promise.all([
    supabase.from("answer_ratings").select("rating").eq("question_id", questionId),
    supabase.auth.getUser(),
  ]);
  const userId = mine?.user?.id;
  let myRating = null;
  let helpful = 0, total = 0;
  (agg || []).forEach(r => {
    total++;
    if (r.rating === 1) helpful++;
  });
  if (userId) {
    const { data: own } = await supabase
      .from("answer_ratings")
      .select("rating")
      .eq("question_id", questionId)
      .eq("user_id", userId)
      .maybeSingle();
    myRating = own?.rating ?? null;
  }
  return { helpful, total, myRating };
}

export async function rateAnswer(questionId, userId, rating) {
  const { error } = await supabase
    .from("answer_ratings")
    .upsert({ question_id: questionId, user_id: userId, rating, updated_at: new Date().toISOString() },
      { onConflict: "question_id,user_id" });
  if (error) throw new Error(error.message);
}

// ── Admin: fetch all comments across all questions ────────────────────────────
export async function fetchAllComments({ limit = 200, offset = 0, search = "" } = {}) {
  let q = supabase
    .from("comments")
    .select(`
      id, question_id, user_id, content, is_pinned, is_deleted, created_at,
      questions(
        id, text,
        difficulty_levels(label),
        sections(
          id, label,
          topics(id, label)
        )
      )
    `)
    .order("created_at", { ascending: false })
    .range(offset, offset + limit - 1);
  if (search) q = q.ilike("content", `%${search}%`);
  const { data, error } = await q;
  if (error) throw new Error(error.message);
  return data || [];
}
