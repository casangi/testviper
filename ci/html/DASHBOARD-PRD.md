# Product Requirements Document (PRD): VIPER Ecosystem Dashboard

## 1) Document Control

- Product: VIPER Ecosystem Dashboard
- Build output: `ci/html/dashboard.html` (generated — do not hand-edit)
- Source files:
  - `ci/config/projects.yaml` — configuration (single source of truth)
  - `ci/templates/base.html` — HTML template (Jinja2)
  - `ci/static/style.css` — stylesheet
  - `ci/static/app.js` — JavaScript engine
- Build script: `scripts/build_dashboard.py`
- Test suite: `scripts/tests/test_build_dashboard.py`
- API proxy: `ci/html/worker.js` (Cloudflare Worker)
- CI workflow: `.github/workflows/bake-dashboard.yml`
- Technical documentation: `ci/html/Dashboard-full-proxy-implementation.md`
- Legacy artifacts (reference only): `ci/html/dashboard-live-index.html`, `scripts/bake_dashboard.py`
- PRD status: Updated to reflect config-driven build + Worker proxy implementation

## 2) Product Summary

The VIPER Ecosystem Dashboard is a single-file web application that centralizes access to CI, reports, benchmarks, coverage, docs, and repositories for VIPER projects. It is built from modular source files (YAML config, Jinja2 template, CSS, JS) by a Python build script and deployed as a static file to GitHub Pages. It supports two CI data modes:

- Pre-baked snapshot mode (fast load, no browser CI API calls at initial render)
- Live mode (browser fetches through an authenticated Cloudflare Worker proxy)

The dashboard acts as both:

- A landing-level CI operations view across projects
- A project-level navigation surface for project assets and status panels

## 3) Problem Statement

VIPER project status is fragmented across multiple URLs and services (GitHub Actions, Codecov, docs, reports, benchmarks). Users need a single, low-friction dashboard that:

- Aggregates cross-project CI health quickly
- Provides consistent navigation to project artifacts
- Deploys as a static file on GitHub Pages
- Overcomes the unauthenticated GitHub API rate limit (60 req/hr) through an authenticated proxy

## 4) Goals and Non-Goals

### Goals

- Provide a unified, static-hosted dashboard for VIPER ecosystem observability.
- Show CI status at two levels:
  - Cross-project overview on landing page
  - Per-project detailed CI category panel
- Support fast initial rendering via CI-baked snapshot data.
- Preserve deep-linkable navigation via URL hash.
- Support multiple visual themes with persisted user preference.
- Provide authenticated GitHub API access through a Cloudflare Worker proxy (5,000 req/hr).
- Maintain a single source of truth for all configuration (`projects.yaml`).

### Non-Goals

- Real-time streaming/push updates.
- Per-user authentication or login within the dashboard UI.
- Server-side rendering or backend service ownership (beyond the stateless Worker proxy).
- Workflow auto-discovery at runtime (workflows are explicitly configured).

## 5) Users and Primary Use Cases

### Target users

- Maintainers of VIPER ecosystem repositories
- CI/release engineers and contributors
- Stakeholders who need quick status visibility

### Core use cases

- See latest CI state for all ecosystem projects on one screen.
- Switch a project to a recent non-main branch and inspect workflow status.
- Open project-specific artifacts (reports, bench, docs, repo) from one place.
- Inspect coverage and latest CI signal for a specific project.

## 6) Scope (Current Version Baseline)

### In scope

- Config-driven dashboard built from modular source files by a Python script.
- Single-file output (`dashboard.html`) with embedded CSS and JavaScript.
- Five configured projects (`testviper`, `xradio`, `astroviper`, `graphviper`, `toolviper`).
- Category types: `ci`, `report`, `bench`, `coverage`, `docs`, `repo`, `custom`.
- Landing CI overview table with per-project sections and workflow rows.
- Branch selector for projects configured with `fixed_branch: false`.
- Theme selector (`dark`, `light`, `slate`, `system`) persisted in `localStorage`.
- Hash-based routing (`#project`, `#project/category`).
- Non-embeddable URL handling via launch panel and direct external links.
- Cloudflare Worker proxy (`worker.js`) for authenticated GitHub and Codecov API access.
- Automated CI build and deploy via GitHub Actions (`bake-dashboard.yml`).

