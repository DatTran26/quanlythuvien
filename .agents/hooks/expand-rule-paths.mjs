/**
 * Expand BA-Kit rule `paths:` globs so they apply on Claude, Cursor, Codex, and Universal.
 * `.claude/skills/foo/**` → also `.cursor/.agents/.codex/skills/foo/**`
 * Idempotent.
 */
export const AGENT_ROOTS = ['.claude', '.cursor', '.agents', '.codex'];
const KIND_RE = /^\.(claude|cursor|agents|codex)\/(skills|hooks|agents|scripts)(\/.*)?$/;

export function expandGlobList(paths) {
  const out = [];
  const seen = new Set();
  const add = (value) => {
    if (!value || seen.has(value)) return;
    seen.add(value);
    out.push(value);
  };
  for (const raw of paths) {
    const item = String(raw || '').trim();
    const match = item.match(KIND_RE);
    if (!match) {
      add(item);
      continue;
    }
    const kind = match[2];
    const rest = match[3] || '';
    for (const root of AGENT_ROOTS) add(`${root}/${kind}${rest}`);
  }
  return out;
}

export function rewriteFrontmatterPaths(content) {
  if (!content.startsWith('---')) return { content, changed: false };
  const end = content.indexOf('\n---', 3);
  if (end < 0) return { content, changed: false };
  const fm = content.slice(4, end);
  const body = content.slice(end);
  const lines = fm.split(/\r?\n/);
  const pathsIndex = lines.findIndex((line) => /^paths:\s*$/.test(line));
  if (pathsIndex < 0) return { content, changed: false };

  const collected = [];
  let cursor = pathsIndex + 1;
  while (cursor < lines.length) {
    const line = lines[cursor];
    const item = line.match(/^\s+-\s+"([^"]+)"\s*$/) || line.match(/^\s+-\s+'([^']+)'\s*$/) || line.match(/^\s+-\s+(\S+)\s*$/);
    if (!item) break;
    collected.push(item[1]);
    cursor += 1;
  }
  if (!collected.length) return { content, changed: false };

  const expanded = expandGlobList(collected);
  const same = expanded.length === collected.length && expanded.every((value, index) => value === collected[index]);
  if (same) return { content, changed: false };

  const rendered = expanded.map((value) => `  - "${value}"`);
  const nextFm = [...lines.slice(0, pathsIndex + 1), ...rendered, ...lines.slice(cursor)].join('\n');
  return { content: `---\n${nextFm}${body}`, changed: true };
}
