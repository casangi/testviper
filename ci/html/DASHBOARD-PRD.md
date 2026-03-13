# Product Requirements Document (PRD): VIPER Ecosystem Dashboard

## 1) Document Control

- Product: VIPER Ecosystem Dashboard
- Primary artifact: `ci/html/dashboard-live-index.html`
- Supporting artifact: `scripts/bake_dashboard.py`
- Related documentation: `ci/html/DASHBOARD.md`
- PRD status: Draft for implementation baseline

## 2) Product Summary

The VIPER Ecosystem Dashboard is a single-file web application that centralizes access to CI, reports, benchmarks, coverage, docs, and repositories for VIPER projects. It is optimized for static hosting with no build step and supports two CI data modes:

- Pre-baked snapshot mode (fast load, no browser CI API calls at initial render)
- Live mode (direct browser fetches from public APIs)

The dashboard acts as both:

- A landing-level CI operations view across projects
- A project-level navigation surface for project assets and status panels

## 3) Problem Statement

VIPER project status is fragmented across multiple URLs and services (GitHub Actions, Codecov, docs, reports, benchmarks). Users need a single, low-friction dashboard that:

- Aggregates cross-project CI health quickly
- Provides consistent navigation to project artifacts
- Works in static environments (for example GitHub Pages) without build tooling

## 4) Goals and Non-Goals

### Goals

- Provide a unified, static-hosted dashboard for VIPER ecosystem observability.
- Show CI status at two levels:
  - Cross-project overview on landing page
  - Per-project detailed CI category panel
- Support fast initial rendering via CI-baked snapshot data.
- Preserve deep-linkable navigation via URL hash.
- Support multiple visual themes with persisted user preference.

### Non-Goals

- Real-time streaming/push updates.
- Authenticated per-user API access in browser.
- Server-side rendering or backend service ownership.
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

- Single-file dashboard with embedded CSS/JS.
- Five configured projects (`testviper`, `xradio`, `astroviper`, `graphviper`, `toolviper`).
- Category types: `ci`, `report`, `bench`, `coverage`, `docs`, `repo`, `custom`.
- Landing CI overview table with per-project sections and workflow rows.
- Branch selector for projects configured with `fixedBranch: false`.
- Theme selector (`dark`, `light`, `slate`, `system`) persisted in `localStorage`.
- Hash-based routing (`#project`, `#project/category`).
- Non-embeddable URL handling via launch panel and direct external links.

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

- Landing hero title must be configurable via `LANDING_TITLE`.
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

- Dashboard shall be driven by a `PROJECTS` configuration array.
- Each project shall define unique `id`, display `name`, and `categories`.
- Each category shall define `id`, `label`, `type`, `url`, with optional type-specific fields.

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
  - Live fallback: use browser API calls + `CI_OVERVIEW_PROJECTS_FALLBACK`
- If pre-baked data is available and not force-refreshed:
  - Render row status/times from embedded JSON immediately.
  - Populate non-main branch options from baked recent branches.
- Refresh action shall force live mode re-fetch.

### FR-5: Branch Selection in CI Overview

- For projects with `fixedBranch: false`, branch selector shall:
  - Default to `main`
  - Include up to two recent non-main branches when available
- Changing branch shall re-fetch all workflow rows only for that project.

### FR-6: CI Category Panel

- For a `ci` category, dashboard shall call one endpoint per configured workflow file:
  - `GET /repos/{owner}/{repo}/actions/workflows/{file}/runs?per_page=1`
- Panel shall show per-workflow status and relative time.
- Empty workflow list shall render "No workflows configured."

### FR-7: Coverage Category Panel

- Coverage panel shall fetch merged totals from:
  - `GET https://api.codecov.io/api/v2/{service}/{owner}/repos/{repo}/`
- Panel shall render:
  - Coverage percentage and color state
  - Lines/hits/misses/partials
  - Branch and updated time
- If `github` is configured, panel shall fetch latest CI row from:
  - `GET /repos/{owner}/{repo}/actions/runs?per_page=5`

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
- Theme menu shall visually indicate active theme.

### FR-10: Loading and Error States

- Iframe routes shall show loader while loading.
- Dashboard shall attempt silent blank-frame detection and fallback to launch panel.
- API failures shall present user-visible fallback messages such as:
  - `unavailable (HTTP xxx)`
  - `Could not load Codecov data (...)`
  - `CI status unavailable`

