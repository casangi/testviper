/* ══════════════════════════════════════════════════════════════════════════
   VIPER Ecosystem Dashboard — Engine
   ──────────────────────────────────────────────────────────────────────────
   This file contains all runtime logic: routing, tab building, iframe
   loading, theme switching, CI/coverage panels, and the landing CI table.

   CONFIGURATION CONSTANTS (injected by build_dashboard.py):
     PROJECTS, LANDING_TITLE, LAUNCH_PANEL_TYPES, LAUNCH_PANEL_URLS,
     DEFAULT_THEME, THEME_LABELS, WORKER_URL, MAX_RECENT_BRANCHES,
     PREFETCHED_CI_DATA, CI_OVERVIEW_PROJECTS
══════════════════════════════════════════════════════════════════════════ */

/* ── API URL helpers ─────────────────────────────────────────────────────
   When WORKER_URL is set, route all API calls through the Cloudflare
   Worker proxy (authenticated, 5 000 req/hr). Otherwise fall back to
   direct unauthenticated calls (60 req/hr).                              */

function ghApiUrl(path) {
  if (WORKER_URL) return WORKER_URL + '/github' + path;
  return 'https://api.github.com' + path;
}

function ccApiUrl(path) {
  if (WORKER_URL) return WORKER_URL + '/codecov' + path;
  return 'https://api.codecov.io' + path;
}

/* ── SVG icons for each category type ────────────────────────────────── */
const ICONS = {
  report: `<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
             <polyline points="22,12 18,12 15,21 9,3 6,12 2,12"/>
           </svg>`,
  bench:  `<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
             <line x1="18" y1="20" x2="18" y2="10"/>
             <line x1="12" y1="20" x2="12" y2="4"/>
             <line x1="6" y1="20" x2="6" y2="14"/>
           </svg>`,
  docs:   `<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
             <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/>
             <polyline points="14,2 14,8 20,8"/>
             <line x1="16" y1="13" x2="8" y2="13"/>
             <line x1="16" y1="17" x2="8" y2="17"/>
           </svg>`,
  repo:   `<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
             <path d="M9 19c-5 1.5-5-2.5-7-3m14 6v-3.87a3.37 3.37 0 0 0-.94-2.61
                      c3.14-.35 6.44-1.54 6.44-7A5.44 5.44 0 0 0 20 4.77
                      5.07 5.07 0 0 0 19.91 1S18.73.65 16 2.48a13.38 13.38 0 0 0-7 0
                      C6.27.65 5.09 1 5.09 1A5.07 5.07 0 0 0 5 4.77
                      a5.44 5.44 0 0 0-1.5 3.78c0 5.42 3.3 6.61 6.44 7
                      A3.37 3.37 0 0 0 9 18.13V22"/>
           </svg>`,
  coverage: `<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
               <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/>
               <polyline points="9,12 11,14 15,10"/>
             </svg>`,
  custom: `<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
             <circle cx="12" cy="12" r="3"/>
             <path d="M19.07 4.93a10 10 0 0 1 0 14.14M4.93 4.93a10 10 0 0 0 0 14.14"/>
           </svg>`,
  ci: `<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
         <circle cx="12" cy="12" r="3"/>
         <path d="M19.4 15a1.65 1.65 0 0 0 .33 1.82l.06.06a2 2 0 0 1-2.83 2.83l-.06-.06
                  a1.65 1.65 0 0 0-1.82-.33 1.65 1.65 0 0 0-1 1.51V21a2 2 0 0 1-4 0v-.09
                  A1.65 1.65 0 0 0 9 19.4a1.65 1.65 0 0 0-1.82.33l-.06.06a2 2 0 0 1-2.83-2.83
                  l.06-.06A1.65 1.65 0 0 0 4.68 15a1.65 1.65 0 0 0-1.51-1H3a2 2 0 0 1 0-4h.09
                  A1.65 1.65 0 0 0 4.6 9a1.65 1.65 0 0 0-.33-1.82l-.06-.06a2 2 0 0 1 2.83-2.83
                  l.06.06A1.65 1.65 0 0 0 9 4.68a1.65 1.65 0 0 0 1-1.51V3a2 2 0 0 1 4 0v.09
                  a1.65 1.65 0 0 0 1 1.51 1.65 1.65 0 0 0 1.82-.33l.06-.06a2 2 0 0 1 2.83 2.83
                  l-.06.06A1.65 1.65 0 0 0 19.4 9a1.65 1.65 0 0 0 1.51 1H21a2 2 0 0 1 0 4h-.09
                  a1.65 1.65 0 0 0-1.51 1z"/>
       </svg>`,
};

