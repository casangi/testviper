# VIPER Ecosystem Dashboard

Technical documentation for the config-driven, template-built dashboard.

Related documents:
- [DASHBOARD-PRD.md](DASHBOARD-PRD.md) — Product requirements document
- [projects.yaml](../config/projects.yaml) — Single source of truth for all config

---

## Architecture Overview

The dashboard is a **single static HTML file** assembled from modular source files
by a Python build script. All API calls in live mode go through a **Cloudflare
Worker proxy** for authenticated access (5,000 req/hr instead of 60).

```
Source files                Build step              Output
─────────────────────      ───────────────────      ────────────────────────
ci/config/projects.yaml    scripts/                 ci/html/dashboard.html
ci/templates/base.html  →  build_dashboard.py  →    (single file, deployed
ci/static/style.css         + optional bake          to gh-pages)
ci/static/app.js
```

### Data flow

```
┌─────────────────────┐     ┌──────────────────────┐
│  GitHub Pages       │     │  Cloudflare Worker    │
│  dashboard.html     │────▶│  (authenticated)      │
│  (baked + live)     │     │  workers.dev proxy    │
└─────────────────────┘     └──────────┬───────────┘
                                       │
                            ┌──────────▼───────────┐
                            │  GitHub API           │
                            │  Codecov API          │
                            └──────────────────────┘
```

**Pre-baked mode**: Landing page CI data is embedded in the HTML at build time
(zero browser API calls on initial load).

**Live mode**: Branch switching, Refresh, project CI panels, and coverage panels
fetch data at runtime through the Cloudflare Worker proxy.

---

## File Structure

```
ci/
  config/
    projects.yaml           ← single source of truth (edit this)
  templates/
    base.html               ← Jinja2 HTML template
  static/
    style.css               ← all CSS (themes, layout, panels)
    app.js                  ← all JS (routing, API calls, panels)
  html/
    dashboard.html          ← BUILD OUTPUT (do not hand-edit)
    worker.js               ← Cloudflare Worker proxy source
    dashboard-live-index.html  ← legacy monolith (kept for reference)
scripts/
  build_dashboard.py        ← build + bake script
  bake_dashboard.py         ← legacy bake script (kept for reference)
  tests/
    test_build_dashboard.py ← automated test suite (48 tests)
.github/
  workflows/
    bake-dashboard.yml      ← CI workflow (triggers build + deploy)
```

---

## Technical Reference

### Rendering modes

- **Mode A — Pre-baked snapshot**
  - Condition: `PREFETCHED_CI_DATA` is non-null and no force-live refresh is requested.
  - Landing CI overview rows render from embedded JSON. No browser API calls on initial load.
- **Mode B — Live**
  - Condition: `PREFETCHED_CI_DATA` is null, or user triggers Refresh.
  - Landing CI overview rows are fetched at runtime via the Worker proxy.
- **Refresh rule**: Snapshot mode exposes a "Refresh" link that forces live fetching for the current session.

### API reference

All live-mode API calls are routed through the Cloudflare Worker proxy. The
Worker translates paths as follows:

- `/github/*` → `https://api.github.com/*` (authenticated with `GITHUB_TOKEN`)
- `/codecov/*` → `https://api.codecov.io/*` (public, no auth)

If `WORKER_URL` is empty, the dashboard falls back to direct unauthenticated
`api.github.com` calls (subject to 60 req/hr rate limit).

**GitHub Actions endpoints consumed:**

| Endpoint | Purpose |
|----------|---------|
| `GET /repos/{owner}/{repo}/actions/workflows/{file}/runs?branch={branch}&per_page=1` | Single workflow run status (branch-specific) |
| `GET /repos/{owner}/{repo}/actions/workflows/{file}/runs?per_page=1` | Workflow run status (any branch) |
| `GET /repos/{owner}/{repo}/actions/runs?per_page=30` | Recent branches discovery |
| `GET /repos/{owner}/{repo}/actions/runs?per_page=5` | Coverage CI row |

**Codecov endpoint consumed:**

| Endpoint | Purpose |
|----------|---------|
| `GET /api/v2/{service}/{owner}/repos/{repo}/` | Repository-level coverage totals |

**GitHub response fields consumed:**

`workflow_runs[].conclusion`, `workflow_runs[].status`, `workflow_runs[].updated_at`,
`workflow_runs[].head_branch`, `workflow_runs[].name`

**Codecov response fields consumed:**

