import {
  Diamond, Braces, Atom, Database, Network, GitBranch, Cloud, Code2
} from "lucide-react";

const TOPIC_ICON_MAP = [
  { keys: ["_net", "net", "c#", "csharp"],           Icon: Diamond   },
  { keys: ["javascript", "typescript", "ts", "js"],  Icon: Braces    },
  { keys: ["react"],                                  Icon: Atom      },
  { keys: ["sql", "database", "db"],                 Icon: Database  },
  { keys: ["system", "design", "architecture"],      Icon: Network   },
  { keys: ["dsa", "coding", "algo", "data struct"],  Icon: GitBranch },
  { keys: ["azure", "cloud", "aws", "gcp"],          Icon: Cloud     },
];

function resolveIcon(topic) {
  if (!topic) return Code2;
  const slug  = (topic.slug  || "").toLowerCase();
  const label = (topic.label || "").toLowerCase();
  const combined = slug + " " + label;
  for (const { keys, Icon } of TOPIC_ICON_MAP) {
    if (keys.some(k => combined.includes(k))) return Icon;
  }
  return Code2;
}

export default function TopicIcon({ topic, size = 15 }) {
  const Icon = resolveIcon(topic);
  return <Icon size={size} strokeWidth={1.6} />;
}