const TYPE_COLORS = {
  report:   '#4ade80',
  bench:    '#60a5fa',
  docs:     '#c084fc',
  repo:     '#fb923c',
  coverage: '#fbbf24',
  custom:   '#f87171',
  ci:       '#38bdf8',
};

const LAUNCH_REASONS = {
  repo:    'Git hosting services like GitHub and GitLab block embedding for security reasons.',
  docs:    'This documentation site does not allow embedding in other pages.',
  default: 'This page cannot be embedded due to security restrictions set by the host.',
};

let activeProject  = null;
let activeCategory = null;

/* ══════════════════════════════════════════════════════════════════════════
   LANDING PAGE — CI OVERVIEW TABLE
══════════════════════════════════════════════════════════════════════════ */

function applyLandingTitle() {
  document.getElementById('hero-title').innerHTML = LANDING_TITLE;
}

const CI_CONCLUSION_MAP = {
  success:   ['#4ade80', 'passing'],
  failure:   ['#f87171', 'failing'],
  cancelled: ['#fbbf24', 'cancelled'],
  timed_out: ['#f87171', 'timed out'],
  skipped:   ['#7a8ba8', 'skipped'],
};

async function fetchRecentBranches(owner, repo) {
  try {
    const r = await fetch(
      ghApiUrl(`/repos/${owner}/${repo}/actions/runs?per_page=30`),
      { headers: { 'Accept': 'application/vnd.github+json' } }
    );
    if (!r.ok) return [];
    const data = await r.json();
    const seen     = new Set();
    const branches = [];
    for (const run of (data.workflow_runs || [])) {
      const b = run.head_branch;
      if (b && b !== 'main' && !seen.has(b)) {
        seen.add(b);
        branches.push(b);
        if (branches.length >= MAX_RECENT_BRANCHES) break;
      }
    }
    return branches;
  } catch {
    return [];
  }
}

function fetchWorkflowRow(owner, repo, file, branch, dotEl, statusEl, branchEl, timeEl) {
  branchEl.textContent     = branch;
  dotEl.style.background   = 'var(--border)';
  statusEl.textContent     = 'Fetching\u2026';
  statusEl.style.color     = '';
  timeEl.textContent       = '';

  fetch(
    ghApiUrl(`/repos/${owner}/${repo}/actions/workflows/${file}/runs` +
    `?branch=${encodeURIComponent(branch)}&per_page=1`),
    { headers: { 'Accept': 'application/vnd.github+json' } }
  )
    .then(r => { if (!r.ok) throw new Error('HTTP ' + r.status); return r.json(); })
    .then(data => {
      const run = (data.workflow_runs || [])[0];
      if (run) {
        const [color, label] = CI_CONCLUSION_MAP[run.conclusion]
          || ['#7a8ba8', run.conclusion || run.status || 'unknown'];
        dotEl.style.background = color;
        statusEl.textContent   = label;
        statusEl.style.color   = color;
        timeEl.textContent     = relTime(new Date(run.updated_at));
      } else {
        statusEl.textContent = 'no runs found';
      }
    })
    .catch(err => {
      dotEl.style.background = 'var(--border)';
      statusEl.textContent   = 'unavailable (' + err.message + ')';
    });
}

function refreshProjectRows(tbody, owner, repo, projId, workflows, branch) {
  workflows.forEach(wf => {
    const row = tbody.querySelector(`tr[data-proj="${projId}"][data-wf="${wf.file}"]`);
    if (!row) return;
    const dotEl    = row.querySelector('.ci-ov-dot');
    const statusEl = row.querySelector('.ci-ov-status');
    const branchEl = row.querySelector('.ci-ov-branch');
    const timeEl   = row.querySelector('.ci-ov-time');
    fetchWorkflowRow(owner, repo, wf.file, branch, dotEl, statusEl, branchEl, timeEl);
  });
}

