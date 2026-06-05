export function renderMarkdown(raw) {
  if (!raw) return "";

  let text = raw;
  const blocks = {};
  let bi = 0;

  // Fenced code blocks
  text = text.replace(/```(\w*)\n?([\s\S]*?)```/g, (_, _lang, code) => {
    const k = `__CB${bi++}__`;
    const esc = code
      .trim()
      .replace(/&/g, "&amp;")
      .replace(/</g, "&lt;")
      .replace(/>/g, "&gt;");
    blocks[k] = `<pre style="background:#0f172a;border-radius:8px;padding:16px;overflow-x:auto;margin:12px 0;border:1px solid #1e293b"><code style="font-family:monospace;font-size:13px;color:#e2e8f0;line-height:1.6">${esc}</code></pre>`;
    return k;
  });

  // Inline code
  text = text.replace(/`([^`\n]+)`/g, (_, c) => {
    const esc = c
      .replace(/&/g, "&amp;")
      .replace(/</g, "&lt;")
      .replace(/>/g, "&gt;");
    return `<code style="font-family:monospace;font-size:12px;background:#1e293b;color:#7dd3fc;padding:2px 6px;border-radius:4px">${esc}</code>`;
  });

  // Headings
  text = text.replace(/^# (.+)$/gm, (_, t) => `<h2 style="font-size:17px;font-weight:600;color:#f1f5f9;margin:20px 0 10px;padding-bottom:6px;border-bottom:1px solid #1e293b">${t}</h2>`);
  text = text.replace(/^## (.+)$/gm, (_, t) => `<h3 style="font-size:15px;font-weight:600;color:#f1f5f9;margin:16px 0 8px">${t}</h3>`);
  text = text.replace(/^### (.+)$/gm, (_, t) => `<h4 style="font-size:14px;font-weight:600;color:#94a3b8;margin:12px 0 6px">${t}</h4>`);

  // Divider
  text = text.replace(/^---$/gm, `<hr style="border:none;border-top:1px solid #1e293b;margin:20px 0"/>`);

  // Bold / italic
  text = text.replace(/\*\*(.+?)\*\*/g, `<strong style="font-weight:600;color:#f1f5f9">$1</strong>`);
  text = text.replace(/\*([^*\n]+?)\*/g, `<em>$1</em>`);

  // Lists
  const lines = text.split("\n");
  const result = [];
  let inList = false;

  for (const line of lines) {
    if (/^[-*] /.test(line)) {
      if (!inList) { result.push('<ul style="padding-left:20px;margin:8px 0">'); inList = true; }
      result.push(`<li style="margin:4px 0;color:#cbd5e1">${line.slice(2)}</li>`);
    } else if (/^\d+\. /.test(line)) {
      if (!inList) { result.push('<ol style="padding-left:20px;margin:8px 0">'); inList = true; }
      result.push(`<li style="margin:4px 0;color:#cbd5e1">${line.replace(/^\d+\. /, "")}</li>`);
    } else {
      if (inList) { result.push("</ul>"); inList = false; }
      result.push(line);
    }
  }
  if (inList) result.push("</ul>");

  text = result.join("\n");

  // Paragraphs
  text = text
    .split(/\n\n+/)
    .map((p) => {
      const t = p.trim();
      if (!t) return "";
      if (/^<(h[234]|ul|ol|hr|pre|__CB)/.test(t) || /__CB\d+__/.test(t)) return t;
      return `<p style="margin:8px 0;color:#cbd5e1;line-height:1.7">${t}</p>`;
    })
    .join("");

  // Restore code blocks
  Object.entries(blocks).forEach(([k, v]) => {
    text = text.replaceAll(k, v);
  });

  return text;
}
