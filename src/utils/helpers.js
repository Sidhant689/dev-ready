// ✅ UPDATED: Simplified key generation using questionId only
export const qKey = (questionId) => `q_${questionId}`;

// ✅ REMOVED: totalQs - now computed from database total_count
// ✅ REMOVED: doneQs - now computed from user_progress table