function resizeBranchSelect(sel) {
  const tmp = document.createElement('span');
  tmp.style.cssText =
    'visibility:hidden;position:fixed;white-space:nowrap;' +
    'font-family:monospace;font-size:11px;padding:0 22px 0 8px;';
  tmp.textContent = sel.options[sel.selectedIndex]?.text || 'main';
  document.body.appendChild(tmp);
  sel.style.width = (tmp.offsetWidth + 2) + 'px';
  document.body.removeChild(tmp);
}

function buildCIOverview(forceLive) {
  const projects = CI_OVERVIEW_PROJECTS;
  const usePrebaked = PREFETCHED_CI_DATA && !forceLive;

  const statusBar = document.getElementById('ci-data-status');
  if (usePrebaked) {
    const age = relTime(new Date(PREFETCHED_CI_DATA.baked_at));
    statusBar.innerHTML =
      'Snapshot from ' + age +
      '&ensp;<a href="#" class="ci-refresh-link" ' +
      'onclick="buildCIOverview(true);return false;">&#x21BA; Refresh</a>';
  } else {
    statusBar.textContent = 'Live data';
  }

  const container = document.getElementById('ci-overview');
  container.innerHTML = '';

  const extSvg =
    `<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" ` +
    `style="width:11px;height:11px;flex-shrink:0">` +
    `<path d="M18 13v6a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h6"/>` +
    `<polyline points="15,3 21,3 21,9"/>` +
    `<line x1="10" y1="14" x2="21" y2="3"/>` +
    `</svg>`;

  const table = document.createElement('table');
  table.className = 'ci-ov-table';

  const thead = document.createElement('thead');
  thead.innerHTML =
    `<tr>` +
    `<th style="width:28px"></th>` +
    `<th>CI Job Description</th>` +
    `<th style="width:110px">Branch</th>` +
    `<th style="width:110px">Status</th>` +
    `<th style="width:120px">Last Run</th>` +
    `</tr>`;
  table.appendChild(thead);

  const tbody = document.createElement('tbody');

  projects.forEach(cfg => {
    const proj  = PROJECTS.find(p => p.id.trim() === cfg.id);
    if (!proj) return;
    const ciCat = proj.categories.find(c => c.type === 'ci');
    if (!ciCat || !ciCat.github) return;
    const { owner, repo } = ciCat.github;
    const actionsUrl      = ciCat.url;

    const projBaked = usePrebaked ? (PREFETCHED_CI_DATA.projects || {})[cfg.id] : null;

    const projRow  = document.createElement('tr');
    projRow.className = 'ci-ov-proj-row';
    const projCell = document.createElement('td');
    projCell.colSpan = 5;

    const inner = document.createElement('div');
    inner.className = 'ci-ov-proj-inner';

    const nameSpan       = document.createElement('span');
    nameSpan.className   = 'ci-ov-proj-name';
    nameSpan.textContent = proj.name;
    inner.appendChild(nameSpan);

    let selectEl = null;
    if (!cfg.fixedBranch) {
      selectEl = document.createElement('select');
      selectEl.className = 'ci-ov-branch-select';
      selectEl.title     = 'Select branch';

      const mainOpt       = document.createElement('option');
      mainOpt.value       = 'main';
      mainOpt.textContent = 'main';
      selectEl.appendChild(mainOpt);

      requestAnimationFrame(() => resizeBranchSelect(selectEl));

      if (projBaked && projBaked.recent_branches && projBaked.recent_branches.length) {
        projBaked.recent_branches.forEach(b => {
          const opt       = document.createElement('option');
          opt.value       = b;
          opt.textContent = b;
          selectEl.appendChild(opt);
        });
        resizeBranchSelect(selectEl);
      } else {
        fetchRecentBranches(owner, repo).then(branches => {
          branches.forEach(b => {
            const opt       = document.createElement('option');
            opt.value       = b;
            opt.textContent = b;
            selectEl.appendChild(opt);
          });
          resizeBranchSelect(selectEl);
        });
      }

      selectEl.addEventListener('change', () => {
        resizeBranchSelect(selectEl);
        refreshProjectRows(tbody, owner, repo, cfg.id, cfg.workflows, selectEl.value);
      });

      inner.appendChild(selectEl);
    }

    const openLink     = document.createElement('a');
    openLink.className = 'ci-ov-open-link';
    openLink.href      = actionsUrl;
    openLink.target    = '_blank';
    openLink.rel       = 'noopener noreferrer';
    openLink.innerHTML = extSvg + '&nbsp;Open in GitHub';
    inner.appendChild(openLink);

    projCell.appendChild(inner);
    projRow.appendChild(projCell);
    tbody.appendChild(projRow);

    cfg.workflows.forEach(wf => {
      const row       = document.createElement('tr');
      row.className   = 'ci-ov-wf-row';
      row.dataset.proj = cfg.id;
      row.dataset.wf   = wf.file;

      const dotTd  = document.createElement('td');
      dotTd.className = 'ci-ov-dot-cell';
      const dot    = document.createElement('span');
      dot.className   = 'ci-ov-dot';
      dotTd.appendChild(dot);

      const labelTd       = document.createElement('td');
      labelTd.textContent = wf.label;

      const branchTd      = document.createElement('td');
      const branchSpan    = document.createElement('span');
      branchSpan.className   = 'ci-ov-branch';
      branchSpan.textContent = 'main';
      branchTd.appendChild(branchSpan);

      const statusTd      = document.createElement('td');
      const statusSpan    = document.createElement('span');
      statusSpan.className   = 'ci-ov-status';
      statusTd.appendChild(statusSpan);

      const timeTd     = document.createElement('td');
      const timeSpan   = document.createElement('span');
      timeSpan.className = 'ci-ov-time';
      timeTd.appendChild(timeSpan);

      row.appendChild(dotTd);
      row.appendChild(labelTd);
      row.appendChild(branchTd);
      row.appendChild(statusTd);
      row.appendChild(timeTd);
      tbody.appendChild(row);

      const wfBaked = projBaked ? (projBaked.workflows || {})[wf.file] : null;
      if (wfBaked) {
        const [color, label] = CI_CONCLUSION_MAP[wfBaked.conclusion]
          || ['#7a8ba8', wfBaked.conclusion || 'unknown'];
        dot.style.background   = color;
        statusSpan.textContent = label;
        statusSpan.style.color = color;
        branchSpan.textContent = 'main';
        timeSpan.textContent   = relTime(new Date(wfBaked.updated_at));
      } else {
        statusSpan.textContent = 'Fetching\u2026';
        fetchWorkflowRow(owner, repo, wf.file, 'main', dot, statusSpan, branchSpan, timeSpan);
      }
    });
  });

  table.appendChild(tbody);
  container.appendChild(table);
}

