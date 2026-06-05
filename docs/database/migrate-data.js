/**
 * MIGRATION SCRIPT: Convert hardcoded topics.js → Supabase
 * 
 * Usage:
 * 1. Run: node migrate-data.js
 * 2. Output: Creates migrate-data.sql
 * 3. Copy SQL and run in Supabase SQL Editor
 * 
 * WARNING: This will INSERT all topics/sections/questions
 * Make sure to backup first or test in dev environment
 */

import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';
import { TOPICS } from '../../src/data/topics.js';

// Setup __dirname for ES modules
const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

// Map difficulty label to slug
const difficultyMap = {
  'Basic': 'basic',
  'Intermediate': 'intermediate',
  'Advanced': 'advanced',
  'Coding': 'coding',
  'Scenario': 'scenario'
};

const sqlString = (value) => String(value).replace(/'/g, "''");

// Generate SQL
let sql = `-- ════════════════════════════════════════════════════════════════
-- DEVREADY DATA MIGRATION
-- Auto-generated from topics.js
-- Run this in: Supabase SQL Editor
-- ════════════════════════════════════════════════════════════════

`;

let topicOrder = 1;

// Insert topics, sections, and questions
TOPICS.forEach((topic) => {
  // Sanitize for SQL
  const topicSlug = topic.id.toLowerCase().replace(/[\s.#]/g, '_');
  const topicLabel = sqlString(topic.label);
  const topicColor = topic.color;
  const topicIdSelect = `(SELECT id FROM public.topics WHERE slug = '${topicSlug}')`;

  // Insert topic
  sql += `-- TOPIC: ${topic.label}\n`;
  sql += `INSERT INTO public.topics (slug, label, color_hex, display_order) VALUES\n`;
  sql += `  ('${topicSlug}', '${topicLabel}', '${topicColor}', ${topicOrder})\n`;
  sql += `ON CONFLICT (slug) DO NOTHING;\n`;
  sql += `\n`;

  let sectionOrder = 1;

  // Insert sections and questions
  topic.sections.forEach((section) => {
    const sectionSlug = section.id.toLowerCase();
    const sectionLabel = sqlString(section.label);
    const sectionIdSelect = `(SELECT id FROM public.sections WHERE slug = '${sectionSlug}' AND topic_id = ${topicIdSelect})`;

    sql += `-- SECTION: ${section.label}\n`;
    sql += `INSERT INTO public.sections (topic_id, slug, label, display_order) VALUES\n`;
    sql += `  (${topicIdSelect}, '${sectionSlug}', '${sectionLabel}', ${sectionOrder})\n`;
    sql += `ON CONFLICT (topic_id, slug) DO NOTHING;\n`;
    sql += `\n`;

    // Insert questions
    sql += `\nINSERT INTO public.questions (section_id, difficulty_id, serial_number, text) VALUES\n`;

    const questionValues = section.qs.map((q, idx) => {
      const questionText = sqlString(q[1]);
      const difficulty = difficultyMap[q[2]];
      const diffId = difficulty ? `(SELECT id FROM public.difficulty_levels WHERE slug = '${difficulty}')` : 1;
      return `  (${sectionIdSelect}, ${diffId}, ${idx + 1}, '${questionText}')`;
    });

    sql += questionValues.join(',\n') + `\nON CONFLICT DO NOTHING;\n\n`;

    sectionOrder++;
  });

  topicOrder++;
});

sql += `-- ════════════════════════════════════════════════════════════════
-- MIGRATION COMPLETE
-- All topics, sections, and questions have been inserted
-- ════════════════════════════════════════════════════════════════\n`;

// Write to file
const outputPath = path.join(__dirname, 'migrate-data.sql');
fs.writeFileSync(outputPath, sql, 'utf8');

console.log(`✅ Migration script created: ${outputPath}`);
console.log(`📊 Stats:`);
console.log(`   - Topics: ${TOPICS.length}`);
console.log(`   - Total Sections: ${TOPICS.reduce((acc, t) => acc + t.sections.length, 0)}`);
console.log(`   - Total Questions: ${TOPICS.reduce((acc, t) => acc + t.sections.reduce((s, sec) => s + sec.qs.length, 0), 0)}`);
console.log(`\n📝 Next steps:`);
console.log(`   1. Go to Supabase SQL Editor`);
console.log(`   2. Open and run: ${outputPath}`);
console.log(`   3. Verify all data inserted correctly`);
