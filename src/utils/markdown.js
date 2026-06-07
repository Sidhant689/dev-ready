// ─── Heading emoji → colored SVG icon ────────────────────────────────────────
// Each entry: the emoji that appears in DB content → a colored SVG icon.
// Colors are intentional accent tones that look good on both dark + light bg.
const HEADING_EMOJI_MAP = {
  "⚡": { color: "#f59e0b", d: "M13 2L4.5 13H11L9 22l9.5-13H13L13 2z" },
  "📖": { color: "#6366f1", d: "M2 3h6a4 4 0 014 4v14a3 3 0 00-3-3H2zm18 0h-6a4 4 0 00-4 4v14a3 3 0 013-3h7z" },
  "💻": { color: "#10b981", d: "M8 6L4 10l4 4m8-8l4 4-4 4M13 3l-2 18" },
  "❓": { color: "#8b5cf6", d: "M12 22C6.477 22 2 17.523 2 12S6.477 2 12 2s10 4.477 10 10-4.477 10-10 10zm0-7v2m0-9a3 3 0 110 6 3 3 0 010-6z" },
  "⚠️": { color: "#ef4444", d: "M10.29 3.86L1.82 18a2 2 0 001.71 3h16.94a2 2 0 001.71-3L13.71 3.86a2 2 0 00-3.42 0zM12 9v4m0 4h.01" },
  "🎯": { color: "#f59e0b", d: "M12 22C6.477 22 2 17.523 2 12S6.477 2 12 2s10 4.477 10 10-4.477 10-10 10zm0-14a4 4 0 100 8 4 4 0 000-8zm0 2a2 2 0 110 4 2 2 0 010-4z" },
  "🏭": { color: "#6366f1", d: "M3 9l4-4 4 4V3h6v18H3V9z" },
  "📝": { color: "#6366f1", d: "M11 4H4a2 2 0 00-2 2v14a2 2 0 002 2h14a2 2 0 002-2v-7m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z" },
  "🔍": { color: "#10b981", d: "M21 21l-4.35-4.35M17 11A6 6 0 115 11a6 6 0 0112 0z" },
  "🚀": { color: "#8b5cf6", d: "M12 2s4 2 4 8l-2 2-2-2-2 2-2-2c0-6 4-8 4-8zM8 11l-4 6 5-2m8-4l4 6-5-2" },
  "🧠": { color: "#8b5cf6", d: "M9.5 2A5.5 5.5 0 0115 7.5c0 1-.25 2-.7 2.8A5.5 5.5 0 1112 20.9V22h-2v-1.1A5.5 5.5 0 019.5 2z" },
  "💡": { color: "#f59e0b", d: "M9 18h6m-3-4v4m0 0a7 7 0 10-4-6.32" },
  "📊": { color: "#10b981", d: "M3 17l4-8 4 4 4-6 4 10H3z" },
  "🔧": { color: "#94a3b8", d: "M14.7 6.3a1 1 0 000 1.4l1.6 1.6a1 1 0 001.4 0l3.77-3.77a6 6 0 01-7.94 7.94l-6.91 6.91a2.12 2.12 0 01-3-3l6.91-6.91a6 6 0 017.94-7.94l-3.76 3.76z" },
  "📌": { color: "#ef4444", d: "M21 10c0 7-9 13-9 13S3 17 3 10a9 9 0 0118 0zm-9 1a1 1 0 100-2 1 1 0 000 2z" },
};

// Inline text emoji → small colored badge
const INLINE_EMOJI_MAP = {
  "✅": `<span style="display:inline-flex;align-items:center;justify-content:center;width:16px;height:16px;border-radius:50%;background:#10b981;vertical-align:middle;margin:0 1px"><svg xmlns="http://www.w3.org/2000/svg" width="10" height="10" viewBox="0 0 24 24" fill="none" stroke="white" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"><path d="M20 6L9 17l-5-5"/></svg></span>`,
  "❌": `<span style="display:inline-flex;align-items:center;justify-content:center;width:16px;height:16px;border-radius:50%;background:#ef4444;vertical-align:middle;margin:0 1px"><svg xmlns="http://www.w3.org/2000/svg" width="10" height="10" viewBox="0 0 24 24" fill="none" stroke="white" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"><path d="M18 6L6 18M6 6l12 12"/></svg></span>`,
  "⚠️": `<span style="display:inline-flex;align-items:center;justify-content:center;width:16px;height:16px;border-radius:3px;background:#f59e0b;vertical-align:middle;margin:0 1px"><svg xmlns="http://www.w3.org/2000/svg" width="10" height="10" viewBox="0 0 24 24" fill="none" stroke="white" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"><path d="M12 9v4m0 4h.01M10.29 3.86L1.82 18a2 2 0 001.71 3h16.94a2 2 0 001.71-3L13.71 3.86a2 2 0 00-3.42 0z"/></svg></span>`,
  "🔥": `<span style="display:inline-flex;align-items:center;justify-content:center;width:16px;height:16px;vertical-align:middle;margin:0 1px"><svg xmlns="http://www.w3.org/2000/svg" width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="#f59e0b" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M12 2c0 0 4 4 4 8-1 1-2.5 1-3 0C12 8.5 13 6 13 6S10 8.5 10 12a4 4 0 008 0c0-5-4-9-4-10z"/></svg></span>`,
};