/* ══════════════════════════════════════════════════════════════════════════
   NAVIGATION
══════════════════════════════════════════════════════════════════════════ */

function goHome() {
  history.replaceState(null, '', window.location.pathname);
  activeProject  = null;
  activeCategory = null;
  document.getElementById('loader').classList.add('hidden');
  document.querySelectorAll('.proj-tab').forEach(t => t.classList.remove('active'));
  document.getElementById('cat-label').textContent = '\u2014';
  document.getElementById('cat-tabs').innerHTML    = '';
  document.getElementById('catbar').classList.add('empty');
  showPanel('landing');
}

/* ══════════════════════════════════════════════════════════════════════════
   PANEL VISIBILITY
══════════════════════════════════════════════════════════════════════════ */

function showPanel(name) {
  document.getElementById('landing').style.display          = 'none';
  document.getElementById('main-frame').style.display       = 'none';
  document.getElementById('launch-panel').style.display     = 'none';
  document.getElementById('coverage-panel').style.display   = 'none';
  document.getElementById('ci-panel').style.display         = 'none';

  if (name === 'landing') {
    document.getElementById('landing').style.display = 'flex';
  } else if (name === 'frame') {
    document.getElementById('main-frame').style.display = 'block';
  } else if (name === 'launch-panel') {
    document.getElementById('launch-panel').style.display = 'flex';
  } else if (name === 'coverage-panel') {
    document.getElementById('coverage-panel').style.display = 'flex';
  } else if (name === 'ci-panel') {
    document.getElementById('ci-panel').style.display = 'flex';
  }
}

