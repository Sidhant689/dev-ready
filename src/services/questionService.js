import { supabase } from "../config/supabaseClient";

export async function fetchAllQuestions() {
  const { data, error } = await supabase
    .from("answers")
    .select("topic, section_id, sl, question, level")
    .order("topic")
    .order("section_id")
    .order("sl");

  if (error) throw new Error(error.message);
  return data;
}