## 9) Data Contracts and Configuration Contracts

### 9.1 Baked data contract

`PREFETCHED_CI_DATA` object format:

- `baked_at`: ISO-8601 UTC timestamp
- `projects[projectId].recent_branches`: optional list of up to 2 branch names
- `projects[projectId].workflows[file].conclusion`
- `projects[projectId].workflows[file].updated_at`

### 9.2 Injection markers (strict contract)

Bake script requires exact lines in HTML:

- `const PREFETCHED_CI_DATA = null;`
- `const CI_OVERVIEW_PROJECTS = null; /* INJECTED_BY_BAKE */`

Changing these marker strings breaks injection.

### 9.3 CI overview config contract

`CI_OVERVIEW_PROJECTS` is generated from canonical `PROJECTS` list in `scripts/bake_dashboard.py` and should remain machine-managed in baked output.

For unbaked local operation, `CI_OVERVIEW_PROJECTS_FALLBACK` must stay aligned with script project/workflow definitions.

## 10) Operational and Non-Functional Requirements

### NFR-1: Deployability

- Must run as a static file with no build step.
- Must be suitable for static hosts such as GitHub Pages.

### NFR-2: Performance

- In pre-baked mode, landing CI table should render without browser CI API calls at initial load.
- Initial interaction should remain responsive while asynchronous calls complete.

### NFR-3: Resilience

- Missing or failed API responses must degrade gracefully without app crash.
- If branch discovery fails, branch selector remains valid with `main` only.

### NFR-4: Maintainability

- CI overview project/workflow source of truth is the Python bake script list.
- HTML fallback list must be intentionally synchronized for local/unbaked usage.

### NFR-5: Security and Browser Safety

- External links must open with `target="_blank"` and `rel="noopener noreferrer"` where applicable.
- Window opener must be nulled when opening external tabs via script where possible.

## 11) Constraints, Dependencies, and Risks

### Constraints

- Browser-side GitHub API usage is unauthenticated in live mode.
- Public API rate limits (GitHub unauthenticated) can cause HTTP 403.
- Embedded content depends on third-party framing policies.

### Dependencies

- GitHub REST API (Actions endpoints)
- Codecov v2 API
- GitHub Actions workflow `bake-dashboard.yml`
- Valid `GITHUB_TOKEN` for bake-time script execution

### Risks

- Rate-limit exhaustion can degrade status fidelity.
- Drift between fallback config and bake script config can create inconsistent local behavior.
- External service schema/availability changes can impact panel rendering.

## 12) Acceptance Criteria

### AC-1: Landing render

- On load, landing page shows hero, CI status bar, and CI overview table.

### AC-2: Pre-baked behavior

- With non-null `PREFETCHED_CI_DATA`, initial CI table row statuses appear without browser workflow fetches.
- Status bar displays snapshot age and refresh link.

### AC-3: Live behavior

- With null `PREFETCHED_CI_DATA`, status bar displays `Live data` and workflow rows fetch live.

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

## 13) Implementation Notes for Future Versions

- Keep `scripts/bake_dashboard.py` as canonical source for CI overview project/workflow definitions.
- Treat injection markers as immutable interface.
- When adding a project:
  - Add to Python `PROJECTS` list
  - Ensure HTML `PROJECTS` app config includes matching `id` and category set
  - Keep `CI_OVERVIEW_PROJECTS_FALLBACK` aligned for local mode
- Prefer explicit workflow configuration over runtime discovery for predictable API behavior.

## 14) Open Questions

- Should live mode support authenticated browser requests (optional token) to reduce rate-limit failures?
- Should CI overview support manual project filtering or collapsing for scale beyond five projects?
- Should coverage panel include trend/history, or stay as latest snapshot only?
- Should stale snapshot threshold trigger a stronger warning state on landing?

## 15) Technical Specifications

### 15.1 Reference Implementation and Runtime Model

- Primary runtime artifact: `ci/html/dashboard-live-index.html`.
- Build/deploy model: static single-file HTML with embedded CSS and JavaScript.
- Required runtime environment: modern browser with JavaScript enabled, `fetch` API, `localStorage`, URL hash support, and iframe support.
- No backend service required for runtime rendering in current implementation.

### 15.2 Rendering Modes and Switching Rules

- Mode A: Pre-baked snapshot mode
  - Condition: `PREFETCHED_CI_DATA` is non-null and no force-live refresh is requested.
  - Landing CI overview rows are rendered from embedded JSON.
  - Initial browser CI API calls for landing overview are avoided.