### Out of scope

- User accounts, role-based access control, personalization beyond theme.
- Historical trend analytics and custom alerting.
- Guaranteed SLA for external API availability/rate limits.

## 7) Product Experience Requirements

### 7.1 Information Architecture

- Top navigation:
  - Brand (returns to landing)
  - Project tabs
  - Theme switcher
- Secondary navigation:
  - Category bar for selected project
  - Open-in-new-tab control for active category URL
- Main content area (single visible panel at a time):
  - `landing`
  - `frame` (iframe)
  - `launch-panel`
  - `coverage-panel`
  - `ci-panel`

### 7.2 Landing Experience

- Landing hero title must be configurable via `dashboard.title` in `projects.yaml`.
- Landing must display CI data status text:
  - Snapshot mode: `Snapshot from <relative time> + Refresh link`
  - Live mode: `Live data`
- Landing must render CI overview table grouped by project.
- Each project section includes:
  - Project name
  - Optional branch dropdown
  - "Open in GitHub" external link
- Each workflow row includes:
  - Status dot
  - Job label
  - Branch value
  - Human-readable status
  - Relative run time

## 8) Functional Requirements

### FR-1: Project and Category Configuration

- Dashboard shall be driven by a `projects.yaml` configuration file.
- Each project shall define unique `id`, display `name`, GitHub `owner`/`repo`, `fixed_branch` flag, `overview_workflows`, and `categories`.
- Each category shall define `id`, `label`, `type`, `url`, with optional type-specific fields (`workflows`, `codecov`, `github`).
- The build script (`build_dashboard.py`) reads this YAML and generates the JavaScript runtime constants.

### FR-2: Category Routing Behavior

- Selecting category `ci` shall render the dedicated CI panel.
- Selecting category `coverage` shall render the dedicated coverage panel.
- Selecting category `repo` shall open URL in a new tab and keep center panel unchanged.
- For non-specialized categories:
  - If URL/type is non-embeddable, show launch panel.
  - Else load URL in iframe with loader.

### FR-3: Launch Panel

- Launch panel shall display icon, title, URL, reason, and open button.
- Launch panel shall be used when:
  - Category `type` is listed in `LAUNCH_PANEL_TYPES`, or
  - URL host matches/extends a host in `LAUNCH_PANEL_URLS`.

### FR-4: Landing CI Overview Data Modes

- Dashboard shall support dual-mode CI overview data:
  - Pre-baked: use `PREFETCHED_CI_DATA` + `CI_OVERVIEW_PROJECTS`
  - Live: use browser API calls (via Worker proxy) + `CI_OVERVIEW_PROJECTS`
- If pre-baked data is available and not force-refreshed:
  - Render row status/times from embedded JSON immediately.
  - Populate non-main branch options from baked recent branches.
- Refresh action shall force live mode re-fetch.

### FR-5: Branch Selection in CI Overview

- For projects with `fixed_branch: false`, branch selector shall:
  - Default to `main`
  - Include up to N recent non-main branches (configured by `max_recent_branches`)
- Changing branch shall re-fetch all workflow rows only for that project.

### FR-6: CI Category Panel

- For a `ci` category, dashboard shall call one endpoint per configured workflow file via the Worker proxy:
  - `GET /github/repos/{owner}/{repo}/actions/workflows/{file}/runs?per_page=1`
- Panel shall show per-workflow status and relative time.
- Empty workflow list shall render "No workflows configured."

### FR-7: Coverage Category Panel

- Coverage panel shall fetch merged totals via the Worker proxy from:
  - `GET /codecov/api/v2/{service}/{owner}/repos/{repo}/`
- Panel shall render:
  - Coverage percentage and color state
  - Lines/hits/misses/partials
  - Branch and updated time
- If `github` is configured, panel shall fetch latest CI row from:
  - `GET /github/repos/{owner}/{repo}/actions/runs?per_page=5`

### FR-8: URL and Navigation State