/* ══════════════════════════════════════════════════════════════════════════
   THEME SWITCHER
══════════════════════════════════════════════════════════════════════════ */

function setTheme(name) {
  document.documentElement.dataset.theme = name;
  localStorage.setItem('dashboard-theme', name);
  document.getElementById('theme-label').textContent = THEME_LABELS[name] || name;
  document.querySelectorAll('.theme-option').forEach(el => {
    el.classList.toggle('active', el.dataset.theme === name);
  });
  document.getElementById('theme-menu').classList.remove('open');
}

function toggleThemeMenu() {
  const menu   = document.getElementById('theme-menu');
  const btn    = document.getElementById('theme-btn');
  const rect   = btn.getBoundingClientRect();
  const isOpen = menu.classList.contains('open');
  menu.classList.toggle('open');
  if (!isOpen) {
    menu.style.top   = (rect.bottom + 4) + 'px';
    menu.style.right = (window.innerWidth - rect.right) + 'px';
    menu.style.left  = 'auto';
  }
}

document.addEventListener('click', e => {
  const btn  = document.getElementById('theme-btn');
  const menu = document.getElementById('theme-menu');
  if (!btn.contains(e.target) && !menu.contains(e.target)) {
    menu.classList.remove('open');
  }
});

function initTheme() {
  setTheme(localStorage.getItem('dashboard-theme') || DEFAULT_THEME);
}

/* ══════════════════════════════════════════════════════════════════════════
   PROJECT & CATEGORY TAB BUILDING
══════════════════════════════════════════════════════════════════════════ */

function buildProjectTabs() {
  const projTabs = document.getElementById('proj-tabs');
  projTabs.innerHTML = '';
  PROJECTS.forEach(p => {
    const t = document.createElement('div');
    t.className      = 'proj-tab';
    t.dataset.id     = p.id;
    t.textContent    = p.name;
    t.title          = `Open ${p.name} project`;
    t.addEventListener('click', () => selectProject(p.id));
    projTabs.appendChild(t);
  });
}

function selectProject(projId, catId) {
  const p = PROJECTS.find(x => x.id === projId);
  if (!p) return;
  activeProject = p;

  document.querySelectorAll('.proj-tab').forEach(t => {
    t.classList.toggle('active', t.dataset.id === projId);
  });

  const catTabs  = document.getElementById('cat-tabs');
  const catLabel = document.getElementById('cat-label');
  catTabs.innerHTML    = '';
  catLabel.textContent = p.name;
  document.getElementById('catbar').classList.remove('empty');

  p.categories.forEach(cat => {
    const iconHtml = (ICONS[cat.type] || ICONS.custom)
                       .replace('<svg ', '<svg class="cat-icon" ');
    const t = document.createElement('div');
    t.className    = 'cat-tab';
    t.dataset.id   = cat.id;
    t.dataset.type = cat.type;

    let labelHtml;
    if (cat.type === 'repo') {
      labelHtml =
        `<a href="${cat.url}" target="_blank" rel="noopener noreferrer" ` +
        `class="cat-repo-link" title="Open in a new tab">` +
        `${cat.label}<span class="cat-repo-external" aria-hidden="true">&#x2197;</span></a>`;
      t.title = 'Open repository in a new tab';
    } else {
      labelHtml = cat.label;
      t.title   = cat.label;
    }

    t.innerHTML = iconHtml + labelHtml;
    t.addEventListener('click', (event) => {
      if (cat.type === 'repo') {
        event.preventDefault();
      }
      selectCategory(projId, cat.id);
    });
    catTabs.appendChild(t);
  });

  const defaultCat = catId || p.categories[0]?.id;
  if (defaultCat) selectCategory(projId, defaultCat);
}

