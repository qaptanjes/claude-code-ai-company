// mdskills.ai + free-for.dev arsiv indirici
const fs = require('fs'), path = require('path')
const DEST = process.argv[2] || path.join(__dirname, '..', 'arsiv')
const B = 'https://www.mdskills.ai'
const sleep = ms => new Promise(r => setTimeout(r, ms))

const CATS = ['web-frontend','mobile','api-backend','devops-cloud','databases','security','testing-qa',
  'git-workflow','documents','data-analytics','design-creative','writing-docs','video-podcast','games-3d',
  'productivity','marketing-sales','customer-support','finance-commerce','research-academic',
  'legal-compliance','healthcare']
const SORTS = ['popular','trending','recent']
const LETTERS = 'abcdefghijklmnopqrstuvwxyz0123456789'.split('')

async function get(url, tries = 3) {
  for (let i = 0; i < tries; i++) {
    try {
      const r = await fetch(url, { signal: AbortSignal.timeout(30000) })
      if (r.status === 404) return null
      if (!r.ok) { await sleep(700 * (i + 1)); continue }
      return r
    } catch { await sleep(700 * (i + 1)) }
  }
  return null
}

async function pool(items, n, fn) {
  let i = 0
  await Promise.all(Array.from({ length: n }, async () => { while (i < items.length) await fn(items[i++]) }))
}

function fileFor(slug, fmt) {
  switch (fmt) {
    case 'cursorrules': return '.cursorrules'
    case 'clinerules':  return '.clinerules'
    case 'mdc':         return slug + '.mdc'
    case 'agents_md':   return 'AGENTS.md'
    case 'claude_md':   return 'CLAUDE.md'
    default:            return 'SKILL.md'
  }
}

async function enumerate(type) {
  const found = new Set()
  const probes = []
  const q = p => `${B}/api/skills?${new URLSearchParams({ ...p, artifact_type: type, limit: 50 })}`
  for (const s of SORTS) probes.push(q({ sort: s }))
  for (const c of CATS) for (const s of SORTS) probes.push(q({ category: c, sort: s }))
  for (const l of LETTERS) probes.push(q({ q: l }))
  for (const c of CATS) for (const l of LETTERS) probes.push(q({ category: c, q: l }))
  await pool(probes, 8, async url => {
    const r = await get(url); if (!r) return
    const j = await r.json()
    for (const s of j.skills || []) found.add(s.slug)
  })
  return [...found]
}

async function grab(kind, type, subdir) {
  process.stdout.write(`  ${kind} taraniyor... `)
  const slugs = await enumerate(type)
  process.stdout.write(`${slugs.length} kayit, indiriliyor `)
  const dest = path.join(DEST, subdir)
  fs.mkdirSync(dest, { recursive: true })
  const meta = []
  let n = 0, done = 0
  await pool(slugs, 8, async slug => {
    const r = await get(`${B}/api/skills/${encodeURIComponent(slug)}`)
    if (++done % 100 === 0) process.stdout.write('.')
    if (!r) return
    const j = await r.json(); const s = j && j.skill
    if (!s) return
    meta.push({ slug: s.slug, name: s.name, owner: s.owner, artifact_type: s.artifact_type,
      format_standard: s.format_standard, category: s.category && s.category.slug,
      license: s.license, github_url: s.github_url, downloads: s.downloads,
      tags: s.tags || [], permissions: s.permissions || {} })
    const dir = path.join(dest, s.slug.replace(/[<>:"/\\|?*\x00-\x1f]/g, '-'))
    fs.mkdirSync(dir, { recursive: true })
    if (s.content) { fs.writeFileSync(path.join(dir, fileFor(s.slug, s.format_standard)), s.content, 'utf8'); n++ }
    const cl = (s.clients || []).map(c => ({ client: c.client_name, install: c.install_instructions }))
    if (cl.length) {
      fs.writeFileSync(path.join(dir, 'INSTALL.md'),
        `# ${s.name}\n\n${s.github_url || ''}\n\n` +
        cl.map(c => `## ${c.client}\n\n\`\`\`bash\n${c.install || '(yok)'}\n\`\`\`\n`).join('\n'), 'utf8')
    }
  })
  fs.writeFileSync(path.join(dest, '_catalog.json'), JSON.stringify(meta, null, 2), 'utf8')
  console.log(` -> ${n} dosya`)
}

async function freeForDev() {
  process.stdout.write('  dev (free-for.dev) indiriliyor... ')
  const r = await get('https://raw.githubusercontent.com/ripienaar/free-for-dev/master/README.md')
  if (!r) { console.log('BASARISIZ'); return }
  const md = await r.text()
  const dest = path.join(DEST, 'dev'); fs.mkdirSync(path.join(dest, 'sections'), { recursive: true })
  fs.writeFileSync(path.join(dest, 'README.md'), md, 'utf8')

  const LINK = /\[([^\]]+)\]\(([a-z][a-z0-9+.-]*:[^)\s]+)\)/gi
  const slug = s => s.toLowerCase().replace(/[^a-z0-9]+/g, '-').replace(/^-|-$/g, '').slice(0, 60)
  const sections = []; let cur = null
  for (const line of md.split('\n')) {
    const m = line.match(/^## (.+?)\s*$/)
    if (m) { cur = { title: m[1], lines: [], entries: [] }; sections.push(cur); continue }
    if (cur) cur.lines.push(line)
  }
  const catalog = []
  for (const s of sections) {
    let last = null
    for (const raw of s.lines) {
      if (!/^\s*[-*+] /.test(raw)) continue
      const links = [...raw.matchAll(LINK)]
      const text = raw.replace(/^\s*[-*+]\s*/, '').trim()
      if (!links.length) { if (last) last.details.push(text); continue }
      const [full, name, url] = links[0]
      let d = raw.replace(/^\s*[-*+]\s*/, '').replace(full, '')
        .replace(/^\s*[—–\-:·|]+\s*/, '').replace(LINK, (_, t) => t).replace(/\s{2,}/g, ' ').trim()
      const e = { category: s.title, name: name.trim(), url, description: d, details: [] }
      catalog.push(e); s.entries.push(e); last = e
    }
  }
  sections.forEach((s, i) => {
    const n = String(i + 1).padStart(2, '0')
    fs.writeFileSync(path.join(dest, 'sections', `${n}-${slug(s.title)}.md`),
      `# ${s.title}\n\n> ${s.entries.length} kayit\n${s.lines.join('\n')}\n`, 'utf8')
  })
  fs.writeFileSync(path.join(dest, '_catalog.json'), JSON.stringify(catalog, null, 2), 'utf8')
  const apiCats = sections.filter(s => /api|data|ml/i.test(s.title)).map(s => s.title)
  fs.writeFileSync(path.join(dest, '_apis.json'),
    JSON.stringify(catalog.filter(e => apiCats.includes(e.category)), null, 2), 'utf8')
  console.log(`-> ${catalog.length} servis, ${sections.length} bolum`)
}

;(async () => {
  const t0 = Date.now()
  await grab('skills ', 'skill_pack',  'skills')
  await grab('rules  ', 'ruleset',     'rules')
  await grab('mcp    ', 'mcp_server',  'mcp')
  await grab('plugins', 'plugin',      'plugins')
  await freeForDev()
  console.log(`\n  Bitti - ${Math.round((Date.now() - t0) / 1000)} saniye\n`)
})()
