import { useCallback } from "react";
import { supabase } from "../config/supabaseClient";

// SM-2 algorithm
// rating: 0=Again, 1=Hard, 2=Good, 3=Easy
function sm2(easeFactor, intervalDays, repetitions, rating) {
  let ef = easeFactor;
  let interval = intervalDays;
  let reps = repetitions;

  if (rating < 2) {
    // Failed — reset
    reps = 0;
    interval = 1;
  } else {
    reps += 1;
    if (reps === 1) interval = 1;
    else if (reps === 2) interval = 6;
    else interval = Math.round(interval * ef);
  }

  // Update ease factor (stays between 1.3 and 2.5)
  ef = Math.max(1.3, Math.min(2.5, ef + (0.1 - (3 - rating) * (0.08 + (3 - rating) * 0.02))));

  const nextReview = new Date();
  nextReview.setDate(nextReview.getDate() + interval);

  return { easeFactor: ef, intervalDays: interval, repetitions: reps, nextReviewAt: nextReview.toISOString() };
}

export function useSpacedRepetition(user) {
  const rate = useCallback(async (questionId, rating) => {
    if (!user?.id) return;

    // Fetch current SR state
    const { data: existing } = await supabase
      .from("user_progress")
      .select("ease_factor, interval_days, repetitions")
      .eq("user_id", user.id)
      .eq("question_id", questionId)
      .single();

    const ef = existing?.ease_factor ?? 2.5;
    const interval = existing?.interval_days ?? 1;
    const reps = existing?.repetitions ?? 0;

    const next = sm2(ef, interval, reps, rating);

    await supabase.from("user_progress").upsert({
      user_id: user.id,
      question_id: questionId,
      ease_factor: next.easeFactor,
      interval_days: next.intervalDays,
      repetitions: next.repetitions,
      next_review_at: next.nextReviewAt,
      status: rating >= 2 ? "Done" : "In Progress",
    }, { onConflict: "user_id,question_id" });

    return next;
  }, [user?.id]);

  const fetchDueReviews = useCallback(async (limit = 20) => {
    if (!user?.id) return [];
    const now = new Date().toISOString();
    const { data } = await supabase
      .from("user_progress")
      .select("question_id, next_review_at, ease_factor, interval_days")
      .eq("user_id", user.id)
      .lte("next_review_at", now)
      .order("next_review_at")
      .limit(limit);
    return data ?? [];
  }, [user?.id]);

  return { rate, fetchDueReviews };
}
