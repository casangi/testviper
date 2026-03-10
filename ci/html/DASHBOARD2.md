## VIPER Ecosystem Dashboard — v2

This document describes `dashboard-index2.html`, an updated version of the single-file dashboard.
It is structurally identical to `dashboard-index.html` (v1) except for the landing page, which
has been redesigned as described in this file.

For all other features (project navigation, category bar, panel types, themes, embeddability,
coverage panel, CI panel, URL hash routing, and how to add projects), refer to `DASHBOARD.md`.

---

## What changed from v1

### Landing page

| Feature | v1 (`dashboard-index.html`) | v2 (`dashboard-index2.html`) |
|---|---|---|
| Hero card | Title + live UTC clock | Title only (compact) |
| Below the hero card | Project shortcut cards | CI overview table |
| Project shortcut cards | Present (click to navigate) | Removed |
| UTC clock | Present (`startClock()`) | Removed |

The landing page now shows a **CI overview table** that displays the live GitHub Actions status
for all five VIPER projects side by side. Users can switch branches for four of the five projects
using a per-project dropdown (see below).

---

## CI overview table

### What it shows

A single `<table>` spanning ~80 % of the page width, with:

- A **header row** with column labels: `CI Job Description` · `Branch` · `Status` · `Last Run`
- For each project: a **project header row** spanning all columns, containing:
  - The project name.
  - A branch dropdown (for xradio, astroviper, graphviper, toolviper only).
  - An **"Open in GitHub ↗"** link to the project's GitHub Actions page.
- One **workflow data row** per configured workflow, showing:
  - A coloured status dot.
  - The workflow label (e.g. "Python Tests (Linux)").
  - The selected branch name.
  - The run conclusion ("passing", "failing", "cancelled", "timed out", "skipped", or "no runs found").
  - A relative timestamp ("2h ago", "3d ago", etc.).

### Project order and workflows shown

| Project | Branch selector | Workflows displayed |
|---|---|---|
| testviper | Fixed to `main` (no dropdown) | Branch Python Tests (Linux) · Repository Dispatch Receiver · Python Tests & Allure Reports |
| xradio | Dropdown (main + up to 2 recent) | Python Tests (Linux) · Python Tests (macOS) |
| astroviper | Dropdown (main + up to 2 recent) | Python Tests (Linux) · Python Tests (macOS) |
| graphviper | Dropdown (main + up to 2 recent) | Python Tests (Linux) · Python Tests (macOS) |
| toolviper | Dropdown (main + up to 2 recent) | Python Tests (Linux) · Python Tests (macOS) |

The workflows shown are a subset of what appears in each project's `CI` category tab; only the
Python test jobs for Linux and macOS are included (plus the three testviper-specific jobs).

### Branch dropdown behaviour

For the four projects with a dropdown:

1. On page load the dropdown initially contains only `main`.
2. `fetchRecentBranches(owner, repo)` is called asynchronously for each of those four projects.
   It queries `GET /repos/{owner}/{repo}/actions/runs?per_page=30`, collects distinct
   `head_branch` values, excludes `main`, and adds up to 2 to the dropdown.
3. The initial status fetch always runs against `main` immediately, without waiting for the
   branch discovery to complete.
4. When the user selects a different branch, `refreshProjectRows()` re-fetches all workflow rows
   for that project against the chosen branch.

testviper has no dropdown because its workflow suite is specific to the `main` branch.

---

## GitHub API calls

### Endpoints used

| Purpose | Endpoint |
|---|---|
| Workflow run status (landing table) | `GET /repos/casangi/{repo}/actions/workflows/{file}/runs?branch={branch}&per_page=1` |
| Branch discovery (landing table) | `GET /repos/casangi/{repo}/actions/runs?per_page=30` |
| Workflow run status (CI panel tab) | `GET /repos/casangi/{repo}/actions/workflows/{file}/runs?per_page=1` |

### Request budget at page load

| Phase | Requests |
|---|---|
| Branch discovery for 4 projects | 4 |
| Workflow run fetches (3 testviper + 2 × 4 others) | 11 |
| **Total** | **15** |

