## VIPER Ecosystem Dashboard

This document describes the single‑file dashboard at `dashboard-index.html`: what it does, how it is structured, and how to configure and maintain it.

The dashboard is intentionally self‑contained (HTML, CSS, JS in one file) so it can be dropped into any static hosting environment without a build step, such as for example in the gh-pages branch of a project in GitHub.

---

## High‑level functionality

- **Landing page**
  - Shows a hero card with a configurable title and a live UTC clock.
  - Lists projects as shortcut cards; clicking a card selects that project and its first category.

- **Project navigation**
  - A top **project bar** lists all projects from the `PROJECTS` config.
  - Selecting a project activates the project tab and repopulates the category bar.

- **Category navigation**
  - A second **category bar** lists that project’s categories (Reports, Bench, Docs, Repo, Coverage, CI, Custom).
  - Each category has a type‑specific icon and accent colour.

- **Content area**
  - Depending on category type, the centre of the page will show:
    - An **iframe** for embeddable URLs.
    - A **launch panel** for non‑embeddable pages (e.g. some docs).
    - A **coverage panel** for `type: "coverage"` categories (Codecov API).
    - A **CI panel** for `type: "ci"` categories (GitHub Actions API).
    - The **landing** panel when no project/category is selected.

- **Repo behaviour**
  - `type: "repo"` categories **do not change** the centre panel.
  - Clicking `Repo` opens the repository URL in a **new browser tab**, with a small external‑link icon next to the label.

- **Themes**
  - Multiple colour themes (dark, light, slate, system) controlled via a theme switcher.
  - Theme choice is saved in `localStorage`.

---

## File structure (within `dashboard-index.html`)

1. **Header comment block**
   - Overview of the dashboard.
   - Quick hints on how to add projects and change the title.
   - Notes on navigation and embeddability.

2. **`<head>`**
   - Imports fonts.
   - Defines all CSS inside a single `<style>` block:
     - Theme variables.
     - Layout for project/category bars, content panels, launch panel, coverage panel, CI panel, etc.

3. **`<body>`**
   - App shell: brand, project bar, category bar.
   - Main content wrapper `#frame-wrap` with:
     - `#landing` (landing page).
     - `#main-frame` (iframe panel).
     - `#launch-panel` (non‑embeddable URLs).
     - `#coverage-panel` (Codecov summary).
     - `#ci-panel` (GitHub Actions summary).
     - `#loader` (spinner overlay).

4. **`<script>`**
   - Configuration (`4a. CONFIGURATION`):
     - `PROJECTS` array.
     - Landing title.
     - Non‑embeddable hostnames and types.
     - Theme defaults and labels.
   - Engine (`4b. ENGINE`):
     - SVG icon definitions per category type.
     - Runtime state (active project/category).
     - Landing page helpers and UTC clock.
     - Panel visibility / routing helpers.
     - Theme switcher logic.
     - Project and category tab builders.
     - Embeddability checks and launch panel.
     - Coverage panel (`showCoveragePanel`).
     - CI panel (`showCIPanel`).
     - Iframe loader and hash‑based routing.
     - Initialisation (`init()`).

---

## Configuration: projects and categories

All runtime configuration lives in the `PROJECTS` array inside the CONFIG section of the script.

### Project object

Each project is an object of the form:

```js
{
  id:         "xradio",      // unique string, used in URL hash
  name:       "xradio",      // label shown in the project bar and landing cards
  categories: [/* see below */],
}
```

The `id` is used in the hash (`#projectId/catId`) and must be unique across all projects.

### Category object

Each project has a `categories` array; each category is:

```js
{
  id:    "report",           // unique within the project
  label: "Reports",          // text shown on the category tab
  type:  "report" | "bench" | "docs" | "repo" | "coverage" | "custom" | "ci",
  url:   "https://…",        // behaviour depends on type

  // Optional / type‑specific fields:
  codecov: { service, owner, repo },   // for coverage panel
  github:  { owner, repo },            // for coverage + CI panels
  workflows: [                         // for CI panel
    { file: "workflow.yml", label: "Readable name" },
    // …
  ],
}
```