const HEADING_EMOJI_PATTERN = new RegExp(
  `^(${Object.keys(HEADING_EMOJI_MAP)
    .map(e => e.replace(/[.*+?^${}()|[\]\\]/g, "\\$&"))
    .join("|")})[\\s\\uFE0F]*`
);

const INLINE_EMOJI_PATTERN = new RegExp(
  Object.keys(INLINE_EMOJI_MAP)
    .map(e => e.replace(/[.*+?^${}()|[\]\\]/g, "\\$&"))
    .join("|"),
  "g"
);

function buildHeadingIcon(rawText) {
  const match = rawText.match(HEADING_EMOJI_PATTERN);
  if (!match) return null;
  const icon = HEADING_EMOJI_MAP[match[1]];
  const cleanText = rawText.replace(HEADING_EMOJI_PATTERN, "").trim();
  const svg = `<svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="${icon.color}" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" style="flex-shrink:0;margin-top:1px"><path d="${icon.d}"/></svg>`;
  return { svg, cleanText };
}

function replaceInlineEmoji(text) {
  return text.replace(INLINE_EMOJI_PATTERN, (match) => INLINE_EMOJI_MAP[match] || match);
}

export function renderMarkdown(raw) {
  if (!raw) return "";

  let text = raw;
  const blocks = {};
  let bi = 0;

  // ── Fenced code blocks (preserve as-is, styled by .prose-answer pre) ──
  text = text.replace(/```(\w*)\n?([\s\S]*?)```/g, (_, _lang, code) => {
    const k = `__CB${bi++}__`;
    const esc = code.trim()
      .replace(/&/g, "&amp;")
      .replace(/</g, "&lt;")
      .replace(/>/g, "&gt;");
    blocks[k] = `<pre><code>${esc}</code></pre>`;
    return k;
  });

  // ── Inline code ──
  text = text.replace(/`([^`\n]+)`/g, (_, c) => {
    const esc = c.replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;");
    return `<code>${esc}</code>`;
  });

  // ── Headings — inject SVG icon if emoji prefix found ──
  function renderHeading(tag, rawText) {
    const icon = buildHeadingIcon(rawText);
    if (icon) {
      return `<${tag} style="display:flex;align-items:flex-start;gap:9px;margin-top:1.5rem;margin-bottom:0.6rem">${icon.svg}<span>${icon.cleanText}</span></${tag}>`;
    }
    return `<${tag}>${rawText}</${tag}>`;
  }

  text = text.replace(/^# (.+)$/gm,   (_, t) => renderHeading("h2", t));
  text = text.replace(/^## (.+)$/gm,  (_, t) => renderHeading("h3", t));
  text = text.replace(/^### (.+)$/gm, (_, t) => renderHeading("h4", t));

  // ── Horizontal rule ──
  text = text.replace(/^---$/gm, "<hr/>");

  // ── Bold / italic ──
  text = text.replace(/\*\*(.+?)\*\*/g, "<strong>$1</strong>");
  text = text.replace(/\*([^*\n]+?)\*/g, "<em>$1</em>");

  // ── Lists ──
  const lines = text.split("\n");
  const result = [];
  let inList = false;
  let listTag = "ul";

  for (const line of lines) {
    if (/^[-*] /.test(line)) {
      if (!inList || listTag !== "ul") {
        if (inList) result.push(`</${listTag}>`);
        result.push("<ul>"); inList = true; listTag = "ul";
      }
      result.push(`<li>${replaceInlineEmoji(line.slice(2))}</li>`);
    } else if (/^\d+\. /.test(line)) {
      if (!inList || listTag !== "ol") {
        if (inList) result.push(`</${listTag}>`);
        result.push("<ol>"); inList = true; listTag = "ol";
      }
      result.push(`<li>${replaceInlineEmoji(line.replace(/^\d+\. /, ""))}</li>`);
    } else {
      if (inList) { result.push(`</${listTag}>`); inList = false; }
      result.push(line);
    }
  }
  if (inList) result.push(`</${listTag}>`);
  text = result.join("\n");

  // ── Paragraphs ──
  text = text
    .split(/\n\n+/)
    .map((p) => {
      const t = p.trim();
      if (!t) return "";
      if (/^<(h[234]|ul|ol|hr|pre|__CB)/.test(t) || /__CB\d+__/.test(t)) return t;
      return `<p>${replaceInlineEmoji(t)}</p>`;
    })
    .join("");

  // ── Restore code blocks ──
  Object.entries(blocks).forEach(([k, v]) => { text = text.replaceAll(k, v); });

  return text;
}
