const GROQ_API_KEY = import.meta.env.VITE_GROQ_API_KEY;
const GROQ_MODEL = "meta-llama/llama-4-scout-17b-16e-instruct";

export async function explainDifferently(question, answerHtml) {
  if (!GROQ_API_KEY) throw new Error("unavailable");

  const stripped = answerHtml.replace(/<[^>]+>/g, " ").replace(/\s+/g, " ").trim();
  const prompt = `You are a technical interview coach. The candidate is studying: "${question}"\n\nHere is the standard answer:\n${stripped}\n\nExplain this concept differently — use a fresh analogy, a real-world example, or a simpler mental model. Be concise (3-5 sentences). Do not repeat the standard answer word for word.`;

  const response = await fetch("https://api.groq.com/openai/v1/chat/completions", {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
      "Authorization": `Bearer ${GROQ_API_KEY}`,
    },
    body: JSON.stringify({
      model: GROQ_MODEL,
      max_tokens: 400,
      messages: [{ role: "user", content: prompt }],
    }),
  });

  if (!response.ok) {
    const err = await response.json().catch(() => ({}));
    throw new Error(err?.error?.message ?? `Request failed (${response.status})`);
  }

  const data = await response.json();
  return data.choices?.[0]?.message?.content?.trim() ?? "";
}