function selectCategory(projId, catId) {
  const p   = PROJECTS.find(x => x.id === projId);
  const cat = p?.categories.find(c => c.id === catId);
  if (!p || !cat) return;
  activeCategory = cat;

  document.querySelectorAll('.cat-tab').forEach(t => {
    t.classList.toggle('active', t.dataset.id === catId);
  });

  history.replaceState(null, '', `#${projId}/${catId}`);

  if (cat.type === 'ci') {
    showCIPanel(cat);
  } else if (cat.type === 'coverage') {
    showCoveragePanel(cat);
  } else if (cat.type === 'repo') {
    if (cat.url) {
      const win = window.open(cat.url, '_blank');
      if (win) win.opener = null;
    }
  } else if (shouldUseLaunchPanel(cat)) {
    showLaunchPanel(cat);
  } else {
    loadUrl(cat.url);
  }
}

/* ══════════════════════════════════════════════════════════════════════════
   EMBEDDABILITY CHECK
══════════════════════════════════════════════════════════════════════════ */

function shouldUseLaunchPanel(cat) {
  if (LAUNCH_PANEL_TYPES.includes(cat.type)) return true;
  try {
    const host = new URL(cat.url).hostname;
    return LAUNCH_PANEL_URLS.some(h => host === h || host.endsWith('.' + h));
  } catch (e) {
    return false;
  }
}

/* ══════════════════════════════════════════════════════════════════════════
   LAUNCH PANEL
══════════════════════════════════════════════════════════════════════════ */

function showLaunchPanel(cat) {
  document.getElementById('loader').classList.add('hidden');
  showPanel('launch-panel');

  const color  = TYPE_COLORS[cat.type] || TYPE_COLORS.custom;
  const icon   = (ICONS[cat.type] || ICONS.custom);
  const reason = LAUNCH_REASONS[cat.type] || LAUNCH_REASONS.default;

  document.getElementById('launch-icon').innerHTML =
    icon.replace('<svg ', `<svg width="28" height="28" stroke="${color}" `);

  document.getElementById('launch-title').textContent  = cat.label;
  document.getElementById('launch-url').textContent    = cat.url;
  document.getElementById('launch-reason').textContent = reason;
  document.getElementById('launch-btn').href           = cat.url;
  document.getElementById('launch-note').textContent   = 'Opens in a new tab';
}

/* ══════════════════════════════════════════════════════════════════════════
   COVERAGE PANEL
══════════════════════════════════════════════════════════════════════════ */