`totals.coverage`, `totals.lines`, `totals.hits`, `totals.misses`, `totals.partials`,
`branch`, `updatestamp`

### Configuration schemas

Source of truth: `ci/config/projects.yaml`

The build script generates these JavaScript runtime constants from the YAML:

| Constant | Schema |
|----------|--------|
| `PROJECTS` | `[{ id, name, categories: [{ id, label, type, url, codecov?, github?, workflows? }] }]` |
| `CI_OVERVIEW_PROJECTS` | `[{ id, fixedBranch, workflows: [{ file, label }] }]` |
| `PREFETCHED_CI_DATA` | `{ baked_at, projects: { [projectId]: { recent_branches?, workflows: { [file]: { conclusion, updated_at } } } } }` |
| `WORKER_URL` | `string` (Cloudflare Worker URL or empty) |
| `MAX_RECENT_BRANCHES` | `number` (from `dashboard.max_recent_branches`) |
| `LANDING_TITLE` | `string` (HTML allowed) |
| `THEME_LABELS` | `{ [themeId]: displayLabel }` |
| `LAUNCH_PANEL_TYPES` | `string[]` |
| `LAUNCH_PANEL_URLS` | `string[]` |
| `DEFAULT_THEME` | `"dark" \| "light" \| "slate" \| "system"` |

### Routing and state persistence

- URL hash formats:
  - Empty hash → landing page
  - `#projectId` → project with default category
  - `#projectId/categoryId` → specific category
- Theme persistence:
  - Storage key: `dashboard-theme`
  - Supported values: `dark`, `light`, `slate`, `system`

### Panel behavior

Exactly one content panel is visible at a time:

| Panel | Trigger |
|-------|---------|
| `landing` | Brand click or empty hash |
| `ci-panel` | Category with `type: ci` |
| `coverage-panel` | Category with `type: coverage` |
| `frame` (iframe) | Embeddable category URL |
| `launch-panel` | Non-embeddable URL or type in `LAUNCH_PANEL_TYPES` |

Selecting `repo` opens a new tab; the center panel stays unchanged.

**CI panel (`ci-panel`)**: For each configured workflow, the app requests the latest
workflow run (`GET .../actions/workflows/{file}/runs?per_page=1`). Each row shows
the workflow label, **branch** (GitHub `head_branch` for that run — the branch the
job ran against), conclusion/status, and relative time. If there is no run or the
request fails, the branch cell shows an em dash.

### Error handling and fallback

- API failures never terminate the app. User-facing statuses include:
  - `unavailable (HTTP <code>)`
  - `unavailable (NetworkError ...)` — typically Worker unreachable
  - `no runs found`
  - `CI status unavailable`
  - Coverage load failure with direct-open option
- Branch discovery failure: branch selector stays usable with `main` only.
- Iframe fallback: if a loaded frame appears silently blank, the launch panel is shown.
- Worker unreachable: baked snapshot data renders normally; only live refresh and branch switching fail.

### Performance and rate limits

- Pre-baked mode avoids all browser CI API calls on initial load.
- Live landing mode request count is bounded by (projects × workflows) + branch discovery calls.
- With Worker: 5,000 authenticated GitHub req/hr per token.
- Without Worker: 60 unauthenticated req/hr per IP.
- Cloudflare free tier: 100,000 Worker requests/day.

### Security

- External links use `target="_blank"` with `rel="noopener noreferrer"`.
- Script-opened windows clear opener linkage.
- The launch panel is used for domains or types that cannot be safely embedded.
- The Worker proxy path whitelist prevents misuse as a general-purpose proxy.
- `GITHUB_TOKEN` is stored as encrypted secrets in Cloudflare and GitHub Actions, never exposed to the browser.

---

## Configuration (projects.yaml)

All dashboard settings live in `ci/config/projects.yaml`. This is the only file
you need to edit for routine maintenance.

### Dashboard settings

```yaml
dashboard:
  title: 'Dashboard for ...'       # HTML allowed; shown in hero card
  default_theme: light             # dark | light | slate | system
  worker_url: "https://..."        # Cloudflare Worker URL (empty = direct API)
  max_recent_branches: 4           # branches shown in landing dropdown
```

### Adding a project

Add a new entry under `projects:`:

