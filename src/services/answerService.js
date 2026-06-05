import { supabase } from "../config/supabaseClient";

// ✅ UPDATED: Fetch answer by question ID (new schema)
export async function fetchAnswer(questionId) {
  const { data, error } = await supabase
    .from("answers")
    .select("content, is_verified, source_url")
    .eq("question_id", questionId)
    .single();

  if (error && error.code !== "PGRST116") {
    // PGRST116 = no rows found — not an error for us
    throw new Error(error.message);
  }

  return data?.content ?? null;
}
