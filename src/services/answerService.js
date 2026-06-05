import { supabase } from "../config/supabaseClient";

export async function fetchAnswer(topic, sectionId, sl) {
  const { data, error } = await supabase
    .from("answers")
    .select("answer")
    .eq("topic", topic)
    .eq("section_id", sectionId)
    .eq("sl", sl)
    .limit(1)
    .single();

  if (error && error.code !== "PGRST116") {
    // PGRST116 = no rows found — not an error for us
    throw new Error(error.message);
  }

  return data?.answer ?? null;
}