#### Category types and behaviour

- **`"report"`**
  - Intended for test/allure reports, etc.
  - Behaviour: loads `url` in the **iframe panel** (if embeddable).

- **`"bench"`**
  - Benchmarks and performance dashboards.
  - Behaviour: iframe.

- **`"docs"`**
  - Documentation sites (e.g. ReadTheDocs).
  - Behaviour:
    - If `url` host is not in `LAUNCH_PANEL_URLS`, loads in the iframe.
    - If it is (e.g. docs on GitHub), shows the **launch panel**.

- **`"repo"`**
  - Git repositories (GitHub, GitLab, etc.).
  - Behaviour:
    - **Does not use the iframe or launch panel.**
    - Clicking the `Repo` tab:
      - Opens `url` in a **new browser tab**.
      - Leaves the current centre panel content unchanged.
    - The label itself (`Repo`) is a hyperlink with a small ↗ icon and tooltip “Open in a new tab”.

- **`"coverage"`**
  - Codecov coverage summary.
  - Behaviour:
    - Uses **Codecov’s v2 repo API** to show merged coverage totals.
    - Uses **GitHub Actions API** (optional) for a CI status row.
    - Renders inside the in‑page `#coverage-panel` (no iframe).

- **`"ci"`**
  - Live CI status from GitHub Actions.
  - Behaviour:
    - For each configured workflow file, calls:
      - `GET /repos/{owner}/{repo}/actions/workflows/{file}/runs?per_page=1`
    - Shows latest run conclusion and “time ago” per workflow in `#ci-panel`.

- **`"custom"`**
  - Any other type you may want to treat as “other”.
  - Behaviour:
    - Same as `"report"`: tries to embed via iframe unless blocked by `LAUNCH_PANEL_URLS`.

---

## Embeddability and launch panel

Some sites (GitHub, GitLab, Bitbucket, Codecov app) do not allow being embedded in an iframe. The dashboard handles this via:

- **`LAUNCH_PANEL_TYPES`**
  - Currently an **empty array**.
  - Historically used to force certain types (like `"repo"`) into the launch panel; now:
    - `repo` opens directly in a new tab instead.
    - `coverage` uses its own dedicated panel.

- **`LAUNCH_PANEL_URLS`**
  - List of hostnames (or parent domains) that should never be iframed:
    - Defaults include `github.com`, `gitlab.com`, `bitbucket.org`.
  - If a category URL’s hostname matches (or is a subdomain), the dashboard:
    - Shows the **launch panel** with:
      - Icon (matching category type).
      - Category label.
      - The raw URL.
      - A human‑readable reason.
      - A button to open in a new tab.

---

## External APIs and rate limiting

### Codecov API (coverage panel)

- Endpoint:
  - `GET https://api.codecov.io/api/v2/{service}/{owner}/repos/{repo}/`
- Used fields:
  - `data.totals.{ coverage, lines, hits, misses, partials }`
  - `data.branch` (default branch).
  - `data.updatestamp` (timestamp of last upload).
- Behaviour:
  - Shows a coverage circle with colour based on percentage.
  - Displays merged line counts and a relative “Updated … ago” string.

### GitHub Actions API (coverage CI row)

- Optional per coverage category (if `github: { owner, repo }` is set).
- Endpoint:
  - `GET https://api.github.com/repos/{owner}/{repo}/actions/runs?per_page=5`
- Behaviour:
  - Picks the most recent **completed** run.
  - Shows:
    - A coloured dot based on conclusion.
    - Workflow name and result (“passing”, “failing”, etc.).
    - Relative updated time.
- **Rate limiting note**:
  - This call is made **directly from the browser, without authentication**.
  - It is therefore subject to **GitHub’s unauthenticated REST API rate limit**, currently **60 requests/hour per IP**.
  - If that limit is exceeded, GitHub returns **HTTP 403** even though the runs are visible in the web UI. The dashboard will then show CI status as “unavailable (HTTP 403)”.