- Mode B: Live mode
  - Condition: `PREFETCHED_CI_DATA` is null, or user triggers refresh.
  - Landing CI overview rows are fetched at runtime from GitHub APIs.
- Refresh rule:
  - Snapshot mode exposes a refresh action that forces live fetching for current session view.

### 15.3 API Specifications

- GitHub Actions (landing CI overview and CI category panel):
  - `GET https://api.github.com/repos/{owner}/{repo}/actions/workflows/{file}/runs?branch={branch}&per_page=1`
  - `GET https://api.github.com/repos/{owner}/{repo}/actions/workflows/{file}/runs?per_page=1`
  - `GET https://api.github.com/repos/{owner}/{repo}/actions/runs?per_page=30` (recent branches)
  - `GET https://api.github.com/repos/{owner}/{repo}/actions/runs?per_page=5` (coverage CI row)
- Codecov (coverage panel):
  - `GET https://api.codecov.io/api/v2/{service}/{owner}/repos/{repo}/`
- Expected response fields consumed:
  - GitHub: `workflow_runs[].conclusion`, `workflow_runs[].status`, `workflow_runs[].updated_at`, `workflow_runs[].head_branch`, `workflow_runs[].name`
  - Codecov: `totals.coverage`, `totals.lines`, `totals.hits`, `totals.misses`, `totals.partials`, `branch`, `updatestamp`

### 15.4 Configuration Schemas

- `PROJECTS` schema:
  - Project object: `{ id, name, categories[] }`
  - Category object: `{ id, label, type, url, codecov?, github?, workflows? }`
- `CI_OVERVIEW_PROJECTS` schema:
  - `[{ id, fixedBranch, workflows: [{ file, label }] }]`
- `PREFETCHED_CI_DATA` schema:
  - `{ baked_at, projects: { [projectId]: { recent_branches?, workflows: { [file]: { conclusion, updated_at } } } } }`

### 15.5 Bake Pipeline and Injection Contract

- Bake script: `scripts/bake_dashboard.py`.
- Required environment variable: `GITHUB_TOKEN`.
- Optional variables: `DASHBOARD_SRC`, `DASHBOARD_OUT`.
- Injection markers in HTML are strict and must remain exact:
  - `const PREFETCHED_CI_DATA = null;`
  - `const CI_OVERVIEW_PROJECTS = null; /* INJECTED_BY_BAKE */`
- `CI_OVERVIEW_PROJECTS` is generated from bake script project definitions.
- `CI_OVERVIEW_PROJECTS_FALLBACK` is required for local/unbaked rendering continuity.

### 15.6 Routing and State Persistence

- URL hash formats:
  - Empty hash: landing
  - `#projectId`: select project and default category
  - `#projectId/categoryId`: select specific category
- Theme persistence:
  - Storage key: `dashboard-theme`
  - Supported values: `dark`, `light`, `slate`, `system`

### 15.7 Panel and Interaction Specifications

- Exactly one content panel visible at a time:
  - `landing`, `frame`, `launch-panel`, `coverage-panel`, `ci-panel`
- Category handling:
  - `repo`: opens new tab, center panel unchanged
  - `coverage`: in-page coverage panel
  - `ci`: in-page CI panel
  - Non-embeddable URLs/types: launch panel
  - Other URLs: iframe loader path

### 15.8 Error Handling and Fallback Behavior

- API request failures must not terminate app flow.
- User-facing fallback statuses include:
  - `unavailable (HTTP <code>)`
  - `no runs found`
  - `CI status unavailable`
  - coverage load failure message with direct-open option
- Branch discovery failure fallback:
  - Keep branch selector usable with `main` only.
- Iframe fallback:
  - If loaded frame appears silently blank, route to launch panel.

### 15.9 Performance and Rate-Limit Considerations

- Live landing mode request budget is bounded by configured projects/workflows and branch discovery calls.
- Pre-baked mode should avoid initial landing CI workflow requests from browser.
- Runtime calls to GitHub in live mode are unauthenticated and subject to public rate limits (for example 60 requests/hour/IP).
- Implementations should avoid unnecessary polling and excessive reload loops.

### 15.10 Security and External Navigation

- External links should use `target="_blank"` with `rel="noopener noreferrer"`.
- Script-opened windows should clear opener linkage when supported.
- Launch panel should be used for domains or types that cannot be safely embedded.