function showCoveragePanel(cat) {
  document.getElementById('loader').classList.add('hidden');
  showPanel('coverage-panel');

  const pctEl = document.getElementById('cov-pct');
  pctEl.innerHTML = '&nbsp;';
  pctEl.style.color = '';
  pctEl.style.minWidth  = '52px';
  pctEl.style.minHeight = '26px';
  pctEl.classList.add('shimmer');
  document.getElementById('cov-circle').style.borderColor = '';

  ['cov-name', 'cov-branch', 'cov-updated'].forEach(id => {
    const el = document.getElementById(id);
    el.innerHTML = '&nbsp;';
    el.classList.add('shimmer');
  });
  ['cov-lines', 'cov-hits', 'cov-misses', 'cov-parts'].forEach(id => {
    document.getElementById(id).textContent = '\u2014';
  });

  document.getElementById('cov-ci-dot').style.background = 'var(--border)';
  document.getElementById('cov-ci-text').textContent     = 'Fetching CI status\u2026';
  document.getElementById('cov-ci-time').textContent     = '';
  document.getElementById('cov-ci').style.display        = '';
  document.getElementById('cov-error').style.display     = 'none';
  document.getElementById('cov-open').href               = cat.url;

  if (cat.codecov) {
    const cc = cat.codecov;
    const apiUrl = ccApiUrl(`/api/v2/${cc.service}/${cc.owner}/repos/${cc.repo}/`);

    fetch(apiUrl)
      .then(r => { if (!r.ok) throw new Error('HTTP ' + r.status); return r.json(); })
      .then(data => {
        const totals = data.totals;
        if (totals) {
          const pct   = parseFloat(totals.coverage);
          const color = pct >= 80 ? '#4ade80' : pct >= 60 ? '#fbbf24' : '#f87171';
          pctEl.textContent     = isNaN(pct) ? '\u2014' : pct.toFixed(1) + '%';
          pctEl.style.color     = color;
          pctEl.style.minWidth  = '';
          pctEl.style.minHeight = '';
          pctEl.classList.remove('shimmer');
          document.getElementById('cov-circle').style.borderColor = color;

          document.getElementById('cov-lines').textContent  = totals.lines    != null ? totals.lines    : '\u2014';
          document.getElementById('cov-hits').textContent   = totals.hits     != null ? totals.hits     : '\u2014';
          document.getElementById('cov-misses').textContent = totals.misses   != null ? totals.misses   : '\u2014';
          document.getElementById('cov-parts').textContent  = totals.partials != null ? totals.partials : '\u2014';
        }

        clearShimmer('cov-name',    cc.owner + ' / ' + cc.repo);
        clearShimmer('cov-branch',  'branch: ' + (data.branch || 'main'));
        clearShimmer('cov-updated', data.updatestamp
          ? 'Updated ' + relTime(new Date(data.updatestamp)) : '');
      })
      .catch(err => {
        pctEl.textContent     = '\u2014';
        pctEl.style.minWidth  = '';
        pctEl.style.minHeight = '';
        pctEl.classList.remove('shimmer');
        clearShimmer('cov-name',    cc.owner + ' / ' + cc.repo);
        clearShimmer('cov-branch',  '');
        clearShimmer('cov-updated', '');
        const errEl = document.getElementById('cov-error');
        errEl.style.display = 'block';
        errEl.textContent   = 'Could not load Codecov data (' + err.message + '). Use the button below to view directly.';
      });
  }

  if (cat.github) {
    const gh = cat.github;
    fetch(ghApiUrl(`/repos/${gh.owner}/${gh.repo}/actions/runs?per_page=5`),
          { headers: { 'Accept': 'application/vnd.github+json' } })
      .then(r => { if (!r.ok) throw new Error('HTTP ' + r.status); return r.json(); })
      .then(data => {
        const runs = data.workflow_runs || [];
        const run  = runs.find(r => r.status === 'completed') || runs[0];
        if (run) {
          const [color, label] = CI_CONCLUSION_MAP[run.conclusion] || ['#7a8ba8', run.conclusion || run.status || 'unknown'];
          document.getElementById('cov-ci-dot').style.background = color;
          document.getElementById('cov-ci-text').textContent = 'CI: ' + (run.name || 'Workflow') + ' \u2014 ' + label;
          document.getElementById('cov-ci-time').textContent = relTime(new Date(run.updated_at));
        } else {
          document.getElementById('cov-ci-text').textContent = 'No CI runs found';
        }
      })
      .catch(() => {
        document.getElementById('cov-ci-dot').style.background = 'var(--border)';
        document.getElementById('cov-ci-text').textContent = 'CI status unavailable';
      });
  } else {
    document.getElementById('cov-ci').style.display = 'none';
  }
}

function clearShimmer(id, text) {
  const el = document.getElementById(id);
  el.classList.remove('shimmer');
  el.style.minWidth  = '';
  el.style.minHeight = '';
  el.textContent = text;
}

function relTime(date) {
  if (!date || isNaN(date)) return '?';
  const s = Math.floor((Date.now() - date) / 1000);
  if (s < 60)    return s + 's ago';
  if (s < 3600)  return Math.floor(s / 60) + 'm ago';
  if (s < 86400) return Math.floor(s / 3600) + 'h ago';
  return Math.floor(s / 86400) + 'd ago';
}

/* ══════════════════════════════════════════════════════════════════════════
   IFRAME LOADER
══════════════════════════════════════════════════════════════════════════ */