```yaml
  - id: newproject                 # unique identifier (used in URL hash)
    name: New Project              # display name
    owner: casangi                 # GitHub org
    repo: newproject               # GitHub repo name
    fixed_branch: false            # false = show branch dropdown
    overview_workflows:            # shown on landing page CI table
      - { file: tests.yml, label: "Tests" }
    categories:                    # tabs shown when project is selected
      - id: ci
        label: CI
        type: ci
        url: "https://github.com/casangi/newproject/actions"
        workflows:                 # shown in CI panel (can differ from overview)
          - { file: tests.yml, label: "Unit Tests" }
          - { file: lint.yml,  label: "Linting" }
      - { id: report, label: Reports, type: report, url: "https://..." }
      - { id: repo,   label: Repo,    type: repo,   url: "https://github.com/casangi/newproject" }
```

### Adding a workflow to an existing project

Add the workflow to **both** places in the project entry:

1. `overview_workflows` — controls what appears on the landing page CI table
2. The CI category's `workflows` list — controls what appears in the project's CI panel

These can differ: `overview_workflows` is typically a smaller subset.

### Adding a category to an existing project

Append to the project's `categories:` list:

```yaml
      - { id: bench, label: Benchmarks, type: bench, url: "https://..." }
```

### Category types

| Type       | Behavior                                      | Accent color |
|------------|-----------------------------------------------|--------------|
| `ci`       | In-page CI panel with per-workflow status      | Sky blue     |
| `report`   | Embedded in iframe                             | Green        |
| `bench`    | Embedded in iframe                             | Blue         |
| `docs`     | Embedded in iframe                             | Purple       |
| `coverage` | In-page Codecov summary card                   | Yellow       |
| `repo`     | Opens in new tab (never embedded)              | Orange       |
| `custom`   | Embedded in iframe                             | Red          |

### Coverage category

Requires a `codecov` field:

```yaml
      - id: coverage
        label: Coverage
        type: coverage
        url: "https://app.codecov.io/gh/casangi/repo"
        codecov: { service: github, owner: casangi, repo: reponame }
```

---

## Building

### Prerequisites

- Python 3.10+
- `pip install jinja2 pyyaml`

### Build steps

The build script (`scripts/build_dashboard.py`) performs these steps:

1. Reads `ci/config/projects.yaml`
2. Reads `ci/static/style.css`, `ci/static/app.js`, `ci/templates/base.html`
3. If `GITHUB_TOKEN` is set, fetches CI data from GitHub API and builds `PREFETCHED_CI_DATA`
4. Generates JS config constants from YAML
5. Concatenates JS config + JS engine
6. Renders the Jinja2 template with CSS and JS injected inline
7. Writes the single output HTML file

Environment variables:

- `GITHUB_TOKEN` — optional; when set, bakes CI data into the output
- `DASHBOARD_OUT` — optional; output path (default: `ci/html/dashboard.html`)

### Local build (no baking)

```bash
python scripts/build_dashboard.py
open ci/html/dashboard.html
```

The output uses live mode — all CI data fetched at runtime through the Worker.

### Local build with baking

```bash
export GITHUB_TOKEN=ghp_your_token_here
python scripts/build_dashboard.py
```

The output includes a `PREFETCHED_CI_DATA` snapshot. Landing page CI table
renders instantly with zero API calls.

### CI build (automatic)

The workflow `.github/workflows/bake-dashboard.yml` runs automatically on:
- Push to `main`
- Repository dispatch (`integration-test-trigger` from other VIPER repos)
- Hourly cron schedule
- Manual trigger (workflow_dispatch)

It installs Python dependencies (`jinja2`, `pyyaml`), runs `build_dashboard.py`
with `GITHUB_TOKEN`, and deploys `ci/html/` to the `gh-pages` branch.

**Result URL**: `https://casangi.github.io/testviper/ci/dashboard.html`

---

## Cloudflare Worker Proxy

The Worker (`ci/html/worker.js`) proxies GitHub and Codecov API calls with
authentication, solving the 60 req/hr unauthenticated rate limit.

### Routes

| Route          | Upstream              | Auth           |
|----------------|-----------------------|----------------|
| `/github/*`    | `api.github.com`      | `GITHUB_TOKEN` |
| `/codecov/*`   | `api.codecov.io`      | None (public)  |
| All other paths | —                    | Returns 404    |

### Path whitelist

Only these patterns are forwarded (all others return 403):

- `/repos/casangi/*/actions/workflows/*/runs` — workflow run status
- `/repos/casangi/*/actions/runs` — branch discovery, coverage CI
- `/api/v2/github/casangi/repos/*/` — Codecov repository totals