### GitHub Actions API (CI panel)

- For `type: "ci"` categories, the CI panel uses:
  - `GET /repos/{owner}/{repo}/actions/workflows/{file}/runs?per_page=1`
  - One request **per workflow file** configured in the category’s `workflows` array.
- Design:
  - Uses the per‑workflow endpoint (works unauthenticated for public repos).
  - Avoids `/actions/runs` and `/actions/workflows` list endpoints, which tend to return 403 without a token.
- **Rate limiting note**:
  - These requests are also **unauthenticated** and therefore share the same **60 requests/hour/IP** pool.
  - With multiple projects and workflows, it is easy to hit this limit, which again results in HTTP 403 responses even though the workflows are accessible in the GitHub UI.

---

## Themes and appearance

- Themes are controlled by the `data-theme` attribute on the `<html>` element:
  - Values: `"dark"`, `"light"`, `"slate"`, `"system"`.
  - Each theme defines a set of CSS custom properties used throughout the layout.
- `DEFAULT_THEME` in the CONFIG block controls the initial theme if no user preference is stored.
- The theme switcher:
  - Calls `setTheme(name)` to:
    - Update `document.documentElement.dataset.theme`.
    - Persist the choice in `localStorage` under `dashboard-theme`.
    - Update the button label and highlight the active menu option.

---

## Navigation behaviour

- **URL hash**
  - Encodes the current selection:
    - No hash: landing page.
    - `#projectId`: select that project and its first category.
    - `#projectId/catId`: select project and specific category.
  - `selectCategory` uses `history.replaceState` to keep the hash in sync.

- **Back to landing**
  - Clicking the “Dashboard” brand calls `goHome()`:
    - Clears hash.
    - Resets active project/category state.
    - Empties the category bar.
    - Shows the landing panel.

- **Open‑full button**
  - The right‑side `open ↗` button in the category bar always opens the **current category URL** in a new tab, regardless of whether it is being iframed or shown in a panel.

---

## How to add or update projects

1. **Locate the `PROJECTS` array** in the CONFIG section of `dashboard-index.html`.
2. **Copy the template block** at the bottom of the array.
3. **Fill in:**
   - `id`: short, URL‑friendly identifier.
   - `name`: human‑readable project name.
   - `categories`: a list of categories with appropriate `id`, `label`, `type`, and `url`.
4. **For coverage:**
   - Add `type: "coverage"` and `codecov: { service, owner, repo }`.
   - Optionally add `github: { owner, repo }` for CI status.
5. **For CI:**
   - Add `type: "ci"`.
   - Add `github: { owner, repo }`.
   - Add `workflows`: one object per workflow file you want to display.
6. **For repo:**
   - Add `type: "repo"` and the GitHub (or other VCS) URL.
   - No additional config needed; the dashboard will render the `Repo` tab as an external link with an icon.

After updating the config, re‑load the dashboard in the browser. No build step is required.

---

## Maintenance tips

- **Keep comments in sync**
  - The top header block and CONFIG comments are intended as living documentation.
  - When changing behaviour (e.g. how repo tabs work or which panels exist), update those comments at the same time.

- **Be mindful of GitHub rate limits**
  - Remember that all GitHub API calls are anonymous and share a 60 requests/hour limit per IP.
  - To reduce noise:
    - Limit the number of workflows per CI category.
    - Avoid unnecessary reloads / polling.

- **Adding themes**
  - Add a new `[data-theme="yourtheme"]` block in CSS.
  - Add a corresponding entry in `THEME_LABELS`.
  - Add a new `.theme-option` entry in the theme menu HTML.

- **Extending category types**
  - To introduce a new `type`:
    - Add a new icon entry in the `ICONS` object.
    - Add a colour in `TYPE_COLORS` and matching CSS rules for `.cat-tab[data-type="..."]`.
    - Decide whether it should:
      - Embed via iframe,
      - Use the launch panel (via `LAUNCH_PANEL_URLS`),
      - Or render a dedicated in‑page panel.

