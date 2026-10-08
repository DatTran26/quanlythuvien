import { createHash } from 'node:crypto';
import { existsSync, readFileSync } from 'node:fs';
import { dirname, join, resolve } from 'node:path';
import { fileURLToPath } from 'node:url';

const repoRoot = resolve(dirname(fileURLToPath(import.meta.url)), '..');
const featureRoot = join(repoRoot, 'docs', 'features', 'library-management-platform');
const wireframeRoot = join(featureRoot, 'html-wireframe');
const userflowPath = join(featureRoot, 'srs', 'library-management-platform-userflow.md');
const allowedColors = new Set(['#000', '#fff', '#f0f0f0', '#888', '#ccc']);
const flows = new Map([
  ['auth-flow.html', ['access-login', 'forgot-password', 'reset-password', 'dashboard-home', 'session-expired']],
  ['catalog-admin-flow.html', ['catalog-search', 'bibliographic-detail', 'bibliographic-form', 'copy-inventory', 'copy-form']],
  ['reader-admin-flow.html', ['reader-list', 'reader-form', 'reader-detail']],
  ['checkout-flow.html', ['circulation-desk', 'checkout-scan', 'checkout-review', 'checkout-conflict']],
  ['return-renewal-flow.html', ['return-scan', 'return-result', 'renewal-result']],
  ['reservation-flow.html', ['reservation-search', 'reservation-form', 'reservation-queue', 'reservation-pickup']],
  ['fine-payment-flow.html', ['fine-list', 'fine-detail', 'fine-payment', 'financial-events']],
  ['damage-lost-found-flow.html', ['damage-report-form', 'damage-report-detail', 'lost-found']],
  ['notification-audit-flow.html', ['notification-status', 'audit-log', 'history-timeline']],
  ['admin-import-flow.html', ['admin-config', 'import-upload', 'import-report']],
  ['reports-flow.html', ['report-dashboard']],
]);

const failures = [];
const fail = message => failures.push(message);
const read = path => readFileSync(path, 'utf8').replaceAll('\r\n', '\n');
const matches = (text, regex) => [...text.matchAll(regex)];

function verifyLocalLinks(fileName, html) {
  for (const match of matches(html, /<(?:a|iframe)\b[^>]*(?:href|src)="([^"]+)"/g)) {
    const ref = match[1];
    if (/^(?:https?:|mailto:|javascript:)/i.test(ref)) continue;
    const [relativeFile, fragment] = ref.split('#');
    const targetPath = relativeFile ? resolve(wireframeRoot, relativeFile) : join(wireframeRoot, fileName);
    if (!targetPath.startsWith(wireframeRoot) || !existsSync(targetPath)) {
      fail(`${fileName}: broken local target ${ref}`);
      continue;
    }
    if (fragment && !read(targetPath).includes(`id="${fragment}"`)) {
      fail(`${fileName}: missing fragment target ${ref}`);
    }
  }
}

let totalScreens = 0;
for (const [fileName, expectedLabels] of flows) {
  const path = join(wireframeRoot, fileName);
  if (!existsSync(path)) {
    fail(`missing flow ${fileName}`);
    continue;
  }
  const html = read(path);
  const ids = matches(html, /class="wf-screen"\s+id="s(\d+)"/g).map(match => Number(match[1]));
  const expectedIds = expectedLabels.map((_, index) => index + 1);
  if (JSON.stringify(ids) !== JSON.stringify(expectedIds)) fail(`${fileName}: screen ids ${ids.join(',')}`);
  totalScreens += ids.length;

  const labels = matches(html, /class="wf-screen-label">([^<]+)</g).map(match => match[1].trim());
  if (JSON.stringify(labels) !== JSON.stringify(expectedLabels)) fail(`${fileName}: labels ${labels.join(',')}`);
  if (matches(html, /class="wf-desc-table"/g).length !== 1) fail(`${fileName}: expected one description table`);
  if (matches(html, /class="wf-desc-screen-header"/g).length !== expectedLabels.length) fail(`${fileName}: description header count`);
  if (!html.includes('data-device="mobile"') || !html.includes('width: 375px') && !html.includes('width:375px')) fail(`${fileName}: Mobile 375 contract`);
  if (!html.includes('href="library-management-platform-wireframe.html"')) fail(`${fileName}: breadcrumb`);
  if (!/window\.self\s*!==\s*window\.top/.test(html)) fail(`${fileName}: iframe breadcrumb script`);
  if (/\{\{.*?\}\}/s.test(html)) fail(`${fileName}: unresolved template placeholder`);

  for (const color of new Set(matches(html, /#[0-9a-fA-F]{3,6}\b/g).map(match => match[0].toLowerCase()))) {
    if (!allowedColors.has(color)) fail(`${fileName}: disallowed color ${color}`);
  }
  for (const anchor of matches(html, /<a\b[^>]*>/g)) if (!/\bhref=/.test(anchor[0])) fail(`${fileName}: anchor without href`);
  for (const button of matches(html, /<button\b[^>]*>/g)) if (!/\btype="button"/.test(button[0])) fail(`${fileName}: button without type=button`);
  verifyLocalLinks(fileName, html);
}

if (flows.size !== 11 || totalScreens !== 38) fail(`inventory ${flows.size} flows / ${totalScreens} screens`);

const entryName = 'library-management-platform-wireframe.html';
const entryPath = join(wireframeRoot, entryName);
const indexPath = join(wireframeRoot, 'library-management-platform-wireframe-html-index.md');
if (!existsSync(entryPath)) fail('missing entry HTML');
else {
  const entry = read(entryPath);
  if (matches(entry, /data-flow="[^"]+"/g).length !== 11) fail('entry flow count');
  verifyLocalLinks(entryName, entry);
}
if (!existsSync(indexPath)) fail('missing metadata index');

const userflow = read(userflowPath);
const start = userflow.indexOf('## 1. User Flow (tổng)');
const end = userflow.indexOf('## 2. Danh sách màn hình');
let verifiedHash = 'unknown';
if (start < 0 || end < 0 || end <= start) {
  fail('cannot extract userflow section 1');
} else {
  const canonical = `${userflow.slice(start, end).trimEnd()}\n`;
  const actualHash = createHash('sha256').update(canonical).digest('hex').slice(0, 8);
  verifiedHash = actualHash;
  const storedHash = /flow_hash:\s*"?([0-9a-f]{8})"?/i.exec(userflow)?.[1];
  if (actualHash !== storedHash) fail(`flow hash mismatch: stored=${storedHash} actual=${actualHash}`);
  if (existsSync(indexPath) && !read(indexPath).includes(`flow_hash: ${actualHash}`)) fail('metadata index flow hash mismatch');
}

if (failures.length) {
  console.error(`Wireframe verification failed (${failures.length})`);
  for (const failure of failures) console.error(`- ${failure}`);
  process.exit(1);
}

console.log(`Wireframe verification passed: ${flows.size} flows, ${totalScreens} screens, hash ${verifiedHash}.`);