- Dashboard shall support hash state restoration on page load:
  - Empty hash -> landing
  - `#projectId` -> project default category
  - `#projectId/catId` -> specific category
- Selecting category shall update hash using `history.replaceState`.
- Brand click shall clear state and return to landing.

### FR-9: Theme Management

- Dashboard shall support `dark`, `light`, `slate`, and `system` themes.
- Selected theme shall persist in `localStorage` under `dashboard-theme`.
- Theme labels are configurable in `projects.yaml` under `themes`.
- Theme menu shall visually indicate active theme.

### FR-10: Loading and Error States

- Iframe routes shall show loader while loading.
- Dashboard shall attempt silent blank-frame detection and fallback to launch panel.
- API failures shall present user-visible fallback messages such as:
  - `unavailable (HTTP xxx)`
  - `Could not load Codecov data (...)`
  - `CI status unavailable`

### FR-11: Authenticated API Proxy

- All runtime GitHub and Codecov API calls shall be routed through a Cloudflare Worker proxy (`worker.js`).
- The Worker URL is configured in `projects.yaml` under `dashboard.worker_url`.
- The Worker provides:
  - Authenticated GitHub API access via a stored `GITHUB_TOKEN` (5,000 req/hr)
  - CORS headers for cross-origin browser requests
  - Path whitelisting to restrict forwarded requests
- If `worker_url` is empty, the dashboard falls back to direct unauthenticated API calls (60 req/hr).

## 9) Data Contracts and Configuration Contracts

### 9.1 Configuration file contract (`projects.yaml`)

`ci/config/projects.yaml` is the single source of truth. The build script reads it and generates all JavaScript runtime constants:

- `PROJECTS` — array of project objects with categories
- `CI_OVERVIEW_PROJECTS` — array of project overview workflow definitions
- `LANDING_TITLE` — hero card title HTML
- `LAUNCH_PANEL_TYPES` — category types that trigger the launch panel
- `LAUNCH_PANEL_URLS` — URL hosts that trigger the launch panel
- `DEFAULT_THEME` — initial theme
- `THEME_LABELS` — map of theme id to display label
- `WORKER_URL` — Cloudflare Worker proxy URL
- `PREFETCHED_CI_DATA` — baked CI snapshot (null when not baked)

### 9.2 Baked data contract

`PREFETCHED_CI_DATA` object format (generated by `build_dashboard.py` when `GITHUB_TOKEN` is set):

- `baked_at`: ISO-8601 UTC timestamp
- `projects[projectId].recent_branches`: optional list of recent branch names
- `projects[projectId].workflows[file].conclusion`
- `projects[projectId].workflows[file].updated_at`

### 9.3 Worker proxy contract (`worker.js`)

The Cloudflare Worker exposes two route prefixes:

- `/github/*` — proxied to `api.github.com` with `Authorization: token <GITHUB_TOKEN>`
- `/codecov/*` — proxied to `api.codecov.io` (no auth, public API)

Requests not matching the path whitelist return 403. CORS headers and GitHub
rate-limit headers are forwarded to the browser.

See [Dashboard-full-proxy-implementation.md](Dashboard-full-proxy-implementation.md)
for full route details, environment variables, setup, and deployment.

### 9.4 CI overview config contract

`CI_OVERVIEW_PROJECTS` is generated from `projects.yaml` by `build_dashboard.py`. Each entry maps a project's `id`, `fixed_branch`, and `overview_workflows` list. This replaces the legacy `CI_OVERVIEW_PROJECTS_FALLBACK` mechanism.

## 10) Operational and Non-Functional Requirements

### NFR-1: Deployability

- Output must be a single static HTML file with all CSS and JS inlined.
- Must be deployable to static hosts such as GitHub Pages.
- Build step requires Python 3.10+ with `jinja2` and `pyyaml`.

### NFR-2: Performance

- In pre-baked mode, landing CI table should render without browser CI API calls at initial load.
- Initial interaction should remain responsive while asynchronous calls complete.

### NFR-3: Resilience

- Missing or failed API responses must degrade gracefully without app crash.
- If branch discovery fails, branch selector remains valid with `main` only.
- If the Worker proxy is unreachable, baked snapshot data still renders.