The whitelist is scoped to `casangi` org repositories.

### Environment variables

| Variable | Required | Description |
|----------|----------|-------------|
| `GITHUB_TOKEN` | Yes | GitHub fine-grained PAT with public repo read access |
| `ALLOWED_ORIGIN` | No | CORS origin restriction; defaults to `*` |

CORS headers (`Access-Control-Allow-Origin`, etc.) are added to all responses.
GitHub rate-limit headers (`X-RateLimit-Remaining`, `X-RateLimit-Limit`,
`X-RateLimit-Reset`) are forwarded to the browser for transparency.

### Setup (one-time)

1. Sign up at [dash.cloudflare.com](https://dash.cloudflare.com) (free)
2. Create a Worker named `viper-dashboard-proxy`
3. Paste the contents of `ci/html/worker.js`
4. Add secret `GITHUB_TOKEN` (type: Secret) — a GitHub fine-grained PAT with
   Public Repositories read-only access
5. Deploy
6. Ensure the `workers.dev` route is enabled under Domains & Routes
7. Copy the Worker URL into `dashboard.worker_url` in `projects.yaml`

### Free tier limits

- Cloudflare Workers: 100,000 requests/day
- GitHub authenticated API: 5,000 requests/hour per token

### Deployment model

The Worker is deployed manually to Cloudflare — it is **not** part of the GitHub
Actions pipeline. Changes to `ci/html/worker.js` must be manually pasted into
the Cloudflare dashboard and redeployed.

### Token rotation

Fine-grained PATs expire (max 1 year). When rotating:
1. Generate a new PAT on GitHub
2. Update the `GITHUB_TOKEN` secret in Cloudflare Worker settings
3. Deploy

---

## Automated Tests

The test suite at `scripts/tests/test_build_dashboard.py` runs automatically in
the CI workflow **before deployment**, blocking any broken build from reaching
gh-pages.

### Running locally

```bash
pytest scripts/tests/test_build_dashboard.py -v
```

### What the tests cover (48 tests)

| Test class | What it validates |
|---|---|
| `TestSourceFiles` | All source files exist and are non-empty (`projects.yaml`, `base.html`, `style.css`, `app.js`, `worker.js`) |
| `TestConfigValidation` | YAML has required fields, no duplicate IDs, valid category types, CI categories have workflows, coverage categories have codecov config |
| `TestJsConfigGeneration` | All JS constants generated, project/overview arrays match YAML, Worker URL propagated, category type conversion (CI, coverage, repo) |
| `TestBuildOutput` | Output is valid HTML, CSS and JS inlined, all JS constants present, no unresolved Jinja2 `{{ }}`, key DOM elements exist, reasonable file size |
| `TestBakeDataStructure` | Baked data has correct structure (mocked API), every project/workflow present, branches exclude main, ISO-8601 timestamp, graceful failure handling |
| `TestApiHelpers` | `fetch_workflow_run` and `fetch_recent_branches` handle empty results, deduplication, and limits correctly |
| `TestConfigOutputConsistency` | Every project ID, workflow file, Worker URL, and theme label from YAML appears in the built HTML |

### CI workflow integration

The tests run as step 5 in `bake-dashboard.yml`, between build (step 4) and
deploy (step 6). If any test fails, the workflow stops and deployment is skipped.

---

## Manual Testing

### Local testing

```bash
# Install dependencies (once)
python3 -m pip install jinja2 pyyaml

# Build
python3 scripts/build_dashboard.py

# Serve locally (required — file:// won't work due to CORS)
cd ci/html
python3 -m http.server 8000

# Open in browser
# http://localhost:8000/dashboard.html
```

### What to verify

| Feature                  | How to test                                      | Expected result                |
|--------------------------|--------------------------------------------------|--------------------------------|
| Landing page             | Load the page                                    | Hero card + CI table visible   |
| Baked data               | Build with GITHUB_TOKEN, reload                  | "Snapshot from X ago" status   |
| Live refresh             | Click "Refresh" link on landing                  | Status changes to "Live data"  |
| Branch switching         | Select a non-main branch in dropdown             | Rows update with branch status |
| Project CI panel         | Click a project → CI tab                         | Per-workflow status, branch, and time load |
| Coverage panel           | Click a project → Coverage tab                   | Codecov data loads             |
| Reports iframe           | Click a project → Reports tab                    | Allure report loads in iframe  |
| Repo tab                 | Click a project → Repo tab                       | GitHub opens in new tab        |
| Launch panel             | Click a docs category with non-embeddable URL    | Launch panel with "Open" button|
| Theme switching          | Click theme button → select Dark/Light/Slate     | Colors change, persists reload |
| Hash routing             | Navigate to `#xradio/coverage`, reload           | Restores xradio coverage view  |
| Error handling           | Disconnect network, click Refresh                | "unavailable" shown, no crash  |

---

## Troubleshooting

### 1- "unavailable (NetworkError ...)" on all live fetches

**Cause**: The Cloudflare Worker is unreachable from your network.

**Fixes**:
- Check if you are behind a VPN/firewall that blocks `*.workers.dev`
- Disconnect VPN and retry
- Test the Worker URL directly in the browser:
  `https://<worker>.workers.dev/github/repos/casangi/testviper/actions/runs?per_page=1`
- Verify the `workers.dev` route is enabled in Cloudflare dashboard
  (Workers & Pages → your worker → Settings → Domains & Routes)

### 2- "unavailable (HTTP 403)" on CI fetches

**Cause**: GitHub API rate limit exceeded.

**Fixes**:
- If using the Worker: check that `GITHUB_TOKEN` is set in Cloudflare secrets
- If hitting direct API (no Worker): the 60 req/hr limit is exhausted; wait or
  configure the Worker
- Check rate limit headers: visit the Worker URL directly and look at
  `X-RateLimit-Remaining` in the response headers

### 3- Landing page shows data but Refresh/branches fail

**Cause**: Baked data is embedded (works offline) but live fetches fail.

**Fixes**: Same as "NetworkError" above — the Worker or network is the issue.

### 4- Build fails with "No module named 'yaml'"

**Cause**: `pyyaml` is not installed for the Python version you are using.

**Fix**: `python3 -m pip install pyyaml jinja2`

If using a virtual environment or conda, activate it first.

### 5- Firefox shows SSL security error for Worker URL

**Cause**: Firefox cached an HSTS failure from an earlier attempt (often happens
when the Worker was first created and the SSL certificate hadn't propagated).

**Fixes**:
- Open Firefox History (Cmd+Shift+H), search `workers.dev`, right-click →
  "Forget About This Site"
- Or test in Safari/Chrome instead

### 6- Dashboard loads but CI table is empty

**Cause**: The `CI_OVERVIEW_PROJECTS` config may not match the `PROJECTS` list.

**Fix**: Ensure every project in `projects.yaml` has both `overview_workflows`
and a `ci` category with a `github` owner/repo.

### 7- Baked data is stale

**Cause**: The hourly cron workflow has not run, or it failed.

**Fixes**:
- Check workflow runs at
  `https://github.com/casangi/testviper/actions/workflows/bake-dashboard.yml`
- Trigger a manual run via the "Run workflow" button
- Click "Refresh" on the landing page to force live data

### 8- VPN / corporate firewall blocks the Worker

**Cause**: Organization firewalls may block `*.workers.dev` domains.

**Options**:
- Request a firewall exception for `*.workers.dev` from your network team
- Attach a custom domain to the Cloudflare Worker (e.g. `dashboard-api.your-domain.com`)
  which may not be blocked
- Deploy the proxy on a different platform whose domain isn't blocked
  (Vercel `*.vercel.app`, Netlify `*.netlify.app`)
- Rely on pre-baked data: the landing page CI snapshot works without any API calls;
  only live refresh and branch switching require the Worker

---

## Maintenance Checklist

| Task                            | When                     | What to do                                |
|---------------------------------|--------------------------|-------------------------------------------|
| Add/change a project            | As needed                | Edit `projects.yaml`, push to main        |
| Add/change a workflow           | As needed                | Edit `projects.yaml`, push to main        |
| Change dashboard styling        | As needed                | Edit `ci/static/style.css`, push to main  |
| Change dashboard behavior       | As needed                | Edit `ci/static/app.js`, push to main     |
| Change page structure           | As needed                | Edit `ci/templates/base.html`, push to main|
| Update Worker proxy code        | As needed                | Edit `ci/html/worker.js`, manually redeploy to Cloudflare |
| Rotate GitHub PAT               | Before expiry (max 1yr)  | New PAT → update Cloudflare Worker secret + redeploy |
| Verify bake workflow            | Monthly                  | Check workflow run history on GitHub       |