function loadUrl(url) {
  const frame  = document.getElementById('main-frame');
  const loader = document.getElementById('loader');

  showPanel(null);
  loader.classList.remove('hidden');

  frame.onload = () => {
    loader.classList.add('hidden');
    showPanel('frame');
    setTimeout(() => {
      try {
        const doc = frame.contentDocument;
        if (doc && doc.body && doc.body.innerHTML.trim() === '') {
          showLaunchPanel(activeCategory);
        }
      } catch (e) {
        /* Cross-origin security error — iframe loaded fine */
      }
    }, 600);
  };

  frame.src = url;
}

function openFull() {
  if (activeCategory) {
    const win = window.open(activeCategory.url, '_blank');
    if (win) win.opener = null;
  }
}

/* ══════════════════════════════════════════════════════════════════════════
   URL HASH ROUTING
══════════════════════════════════════════════════════════════════════════ */

function loadFromHash() {
  const hash = location.hash.slice(1);
  if (!hash) {
    showPanel('landing');
    return;
  }
  const [projId, catId] = hash.split('/');
  if (projId) {
    selectProject(projId, catId || undefined);
  } else {
    showPanel('landing');
  }
}

/* ══════════════════════════════════════════════════════════════════════════
   CI PANEL
══════════════════════════════════════════════════════════════════════════ */

function showCIPanel(cat) {
  document.getElementById('loader').classList.add('hidden');
  showPanel('ci-panel');

  if (!cat.github) return;
  const { owner, repo } = cat.github;

  const nameEl  = document.getElementById('ci-repo-name');
  const rowsEl  = document.getElementById('ci-rows');
  const openEl  = document.getElementById('ci-open');

  nameEl.textContent = owner + ' / ' + repo;
  openEl.href        = `https://github.com/${owner}/${repo}/actions`;

  rowsEl.innerHTML =
    `<div class="ci-row">
       <div class="ci-dot"></div>
       <div class="ci-label shimmer" style="min-width:220px;min-height:13px">&nbsp;</div>
       <div class="ci-branch shimmer" style="min-width:80px;min-height:13px">&nbsp;</div>
       <div class="ci-status shimmer" style="min-width:60px;min-height:13px">&nbsp;</div>
     </div>`;

  const workflows = cat.workflows || [];
  if (workflows.length === 0) {
    rowsEl.innerHTML =
      '<div class="ci-row"><div class="ci-label">No workflows configured</div></div>';
    return;
  }

  rowsEl.innerHTML = '';
  workflows.forEach(wf => {
    const row = document.createElement('div');
    row.className = 'ci-row';
    row.innerHTML =
      `<div class="ci-dot"></div>
       <div class="ci-label">${wf.label}</div>
       <div class="ci-branch">\u2014</div>
       <div class="ci-status">Fetching&#8230;</div>
       <div class="ci-time"></div>`;
    rowsEl.appendChild(row);

    const dot    = row.querySelector('.ci-dot');
    const branch = row.querySelector('.ci-branch');
    const status = row.querySelector('.ci-status');
    const time   = row.querySelector('.ci-time');

    fetch(
      ghApiUrl(`/repos/${owner}/${repo}/actions/workflows/${wf.file}/runs?per_page=1`),
      { headers: { 'Accept': 'application/vnd.github+json' } }
    )
      .then(r => { if (!r.ok) throw new Error('HTTP ' + r.status); return r.json(); })
      .then(data => {
        const run = (data.workflow_runs || [])[0];
        if (run) {
          const [color, label] = CI_CONCLUSION_MAP[run.conclusion]
            || ['#7a8ba8', run.conclusion || run.status || 'unknown'];
          dot.style.background = color;
          branch.textContent   = run.head_branch || '\u2014';
          status.textContent   = label;
          status.style.color   = color;
          time.textContent     = relTime(new Date(run.updated_at));
        } else {
          branch.textContent = '\u2014';
          status.textContent = 'no runs found';
        }
      })
      .catch(err => {
        dot.style.background = 'var(--border)';
        branch.textContent   = '\u2014';
        status.textContent   = 'unavailable (' + err.message + ')';
      });
  });
}

/* ══════════════════════════════════════════════════════════════════════════
   INITIALISATION
══════════════════════════════════════════════════════════════════════════ */

(function init() {
  initTheme();
  applyLandingTitle();
  buildProjectTabs();
  buildCIOverview();
  loadFromHash();
})();
