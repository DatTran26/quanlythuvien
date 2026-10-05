#!/usr/bin/env node
/**
 * BA-Kit hook runner — Windows-safe (Node, never ShellExecute .sh).
 *
 * Usage:
 *   node ba-kit-run.mjs sessionStart
 *   node ba-kit-run.mjs afterFileEdit
 *   node ba-kit-run.mjs changelog|stale|status|kg
 *   node ba-kit-run.mjs blockPush
 *
 * Stdin JSON is normalized for Claude Code, Cursor, and Codex.
 * Human text → stderr. Stdout is `{}` so Cursor can parse JSON.
 */
import { execFileSync } from 'node:child_process';
import crypto from 'node:crypto';
import fs from 'node:fs';
import path from 'node:path';

const PROJECT = path.resolve(process.env.PROJECT_PATH || process.cwd());
const EVENT = (process.argv[2] || 'afterFileEdit').trim();

function localIsoDate(date = new Date()) {
  const y = date.getFullYear();
  const m = String(date.getMonth() + 1).padStart(2, '0');
  const d = String(date.getDate()).padStart(2, '0');
  return `${y}-${m}-${d}`;
}

function isoWeek(date = new Date()) {
  const tmp = new Date(Date.UTC(date.getFullYear(), date.getMonth(), date.getDate()));
  const day = tmp.getUTCDay() || 7;
  tmp.setUTCDate(tmp.getUTCDate() + 4 - day);
  const yearStart = new Date(Date.UTC(tmp.getUTCFullYear(), 0, 1));
  const week = Math.ceil((((tmp - yearStart) / 86400000) + 1) / 7);
  return `${tmp.getUTCFullYear()}-W${String(week).padStart(2, '0')}`;
}

function daysAgo(n) {
  const date = new Date();
  date.setDate(date.getDate() - n);
  return localIsoDate(date);
}

function readStdinSync() {
  try {
    return fs.readFileSync(0, 'utf8');
  } catch {
    return '';
  }
}

export function parseHookPayload(raw) {
  const text = String(raw || '').trim();
  if (!text) return {};
  try {
    const parsed = JSON.parse(text);
    return parsed && typeof parsed === 'object' ? parsed : {};
  } catch {
    return {};
  }
}

export function extractFile(payload) {
  if (!payload || typeof payload !== 'object') return '';
  const tool = payload.tool_input && typeof payload.tool_input === 'object' ? payload.tool_input : {};
  const args = payload.arguments && typeof payload.arguments === 'object' ? payload.arguments : {};
  return String(
    payload.file_path
    || payload.filePath
    || payload.path
    || payload.file
    || tool.file_path
    || tool.path
    || tool.filePath
    || tool.file
    || args.file_path
    || args.path
    || args.filePath
    || '',
  );
}

export function extractCommand(payload) {
  if (!payload || typeof payload !== 'object') return '';
  const tool = payload.tool_input && typeof payload.tool_input === 'object' ? payload.tool_input : {};
  const args = payload.args && typeof payload.args === 'object' ? payload.args : {};
  return String(payload.command || tool.command || args.command || '');
}

export function toProjectRel(filePath, projectRoot = PROJECT) {
  if (!filePath) return '';
  const abs = path.isAbsolute(filePath) ? path.normalize(filePath) : path.resolve(projectRoot, filePath);
  const rel = path.relative(projectRoot, abs);
  if (!rel || rel.startsWith('..') || path.isAbsolute(rel)) return abs.split(path.sep).join('/');
  return rel.split(path.sep).join('/');
}

export function isAtlassianSyncStateRel(rel) {
  const file = String(rel || '').replace(/\\/g, '/');
  return /(?:^|\/)\.(?:agents|claude)\/state\/atlassian\/sync-state\.yaml$/.test(file);
}

