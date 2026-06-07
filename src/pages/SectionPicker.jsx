import { useEffect, useState } from "react";
import {
  Code2, Layers, Zap, ShieldCheck, Database, Globe,
  Cpu, GitBranch, BarChart2, BookOpen, Settings, Rocket,
} from "lucide-react";
import { fetchSections } from "../services/questionService";

// Strip leading emoji / number-emoji from section labels
function cleanLabel(label) {
  return label
    .replace(/^[\p{Emoji}\p{Emoji_Modifier}\p{Emoji_Component}️‍]+\s*/gu, "")
    .replace(/^\d+\.\s*/, "")
    .trim();
}

const SECTION_ICONS = [
  Code2, Layers, Zap, ShieldCheck, Database, Globe,
  Cpu, GitBranch, BarChart2, BookOpen, Settings, Rocket,
];

const ICON_COLORS = [
  { bg: "bg-accent/10",       border: "border-accent/20",       text: "text-accent"       },
  { bg: "bg-blue-500/10",     border: "border-blue-500/20",     text: "text-blue-400"     },
  { bg: "bg-violet-500/10",   border: "border-violet-500/20",   text: "text-violet-400"   },
  { bg: "bg-emerald-500/10",  border: "border-emerald-500/20",  text: "text-emerald-400"  },
  { bg: "bg-amber-500/10",    border: "border-amber-500/20",    text: "text-amber-400"    },
  { bg: "bg-pink-500/10",     border: "border-pink-500/20",     text: "text-pink-400"     },
];

export default function SectionPicker({ topic, statuses, questionMeta, onSelectSection }) {
  const [sections, setSections] = useState([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    if (!topic) return;
    setLoading(true);
    fetchSections(topic.id)
      .then((data) => { setSections(data); setLoading(false); })
      .catch(() => setLoading(false));
  }, [topic?.id]);

  if (!topic) return null;

  return (
    <div className="flex-1 overflow-y-auto p-6">
      {/* Header */}
      <div className="mb-7">
        <h1 className="text-2xl font-bold text-heading">{topic.label}</h1>
        <p className="text-sm text-muted mt-1">
          {topic.total_count || 0} questions · Pick a section to start practicing
        </p>
      </div>

      {/* Sections grid */}
      {loading ? (
        <div className="grid grid-cols-2 md:grid-cols-3 gap-3">
          {[1, 2, 3, 4, 5, 6].map((i) => (
            <div key={i} className="h-28 rounded-xl bg-panel border border-border animate-pulse" />
          ))}
        </div>
      ) : sections.length === 0 ? (
        <div className="flex flex-col items-center justify-center py-20 text-center">
          <div className="w-12 h-12 rounded-xl bg-hover flex items-center justify-center mb-3 text-muted">
            <BookOpen size={22} strokeWidth={1.5} />
          </div>
          <p className="text-sm text-soft font-medium">No sections yet</p>
          <p className="text-xs text-muted mt-1">Sections will appear here once added.</p>
        </div>
      ) : (
        <div className="grid grid-cols-2 md:grid-cols-3 gap-3">
          {sections.map((section, i) => {
            const Icon = SECTION_ICONS[i % SECTION_ICONS.length];
            const color = ICON_COLORS[i % ICON_COLORS.length];
            const label = cleanLabel(section.label);

            return (
              <button
                key={section.id}
                onClick={() => onSelectSection(section)}
                className="group text-left bg-panel border border-border rounded-xl p-4 hover:border-accent/40 hover:bg-hover transition-all duration-150 cursor-pointer flex flex-col gap-3"
              >
                {/* Icon + number */}
                <div className="flex items-center justify-between">
                  <div className={`w-9 h-9 rounded-lg border flex items-center justify-center shrink-0 ${color.bg} ${color.border} ${color.text}`}>
                    <Icon size={17} strokeWidth={1.6} />
                  </div>
                  <span className="text-[11px] font-semibold text-ghost tabular-nums">
                    {String(i + 1).padStart(2, "0")}
                  </span>
                </div>

                {/* Section name */}
                <p className="text-sm font-semibold text-primary group-hover:text-bright transition-colors leading-snug">
                  {label}
                </p>

                {/* Start */}
                <span className="text-[11px] text-ghost group-hover:text-accent transition-colors group-hover:translate-x-0.5 inline-block duration-150">
                  Start →
                </span>
              </button>
            );
          })}
        </div>
      )}
    </div>
  );
}