### NFR-4: Maintainability

- All project/workflow configuration is centralized in `projects.yaml`.
- To add a project or workflow, edit only `projects.yaml` and push to main.
- No HTML editing is required for configuration changes.
- The build script, CSS, JS, and template are separate files for independent editing.

### NFR-5: Security and Browser Safety

- External links must open with `target="_blank"` and `rel="noopener noreferrer"` where applicable.
- Window opener must be nulled when opening external tabs via script where possible.
- The Worker proxy restricts forwarded paths via a whitelist.
- The `GITHUB_TOKEN` is stored as an encrypted secret in Cloudflare (never exposed to the browser).

## 11) Constraints, Dependencies, and Risks

### Constraints

- Live API calls require the Cloudflare Worker to be reachable from the user's network.
- Networks that block `*.workers.dev` (e.g., corporate VPNs/firewalls) will prevent live data; baked snapshots still work.
- Embedded content depends on third-party framing policies.

### Dependencies

- GitHub REST API (Actions endpoints)
- Codecov v2 API
- Cloudflare Workers (free tier, `worker.js` deployment)
- GitHub Actions workflow `bake-dashboard.yml`
- Valid `GITHUB_TOKEN` in both Cloudflare Worker secrets and GitHub Actions secrets
- Python build dependencies: `jinja2`, `pyyaml`

### Risks

- Worker unavailability or `*.workers.dev` blocking degrades live data (mitigated by baked snapshots).
- GitHub fine-grained PAT expiration (max 1 year) requires periodic rotation in Cloudflare.
- Cloudflare free tier limit (100,000 req/day) could be exceeded under extreme load.
- External service schema/availability changes can impact panel rendering.

## 12) Acceptance Criteria

### AC-1: Landing render

- On load, landing page shows hero, CI status bar, and CI overview table.

### AC-2: Pre-baked behavior

- With non-null `PREFETCHED_CI_DATA`, initial CI table row statuses appear without browser workflow fetches.
- Status bar displays snapshot age and refresh link.

### AC-3: Live behavior

- With null `PREFETCHED_CI_DATA`, status bar displays `Live data` and workflow rows fetch live via the Worker proxy.

### AC-4: Branch switching

- Changing project branch dropdown re-fetches only that project's workflow rows and updates branch/time/status cells.

### AC-5: Category routing

- `ci`, `coverage`, `repo`, launch-panel-eligible URLs, and embeddable URLs route to expected behaviors/panels.

### AC-6: Theming

- Theme changes update UI immediately and persist across reloads.

### AC-7: Hash routing

- Direct navigation to valid hash restores corresponding project/category view.

### AC-8: Failure handling

- API errors are presented as non-blocking, readable fallback states.

### AC-9: Worker proxy

- All live API calls from the browser go through the Worker proxy when `WORKER_URL` is configured.
- Direct browser-to-GitHub API calls are not made when the Worker is configured.

## 13) Open Questions

- Should CI overview support manual project filtering or collapsing for scale beyond five projects?
- Should coverage panel include trend/history, or stay as latest snapshot only?
- Should stale snapshot threshold trigger a stronger warning state on landing?
- Should the Worker be deployed via the CI pipeline (Wrangler) instead of manually?
- Should a custom domain be attached to the Worker to avoid `*.workers.dev` firewall blocks?

## 14) Technical Reference

For full technical specifications — API endpoints, configuration schemas, build
pipeline, Worker proxy details, rendering modes, panel behavior, error handling,
performance, and security — see
[Dashboard-full-proxy-implementation.md](Dashboard-full-proxy-implementation.md).

### Runtime model summary

- Build output: single static HTML file (`ci/html/dashboard.html`) with all CSS and JS inlined.
- Build tool: `scripts/build_dashboard.py` (Python 3.10+, `jinja2`, `pyyaml`).
- API proxy: `ci/html/worker.js` (Cloudflare Worker, deployed separately).
- Runtime environment: modern browser with `fetch`, `localStorage`, URL hash, and iframe support.
- No backend service beyond the stateless Worker proxy.