Branch discovery runs in parallel with the initial workflow fetches; the dropdown updates
asynchronously without delaying the status display.

Each branch change in the dropdown adds 2 requests (one per workflow for that project).

All requests are unauthenticated. GitHub's rate limit is **60 requests/hour per IP**. Exceeding
it causes **HTTP 403** responses — the table cells will then show "unavailable (HTTP 403)".

---

## New JS functions

All new functions live in the `4b. ENGINE` section, immediately after the LANDING PAGE block.

### `CI_OVERVIEW_PROJECTS`

A constant array that lists which projects and workflows appear in the landing CI table, and
whether each project has a branch dropdown (`fixedBranch: false`) or is locked to `main`
(`fixedBranch: true`).  Edit this array to change which jobs are shown without touching the
main `PROJECTS` config.

### `fetchRecentBranches(owner, repo)`

An `async` function that queries `/actions/runs?per_page=30` and returns an array of up to 2
non-`main` branch names that were recently active in CI.  Returns `[]` on any error.

### `fetchWorkflowRow(owner, repo, file, branch, dotEl, statusEl, branchEl, timeEl)`

Fetches the latest workflow run for one `{file}` on `{branch}` and updates the four DOM elements
(`dotEl`, `statusEl`, `branchEl`, `timeEl`) in the corresponding table row.

### `refreshProjectRows(tbody, owner, repo, workflows, branch)`

Re-fetches all workflow rows for one project by calling `fetchWorkflowRow` for each workflow.
Triggered when the user changes the branch dropdown.  Locates rows inside `tbody` using the
`data-wf` attribute set during table construction.

### `buildCIOverview()`

Called once from `init()`.  Builds the full `<table>` DOM structure inside `#ci-overview`,
kicks off branch-discovery fetches (async, non-blocking), and starts status fetches for all
rows against `main`.

---

## Removed from v1

| Removed | Reason |
|---|---|
| `startClock()` | UTC clock removed from landing page |
| `clockInterval` state variable | No longer needed without the clock |
| `buildLandingCards()` | Project shortcut cards removed |
| CSS for `#hero-clock`, `#clock-time`, `#clock-date` | Clock removed |
| CSS for `#landing-projects`, `#landing-hint`, `.landing-card*` | Shortcut cards removed |
| `#hero-clock` HTML | Clock removed |
| `#landing-hint` HTML | Shortcut cards removed |
| `#landing-projects` HTML | Shortcut cards removed |

---

## CSS additions (section 2c — LANDING)

All new selectors are prefixed `ci-ov-` to avoid collisions with the existing `#ci-panel` styles.

| Selector | Purpose |
|---|---|
| `#ci-overview` | Outer container — 80% width, centred with `margin: 0 auto` |
| `.ci-ov-table` | The `<table>` element — full width, `border-collapse: collapse` |
| `.ci-ov-table thead th` | Column headers — monospace, uppercase, muted colour |
| `.ci-ov-proj-row td` | Project section header row — uses `--surface` background |
| `.ci-ov-proj-inner` | Flex container inside the project header cell |
| `.ci-ov-proj-name` | Project name label |
| `.ci-ov-branch-select` | Branch `<select>` — styled to match dashboard theme |
| `.ci-ov-open-link` | "Open in GitHub ↗" link — border-radius button style |
| `.ci-ov-wf-row td` | Workflow data row cells |
| `.ci-ov-dot-cell` | Fixed-width cell containing the status dot |
| `.ci-ov-dot` | Round coloured status indicator |
| `.ci-ov-status` | Status text (colour set inline by JS) |
| `.ci-ov-time` | Relative timestamp |

---

## `#landing` layout changes

The `#landing` container CSS was adjusted for the new content:

- `justify-content` changed from `center` to `flex-start` so the hero card and table start
  near the top rather than being vertically centred (which would push the table below the fold).
- `overflow-y: auto` added so the table scrolls if the window is short.
- `padding` adjusted (`28px 24px 40px`) to give comfortable top spacing.
- `gap` reduced from `40px` to `28px` (less space needed between title and table).
- `#hero-card` `padding` reduced from `52px 80px` to `28px 80px` (no clock to fill space).
