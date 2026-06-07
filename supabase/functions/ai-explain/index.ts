// Supabase Edge Function — AI "Explain Differently"
// Deploy: supabase functions deploy ai-explain
// Set secret: supabase secrets set ANTHROPIC_API_KEY=sk-ant-...

import { serve } from "https://deno.land/std@0.177.0/http/server.ts";

const CORS = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
};

serve(async (req) => {
  if (req.method === "OPTIONS") return new Response("ok", { headers: CORS });

  try {
    const { question, answer } = await req.json();
    if (!question) return new Response(JSON.stringify({ error: "Missing question" }), { status: 400, headers: CORS });

    const apiKey = Deno.env.get("ANTHROPIC_API_KEY");
    if (!apiKey) return new Response(JSON.stringify({ error: "AI not configured" }), { status: 503, headers: CORS });

    const prompt = answer
      ? `You are a senior software engineer explaining interview concepts clearly.

Question: ${question}

The standard answer is:
${answer.replace(/<[^>]+>/g, " ").replace(/\s+/g, " ").trim().slice(0, 1500)}

Explain this concept differently — use a fresh analogy, a simpler perspective, or a real-world example that makes it click. Keep it concise (150-250 words). Use plain text only, no markdown headers.`
      : `You are a senior software engineer. Explain this interview question with a fresh, intuitive approach:

${question}

Give a clear, concise answer (150-250 words) using plain language, analogies, or real-world examples. No markdown headers.`;

    const response = await fetch("https://api.anthropic.com/v1/messages", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "x-api-key": apiKey,
        "anthropic-version": "2023-06-01",
      },
      body: JSON.stringify({
        model: "claude-haiku-4-5-20251001",
        max_tokens: 400,
        messages: [{ role: "user", content: prompt }],
      }),
    });

    if (!response.ok) {
      const err = await response.text();
      throw new Error(`Anthropic API error: ${err}`);
    }

    const data = await response.json();
    const text = data.content?.[0]?.text ?? "";

    return new Response(JSON.stringify({ explanation: text }), {
      headers: { ...CORS, "Content-Type": "application/json" },
    });
  } catch (err) {
    return new Response(JSON.stringify({ error: err.message }), {
      status: 500,
      headers: { ...CORS, "Content-Type": "application/json" },
    });
  }
});