export function inferSkillFromRel(rel) {
  const file = String(rel || '').replace(/\\/g, '/');
  const rules = [
    [/\/userstories\//, '/userstory'],
    [/\/usecases\//, '/usecase'],
    [/\/brainstorms\//, '/brainstorm'],
    [/\/ascii-wireframe\//, '/wireframe-ascii'],
    [/\/html-wireframe\//, '/wireframe-html'],
    [/\/test\/checklist\//, '/test-checklist'],
    [/\/test\/testcases\//, '/test-cases'],
    [/\/test\/api\//, '/api-test'],
    [/\/test\/e2e\//, '/playwright-gen'],
    [/\/dbdiagram\//, '/erd'],
    [/-erd\.md$/, '/erd'],
    [/-states\.md$/, '/state'],
    [/-flows\.md$/, '/sequence'],
    [/-userflow\.md$/, '/user-flow'],
    [/-spec\.md$/, '/srs'],
    [/docs\/_product\/prd/, '/prd-epic'],
    [/docs\/_product\/urd/, '/urd'],
    [/docs\/_product\/brd/, '/brd'],
    [/docs\/_product\/roadmap/, '/roadmap'],
    [/docs\/meetings\//, '/meet'],
    [/docs\/userguide\//, '/userguide'],
    [/docs\/_research\//, '/discover'],
    [/docs\/_reverse\//, '/reverse-doc'],
    [/(?:^|\/)\.(?:agents|claude)\/state\/atlassian\//, '/jira'],
    [/(?:^|\/)\.(?:agents|claude)\/state\/delegate-roster/, '/delegate'],
  ];
  for (const [pattern, skill] of rules) {
    if (pattern.test(file)) return skill;
  }
  return 'manual';
}

function posixJoin(...parts) {
  return parts.join('/').replace(/\\/g, '/');
}

function absFromRel(rel) {
  return path.resolve(PROJECT, rel.split('/').join(path.sep));
}

function existsRel(rel) {
  try {
    return fs.existsSync(absFromRel(rel));
  } catch {
    return false;
  }
}

function readRel(rel) {
  return fs.readFileSync(absFromRel(rel), 'utf8');
}

function writeRel(rel, text) {
  const full = absFromRel(rel);
  fs.mkdirSync(path.dirname(full), { recursive: true });
  fs.writeFileSync(full, text);
}

function appendRel(rel, text) {
  const full = absFromRel(rel);
  fs.mkdirSync(path.dirname(full), { recursive: true });
  fs.appendFileSync(full, text);
}

function walkFiles(rootDir, { match, skipDir } = {}) {
  const out = [];
  if (!fs.existsSync(rootDir)) return out;
  const stack = [rootDir];
  while (stack.length) {
    const dir = stack.pop();
    let entries = [];
    try {
      entries = fs.readdirSync(dir, { withFileTypes: true });
    } catch {
      continue;
    }
    for (const entry of entries) {
      const full = path.join(dir, entry.name);
      if (entry.isDirectory()) {
        const rel = toProjectRel(full);
        if (skipDir && skipDir(rel, entry.name)) continue;
        stack.push(full);
        continue;
      }
      if (entry.isFile() && (!match || match(full, entry.name))) out.push(full);
    }
  }
  return out;
}

function frontmatterBlock(text) {
  const match = String(text).match(/^---\r?\n([\s\S]*?)\r?\n---/);
  return match ? match[1] : '';
}

function frontmatterField(text, field) {
  const block = frontmatterBlock(text);
  if (!block) return '';
  const line = block.match(new RegExp(`^${field}:\\s*(.*)$`, 'm'));
  return line ? line[1].trim() : '';
}

function parseLinks(text) {
  const block = frontmatterBlock(text);
  if (!block) return [];
  const items = [];
  const inline = block.match(/^links:\s*\[([^\]]*)\]\s*$/m);
  if (inline) {
    for (const raw of inline[1].split(',')) {
      const item = raw.trim().replace(/^['"]|['"]$/g, '');
      if (item) items.push(item);
    }
    return items;
  }
  const lines = block.split(/\r?\n/);
  let inLinks = false;
  for (const line of lines) {
    if (/^links:\s*$/.test(line)) {
      inLinks = true;
      continue;
    }
    if (inLinks) {
      if (/^[a-zA-Z_]+:/.test(line) || /^---\s*$/.test(line)) break;
      const item = line.match(/^\s*-\s+(.+?)\s*$/);
      if (item) items.push(item[1].replace(/^['"]|['"]$/g, ''));
    }
  }
  return items;
}

function setFrontmatterStatus(text, status) {
  const match = String(text).match(/^(---\r?\n)([\s\S]*?)(\r?\n---)/);
  if (!match) return text;
  const nl = match[1].includes('\r') ? '\r\n' : '\n';
  const lines = match[2].split(/\r?\n/).filter((line) => !/^stale_reason:/.test(line));
  const next = lines.map((line) => (/^status:/.test(line) ? `status: ${status}` : line));
  return `${match[1]}${next.join(nl)}${match[3]}${text.slice(match[0].length)}`;
}

function escapeCell(value) {
  return String(value || '').replace(/[\r\n]+/g, ' ').replace(/\|/g, '\\|');
}

function gitUserName() {
  try {
    return execFileSync('git', ['config', 'user.name'], {
      cwd: PROJECT,
      encoding: 'utf8',
      stdio: ['ignore', 'pipe', 'ignore'],
    }).trim();
  } catch {
    return '';
  }
}

function readIdentityHandle() {
  const rel = '.agents/state/identity.yaml';
  if (!existsRel(rel)) return '';
  const match = readRel(rel).match(/^\s*current_user:\s*(.+?)\s*$/m);
  if (!match) return '';
  const value = match[1].replace(/^['"]|['"]$/g, '').trim();
  if (!value || value === 'null' || value.startsWith('#')) return '';
  return value.startsWith('@') ? value : `@${value}`;
}

export function resolveChangelogSkill(rel) {
  return process.env.CLAUDE_SKILL_NAME
    || process.env.BA_KIT_SKILL_NAME
    || inferSkillFromRel(rel)
    || 'manual';
}

export function resolveChangelogAuthor() {
  return process.env.CLAUDE_CHANGELOG_AUTHOR
    || process.env.BA_KIT_CHANGELOG_AUTHOR
    || readIdentityHandle()
    || gitUserName()
    || 'unknown';
}

export function resolveChangelogNote() {
  return process.env.CLAUDE_CHANGELOG_NOTE
    || process.env.BA_KIT_CHANGELOG_NOTE
    || 'manual edit';
}

export function shouldChangelog(rel) {
  if (!/^docs\/.+\.md$/.test(rel)) return false;
  if (/feature-list\.md$/.test(rel) || /README\.md$/.test(rel)) return false;
  if (/\/_shared\//.test(rel) || /\/exports\//.test(rel) || /\/inbox\//.test(rel)) return false;
  return existsRel(rel);
}

export function shouldStale(rel) {
  if (!/^docs\/.+\.md$/.test(rel)) return false;
  if (/\/_shared\//.test(rel) || /\/exports\//.test(rel) || /\/inbox\//.test(rel) || /\/docs\/cr\//.test(rel) || /\/cr\//.test(rel)) return false;
  return existsRel(rel);
}

export function shouldKg(rel) {
  if (/docs\/_shared\/kg(\/|$)/.test(rel)) return false;
  if (/docs\/(exports|inbox|reports|_regen-sample|guides)\//.test(rel)) return false;
  if (/docs\/.+\.md$/.test(rel)) return true;
  if (/docs\/.+bpmn\/.+\.ir\.json$/.test(rel)) return true;
  if (/docs\/features\/[^/]+\/dbdiagram\/.+\.dbml$/.test(rel)) return true;
  if (isAtlassianSyncStateRel(rel)) return true;
  return false;
}

function ensureLog(rel, headerLines) {
  const full = absFromRel(rel);
  if (fs.existsSync(full) && fs.statSync(full).size > 0) return;
  fs.mkdirSync(path.dirname(full), { recursive: true });
  fs.writeFileSync(full, `${headerLines.join('\n')}\n`);
}

function runChangelog(rel) {
  if (process.env.AUTO_CHANGELOG && process.env.AUTO_CHANGELOG !== 'true') return;
  if (!shouldChangelog(rel)) return;
  const date = localIsoDate();
  const skill = escapeCell(resolveChangelogSkill(rel));
  const note = escapeCell(resolveChangelogNote());
  const author = escapeCell(resolveChangelogAuthor());
  const logRel = 'docs/_shared/changelog.md';
  ensureLog(logRel, [
    '# Changelog',
    '',
    '> Lịch sử thay đổi toàn vault — append-only, mới nhất ở cuối. Writer duy nhất: hook `ba-kit-run.mjs`. Xem rule `changelog.md`.',
    '',
    '| Ngày | Skill | Người | File | Ghi chú |',
    '|---|---|---|---|---|',
  ]);
  const line = `| ${date} | ${skill} | ${author} | \`${rel}\` | ${note} |`;
  const current = readRel(logRel);
  if (current.split(/\r?\n/).includes(line)) return;
  appendRel(logRel, `${line}\n`);
}

function runStale(rel) {
  if (!shouldStale(rel)) return;
  const date = localIsoDate();
  const skill = resolveChangelogSkill(rel);
  const logRel = 'docs/_shared/staleness.md';
  ensureLog(logRel, [
    '# Staleness Log',
    '',
    '> Lan truyền `status: stale` khi upstream đổi — append-only, mới nhất ở cuối. Writer duy nhất: hook `ba-kit-run.mjs`.',
    '',
    '| Ngày | Upstream đổi | Downstream bị đánh stale | Lý do |',
    '|---|---|---|---|',
  ]);
  const docsRoot = path.join(PROJECT, 'docs');
  const candidates = walkFiles(docsRoot, {
    match: (_full, name) => name.endsWith('.md'),
    skipDir: (dirRel) => /\/(exports|inbox|cr|_reverse)(\/|$)/.test(`${dirRel}/`),
  });
  let propagated = 0;
  for (const full of candidates) {
    const candidateRel = toProjectRel(full);
    if (candidateRel === rel) continue;
    let text;
    try {
      text = fs.readFileSync(full, 'utf8');
    } catch {
      continue;
    }
    if (!parseLinks(text).includes(rel)) continue;
    const status = frontmatterField(text, 'status');
    if (status === 'stale' || status === 'archived') continue;
    const next = setFrontmatterStatus(text, 'stale');
    fs.writeFileSync(full, next);
    propagated += 1;
    const reason = `upstream changed: ${rel} on ${date} by ${skill}`;
    appendRel(logRel, `| ${date} | \`${rel}\` | \`${candidateRel}\` | ${reason} |\n`);
  }
  if (propagated > 0) {
    process.stderr.write(`  ↳ stale propagated to ${propagated} downstream doc(s). Check docs/_shared/staleness.md.\n`);
  }
}

function runStatus(rel) {
  if (!/^docs\/.+\.md$/.test(rel) || !existsRel(rel)) return;
  const text = readRel(rel);
  const current = frontmatterField(text, 'status');
  if (!current) return;
  const hash = crypto.createHash('sha1').update(rel).digest('hex').slice(0, 16);
  const stateRel = posixJoin('docs/_shared/.status-state', hash);
  let previous = '';
  if (existsRel(stateRel)) previous = readRel(stateRel).trim();
  const feature = frontmatterField(text, 'feature');
  if (current !== previous && previous) {
    process.stderr.write(`  ↳ status: ${previous} → ${current}\n`);
    const hints = {
      'in-review': '  ↳ suggested: chờ reviewer (người/stakeholder) duyệt\n',
      approved: feature ? `  ↳ suggested: /gap --feature ${feature}\n` : '  ↳ suggested: /gap\n',
      shipped: '  ↳ suggested: /gap --scope project (re-verify cross-feature)\n',
      stale: '  ↳ suggested: /cr \'<change>\' --feature (reconcile upstream change)\n',
      revisions: '  ↳ suggested: xử lý review findings rồi chạy lại skill sinh doc (/urd|/brd|/prd-epic|/srs) hoặc /cr\n',
    };
    if (hints[current]) process.stderr.write(hints[current]);
  }
  writeRel(stateRel, `${current}\n`);
}

function runKg(rel) {
  if (!shouldKg(rel)) return;
  const dirtyRel = 'docs/_shared/kg/.dirty';
  fs.mkdirSync(path.dirname(absFromRel(dirtyRel)), { recursive: true });
  fs.writeFileSync(absFromRel(dirtyRel), '');
}

function countByStatus(files, status) {
  let n = 0;
  for (const full of files) {
    try {
      if (frontmatterField(fs.readFileSync(full, 'utf8'), 'status') === status) n += 1;
    } catch { /* skip */ }
  }
  return n;
}

function copyTreeIfMissing(from, to) {
  if (!fs.existsSync(from)) return 0;
  const stat = fs.lstatSync(from);
  if (stat.isSymbolicLink()) return 0;
  if (stat.isFile()) {
    if (fs.existsSync(to)) return 0;
    fs.mkdirSync(path.dirname(to), { recursive: true });
    fs.copyFileSync(from, to);
    return 1;
  }
  if (!stat.isDirectory()) return 0;
  fs.mkdirSync(to, { recursive: true });
  let n = 0;
  for (const name of fs.readdirSync(from)) {
    n += copyTreeIfMissing(path.join(from, name), path.join(to, name));
  }
  return n;
}

function migrateLegacyClaudeState() {
  const dest = path.join(PROJECT, '.agents', 'state');
  const legacy = path.join(PROJECT, '.claude', 'state');
  fs.mkdirSync(dest, { recursive: true });
  const readme = path.join(dest, 'README.md');
  if (!fs.existsSync(readme)) {
    fs.writeFileSync(readme, [
      '# Shared BA-Kit state (all agents)',
      '',
      'Canonical project state — not Claude Code session memory.',
      'See `atlassian/`, `identity.yaml`. Do not store tokens here.',
      '',
    ].join('\n'));
  }
  copyTreeIfMissing(legacy, dest);
}

function ensureIdentityFile() {
  const rel = '.agents/state/identity.yaml';
  if (existsRel(rel)) return;
  const name = gitUserName();
  const handle = name ? (name.startsWith('@') ? name : `@${name}`) : '';
  writeRel(rel, [
    '# Shared BA operator handle for changelog. Not a secret.',
    '# Cursor/Codex read this; Claude Code may also use memory user-identity.md.',
    `current_user: ${handle}`,
    '',
  ].join('\n'));
}

function runSessionStart() {
  migrateLegacyClaudeState();
  ensureIdentityFile();
  let projectName = 'No CLAUDE.md found';
  for (const name of ['CLAUDE.md', 'AGENTS.md']) {
    if (!existsRel(name)) continue;
    const heading = readRel(name).split(/\r?\n/).find((line) => line.startsWith('# '));
    if (!heading) continue;
    projectName = heading.slice(2).replace(/ — BA Workspace$/, '').replace('{Project Name}', 'Unnamed Project');
    break;
  }
  const banner = [
    '═══════════════════════════════════════════════',
    `  ${projectName}`,
    '═══════════════════════════════════════════════',
    `  Today: ${localIsoDate()}  |  Week: ${isoWeek()}`,
  ];
  const specFiles = walkFiles(path.join(PROJECT, 'docs'), {
    match: (full) => /[\\/]srs[\\/](spec\.md|.+-spec\.md)$/.test(full),
  });
  if (specFiles.length) {
    const draft = countByStatus(specFiles, 'draft');
    const review = countByStatus(specFiles, 'in-review');
    const revisions = countByStatus(specFiles, 'revisions');
    const approved = countByStatus(specFiles, 'approved');
    const shipped = countByStatus(specFiles, 'shipped');
    const stale = countByStatus(specFiles, 'stale');
    const total = draft + review + revisions + approved + shipped + stale;
    if (total > 0) {
      banner.push(`  SRS (${total}): draft=${draft}  in-review=${review}  revisions=${revisions}  approved=${approved}  shipped=${shipped}  stale=${stale}`);
    }
  }
  const crFiles = walkFiles(path.join(PROJECT, 'docs', 'cr'), {
    match: (_full, name) => /^CR-.*\.md$/.test(name),
  });
  const openCr = crFiles.filter((full) => {
    const status = frontmatterField(fs.readFileSync(full, 'utf8'), 'status');
    return status === 'proposed' || status === 'impact-assessed' || status === 'applied';
  }).length;
  if (openCr > 0) banner.push(`  Open CRs: ${openCr} (run /cr list)`);

  const staleLog = 'docs/_shared/staleness.md';
  if (existsRel(staleLog)) {
    const cutoff = daysAgo(7);
    const recent = readRel(staleLog).split(/\r?\n/).filter((line) => {
      const cols = line.split('|');
      const day = (cols[1] || '').trim();
      return /^\d{4}-\d{2}-\d{2}$/.test(day) && day >= cutoff;
    }).length;
    if (recent > 0) banner.push(`  ⏰ Stale propagations (7d): ${recent} (run /dashboard để xem stale chain)`);
  }

  const staleDocs = walkFiles(path.join(PROJECT, 'docs'), {
    match: (_full, name) => name.endsWith('.md'),
    skipDir: (dirRel) => /\/(exports|inbox)(\/|$)/.test(`${dirRel}/`),
  }).filter((full) => frontmatterField(fs.readFileSync(full, 'utf8'), 'status') === 'stale').length;
  if (staleDocs > 0) banner.push(`  ⏰ Stale docs: ${staleDocs} (run /dashboard để xem detail)`);

  let oq = 0;
  for (const full of walkFiles(path.join(PROJECT, 'docs'), { match: (_full, name) => name.endsWith('.md') })) {
    const text = fs.readFileSync(full, 'utf8');
    const lines = text.match(/^- \[ \].*(?:[Oo]pen [Qq]uestion|OQ:).*$/gm);
    if (lines) oq += lines.length;
  }
  if (oq > 0) banner.push(`  Open questions: ${oq} (run /oq to review)`);

  const inboxDir = path.join(PROJECT, 'docs', 'inbox');
  if (fs.existsSync(inboxDir)) {
    const inbox = fs.readdirSync(inboxDir).filter((name) => name.endsWith('.md')).length;
    if (inbox > 0) banner.push(`  Inbox: ${inbox} item(s) waiting`);
  }

  banner.push('═══════════════════════════════════════════════', '');
  process.stderr.write(`${banner.join('\n')}\n`);
}

function deniedPush(command) {
  const norm = String(command || '').replace(/\n/g, ' ').replace(/\s+/g, ' ');
  if (/\bgit\b[^;&|]*\bpush\b/.test(norm)) return 'git push';
  if (/\bgit\b[^;&|]*\bsvn\b[^;&|]*\bdcommit\b/.test(norm)) return 'git svn dcommit';
  if (/\bgh\b\s+(pr\s+(create|merge|ready)|release\s+(create|upload)|repo\s+sync)/.test(norm)) {
    return 'gh (tạo/merge PR hoặc release)';
  }
  if (/\bgit\b[^;&|]*\b(send-pack|push-all)\b/.test(norm)) return 'git send-pack';
  return '';
}

function runBlockPush(payload) {
  const command = extractCommand(payload);
  if (!command) return { deny: false };
  const reason = deniedPush(command);
  if (!reason) return { deny: false };
  const message = [
    `⛔ BỊ CHẶN bởi hook block-push: "${reason}"`,
    '',
    'Quy ước dự án: AI CHỈ được commit, KHÔNG được push lên remote.',
    'Việc push do người dùng tự làm tay.',
    '',
    '→ Hãy dừng lại, báo cho user rằng commit đã xong và họ có thể tự chạy:',
    '    git push',
    '',
    'KHÔNG tìm cách lách lệnh này bằng cú pháp khác.',
    '',
  ].join('\n');
  process.stderr.write(message);
  return {
    deny: true,
    stdout: {
      permission: 'deny',
      user_message: `Blocked ${reason}. Push is a human action.`,
      agent_message: message,
    },
  };
}

function runAfterFileEdit(rel) {
  runChangelog(rel);
  runStatus(rel);
  runStale(rel);
  runKg(rel);
}

async function main() {
  const payload = parseHookPayload(readStdinSync());
  const rel = toProjectRel(extractFile(payload));
  let stdout = {};
  let exitCode = 0;

  try {
    switch (EVENT) {
      case 'sessionStart':
      case 'SessionStart':
        runSessionStart();
        break;
      case 'afterFileEdit':
      case 'PostToolUse':
        runAfterFileEdit(rel);
        break;
      case 'changelog':
        runChangelog(rel);
        break;
      case 'stale':
        runStale(rel);
        break;
      case 'status':
        runStatus(rel);
        break;
      case 'kg':
        runKg(rel);
        break;
      case 'blockPush':
      case 'PreToolUse': {
        const result = runBlockPush(payload);
        if (result.deny) {
          stdout = result.stdout;
          exitCode = 2;
        }
        break;
      }
      default:
        process.stderr.write(`ba-kit-run: unknown event "${EVENT}"\n`);
    }
  } catch (error) {
    process.stderr.write(`ba-kit-run: ${error.message}\n`);
    exitCode = EVENT === 'blockPush' ? 2 : 0;
  }

  process.stdout.write(`${JSON.stringify(stdout)}\n`);
  process.exit(exitCode);
}

const invokedDirectly = process.argv[1] && path.normalize(process.argv[1]).endsWith('ba-kit-run.mjs');
if (invokedDirectly && !process.env.BA_KIT_HOOK_TEST) {
  await main();
}
