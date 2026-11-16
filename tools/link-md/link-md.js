// Gắn link code cho các tham chiếu `Class.member` / `File.java` trong file md của repo nro-long.
// Dùng (ở thư mục repo): node tools/link-md/link-md.js . [--dry] [--refresh] *.md
// --refresh: gỡ link code cũ rồi gắn lại để cập nhật số dòng. VERBOSE=1 in từng link. Không đụng khối ```code```.
const fs = require('fs');
const path = require('path');

const args = process.argv.slice(2);
const root = path.resolve(args.shift());
let dry = false, refresh = false;
while (args[0] && args[0].startsWith('--')) {
  const a = args.shift();
  if (a === '--dry') dry = true;
  if (a === '--refresh') refresh = true; // gỡ link code cũ rồi gắn lại (cập nhật số dòng)
}
const files = args;
const srcRoot = path.join(root, 'Teamobi2026', 'src');

// Index lớp Java: tên lớp -> [đường dẫn]
const index = new Map();
(function walk(dir) {
  for (const e of fs.readdirSync(dir, { withFileTypes: true })) {
    const p = path.join(dir, e.name);
    if (e.isDirectory()) walk(p);
    else if (e.name.endsWith('.java')) {
      const cls = e.name.slice(0, -5);
      if (!index.has(cls)) index.set(cls, []);
      index.get(cls).push(p);
    }
  }
})(srcRoot);

const fileCache = new Map();
function lines(p) {
  if (!fileCache.has(p)) fileCache.set(p, fs.readFileSync(p, 'utf8').split(/\r?\n/));
  return fileCache.get(p);
}

const NOT_DECL = /^\s*(return|if|else|for|while|switch|case|new|throw|this\.|super|\/\/|\*)/;
function findMember(p, member) {
  const ls = lines(p);
  const esc = member.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
  const method = new RegExp(`^\\s*(public|private|protected|static|final|synchronized|abstract|[\\w<>\\[\\],.]+)\\s[^=;]*\\b${esc}\\s*\\(`);
  const field = new RegExp(`^\\s*(public|private|protected|static|final)[^(]*\\b${esc}\\s*(=|;|,)`);
  const enumConst = new RegExp(`^\\s*${esc}\\s*(\\(|,|;)`);
  for (let i = 0; i < ls.length; i++) {
    const l = ls[i];
    if (NOT_DECL.test(l)) continue;
    if (method.test(l) && !/;\s*$/.test(l)) return i + 1;
  }
  for (let i = 0; i < ls.length; i++) {
    if (field.test(ls[i])) return i + 1;
  }
  for (let i = 0; i < ls.length; i++) {
    if (enumConst.test(ls[i])) return i + 1;
  }
  return 0;
}

function resolveClass(name, hintPath) {
  const c = index.get(name);
  if (!c) return null;
  if (c.length === 1) return c[0];
  if (hintPath) {
    const m = c.filter(p => p.replace(/\\/g, '/').endsWith(hintPath));
    if (m.length === 1) return m[0];
  }
  return null;
}

function resolve(token) {
  let t = token.trim().replace(/\(.*\)$/, '');
  // Đường dẫn / tên file .java
  let m = t.match(/^((?:[\w-]+\/)*)([A-Za-z_]\w*)\.java$/);
  if (m) {
    const p = resolveClass(m[2], (m[1] || '') + m[2] + '.java');
    return p ? { p, line: 0 } : null;
  }
  // Lop.thanh_vien
  m = t.match(/^([A-Z]\w*)\.([A-Za-z_]\w*)$/);
  if (m) {
    const p = resolveClass(m[1]);
    if (!p) return null;
    return { p, line: findMember(p, m[2]) };
  }
  // Chỉ tên lớp
  m = t.match(/^([A-Z][a-z]\w*)$/);
  if (m) {
    const p = resolveClass(m[1]);
    return p ? { p, line: 0 } : null;
  }
  return null;
}

let total = 0;
for (const f of files) {
  const abs = path.resolve(root, f);
  const text = fs.readFileSync(abs, 'utf8');
  const nl = text.includes('\r\n') ? '\r\n' : '\n';
  const out = [];
  let inFence = false, count = 0;
  for (const line of text.split(/\r?\n/)) {
    if (/^\s*```/.test(line)) { inFence = !inFence; out.push(line); continue; }
    if (inFence) { out.push(line); continue; }
    const src = refresh ? line.replace(/\[(`[^`\n]+`)\]\([^)\s]*Teamobi2026\/src\/[^)\s]*\)/g, '$1') : line;
    out.push(src.replace(/(?<!\[)`([^`\n]+)`(?!\]\()/g, (all, tok) => {
      const r = resolve(tok);
      if (!r) return all;
      let rel = path.relative(path.dirname(abs), r.p).replace(/\\/g, '/');
      if (r.line) rel += '#L' + r.line;
      if (process.env.VERBOSE) console.log(`  ${tok} -> ${rel} | ${r.line ? lines(r.p)[r.line - 1].trim().slice(0, 90) : '(file)'}`);
      count++;
      return `[\`${tok}\`](${rel})`;
    }));
  }
  total += count;
  console.log(`${f}: ${count} link`);
  if (!dry && count) fs.writeFileSync(abs, out.join(nl), 'utf8');
}
console.log('Tổng:', total);
