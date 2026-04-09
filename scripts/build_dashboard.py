#!/usr/bin/env python3
"""
build_dashboard.py — Build and optionally bake the VIPER Ecosystem Dashboard.

Reads the project configuration from ci/config/projects.yaml, the Jinja2
template from ci/templates/base.html, the CSS from ci/static/style.css,
and the JS engine from ci/static/app.js.  Generates the JavaScript config
constants from the YAML, inlines everything into a single HTML file, and
optionally pre-bakes CI data from the GitHub API.

Usage (in CI — with baking):
    GITHUB_TOKEN=<token> python scripts/build_dashboard.py

Usage (locally — no baking, live mode via Cloudflare Worker):
    python scripts/build_dashboard.py

Environment variables:
    GITHUB_TOKEN   Optional. When set, fetches CI data and injects a
                   PREFETCHED_CI_DATA snapshot into the output HTML.
    DASHBOARD_OUT  Optional. Output path. Default: ci/html/dashboard.html
"""

import json
import os
import sys
import textwrap
import urllib.error
import urllib.request
from datetime import datetime, timezone

import yaml
from jinja2 import Environment


# ---------------------------------------------------------------------------
# Paths (relative to repo root)
# ---------------------------------------------------------------------------

SCRIPT_DIR  = os.path.dirname(os.path.abspath(__file__))
REPO_ROOT   = os.path.normpath(os.path.join(SCRIPT_DIR, ".."))

CONFIG_PATH   = os.path.join(REPO_ROOT, "ci", "config", "projects.yaml")
TEMPLATE_PATH = os.path.join(REPO_ROOT, "ci", "templates", "base.html")
CSS_PATH      = os.path.join(REPO_ROOT, "ci", "static", "style.css")
JS_PATH       = os.path.join(REPO_ROOT, "ci", "static", "app.js")
DEFAULT_OUT   = os.path.join(REPO_ROOT, "ci", "html", "dashboard.html")


# ---------------------------------------------------------------------------
# GitHub API helpers
# ---------------------------------------------------------------------------

API_BASE = "https://api.github.com"
BRANCH   = "main"


def _gh_get(path: str, token: str) -> dict:
    """Perform an authenticated GET against the GitHub REST API.

    Parameters
    ----------
    path : str
        Path appended to ``API_BASE`` (for example ``/repos/{owner}/{repo}/...``).
    token : str
        Bearer token sent in the ``Authorization`` header.

    Returns
    -------
    dict
        Parsed JSON response body. On HTTP errors other than 401/403, logs a
        warning and returns an empty dict. On 401 or 403, raises
        ``RuntimeError``. On other exceptions, logs a warning and returns {}.

    """
    url = API_BASE + path
    req = urllib.request.Request(
        url,
        headers={
            "Accept":               "application/vnd.github+json",
            "Authorization":        f"Bearer {token}",
            "X-GitHub-Api-Version": "2022-11-28",
        },
    )
    try:
        with urllib.request.urlopen(req, timeout=20) as resp:
            return json.loads(resp.read().decode())
    except urllib.error.HTTPError as exc:
        if exc.code in (401, 403):
            raise RuntimeError(
                f"GitHub API error (HTTP {exc.code}) for {url}"
            ) from exc
        print(f"  WARNING: HTTP {exc.code} for {url}", file=sys.stderr)
        return {}
    except Exception as exc:
        print(f"  WARNING: {exc} for {url}", file=sys.stderr)
        return {}


def fetch_workflow_run(owner, repo, wf_file, branch, token):
    """Return the most recent workflow run for a workflow file on a branch.

    Parameters
    ----------
    owner : str
        GitHub repository owner (user or organization).
    repo : str
        Repository name.
    wf_file : str
        Workflow filename under ``.github/workflows`` (for example ``ci.yml``).
    branch : str
        Branch name to filter runs.
    token : str
        GitHub API token for ``_gh_get``.

    Returns
    -------
    dict or None
        The latest matching workflow run object, or ``None`` if none exist.

    """
    path = (
        f"/repos/{owner}/{repo}/actions/workflows/{wf_file}/runs"
        f"?branch={branch}&per_page=1"
    )
    data = _gh_get(path, token)
    runs = data.get("workflow_runs", [])
    return runs[0] if runs else None


def fetch_workflow_run_any_branch(owner, repo, wf_file, token):
    """Fetch the latest GitHub Actions run for a workflow, any branch.

    Used for CI panels so the newest run is shown regardless of ``head_branch``.

    Parameters
    ----------
    owner : str
        GitHub repository owner.
    repo : str
        Repository name.
    wf_file : str
        Workflow filename under ``.github/workflows``.
    token : str
        GitHub API token for ``_gh_get``.

    Returns
    -------
    dict or None
        The latest workflow run object, or ``None`` if no runs exist.

    """
    path = (
        f"/repos/{owner}/{repo}/actions/workflows/{wf_file}/runs"
        f"?per_page=1"
    )
    data = _gh_get(path, token)
    runs = data.get("workflow_runs", [])
    return runs[0] if runs else None


def fetch_recent_branches(owner, repo, token, max_branches=2):
    """Collect distinct head branches from recent workflow runs.

    Parameters
    ----------
    owner : str
        GitHub repository owner.
    repo : str
        Repository name.
    token : str
        GitHub API token for ``_gh_get``.
    max_branches : int, optional
        Maximum number of branches to return after excluding the default
        branch (``BRANCH``). Default is 2.

    Returns
    -------
    list of str
        Head branch names from recent runs, excluding the configured default.

    """
    path = f"/repos/{owner}/{repo}/actions/runs?per_page=30"
    data = _gh_get(path, token)
    seen: set[str] = set()
    branches: list[str] = []
    for run in data.get("workflow_runs", []):
        b = run.get("head_branch", "")
        if b and b != BRANCH and b not in seen:
            seen.add(b)
            branches.append(b)
            if len(branches) >= max_branches:
                break
    return branches


# ---------------------------------------------------------------------------
# Config → JS generation
# ---------------------------------------------------------------------------

def yaml_categories_to_js(project: dict) -> list[dict]:
    """Map YAML project categories to client ``PROJECTS`` category dicts.

    Parameters
    ----------
    project : dict
        One project entry from config (must include ``categories``, ``owner``,
        ``repo`` as used by ``ci`` / ``coverage`` categories).

    Returns
    -------
    list of dict
        Category objects with ``id``, ``label``, ``type``, ``url``, and for
        ``ci`` / ``coverage`` the appropriate ``github`` (and optional
        ``workflows`` / ``codecov``) keys.

    """
    js_cats = []
    for cat in project.get("categories", []):
        js_cat: dict = {
            "id":    cat["id"],
            "label": cat["label"],
            "type":  cat["type"],
            "url":   cat.get("url", ""),
        }
        if cat["type"] == "ci":
            js_cat["github"] = {"owner": project["owner"], "repo": project["repo"]}
            js_cat["workflows"] = cat.get("workflows", [])
        if cat["type"] == "coverage":
            if "codecov" in cat:
                js_cat["codecov"] = cat["codecov"]
            js_cat["github"] = {"owner": project["owner"], "repo": project["repo"]}
        js_cats.append(js_cat)
    return js_cats


def generate_js_config(config: dict, prefetched_data) -> str:
    """Emit JavaScript lines for dashboard globals (projects, theme, CI bake).

    Parameters
    ----------
    config : dict
        Parsed YAML root (``dashboard``, ``projects``, launch panels, themes).
    prefetched_data : dict or None
        Result of ``bake_ci_data`` (embedded as ``PREFETCHED_CI_DATA``), or
        ``None`` for live mode.

    Returns
    -------
    str
        Newline-joined ``const ... = ...;`` assignments consumed by the
        dashboard script.

    """
    dashboard = config.get("dashboard", {})
    projects  = config.get("projects", [])

    js_projects = []
    for p in projects:
        js_projects.append({
            "id":         p["id"],
            "name":       p["name"],
            "categories": yaml_categories_to_js(p),
        })

    ci_overview = []
    for p in projects:
        ci_overview.append({
            "id":          p["id"],
            "fixedBranch": p.get("fixed_branch", False),
            "workflows":   p.get("overview_workflows", []),
        })

    lines = []
    lines.append(f"const PROJECTS = {json.dumps(js_projects, separators=(',', ':'))};")
    lines.append(f"const LANDING_TITLE = {json.dumps(dashboard.get('title', 'Dashboard'))};")
    lines.append(f"const LAUNCH_PANEL_TYPES = {json.dumps(config.get('launch_panel_types', []))};")
    lines.append(f"const LAUNCH_PANEL_URLS = {json.dumps(config.get('launch_panel_urls', []))};")
    lines.append(f"const DEFAULT_THEME = {json.dumps(dashboard.get('default_theme', 'light'))};")
    lines.append(f"const THEME_LABELS = {json.dumps(config.get('themes', {}))};")

    worker_url = dashboard.get("worker_url", "")
    lines.append(f"const WORKER_URL = {json.dumps(worker_url or '')};")

    max_branches = dashboard.get("max_recent_branches", 4)
    lines.append(f"const MAX_RECENT_BRANCHES = {json.dumps(max_branches)};")

    if prefetched_data is not None:
        lines.append(f"const PREFETCHED_CI_DATA = {json.dumps(prefetched_data, separators=(',', ':'))};")
    else:
        lines.append("const PREFETCHED_CI_DATA = null;")

    lines.append(f"const CI_OVERVIEW_PROJECTS = {json.dumps(ci_overview, separators=(',', ':'))};")

    return "\n".join(lines)


# ---------------------------------------------------------------------------
# Bake CI data (optional)
# ---------------------------------------------------------------------------

def bake_ci_data(config: dict, token: str) -> dict | None:
    """Prefetch workflow and branch data from GitHub for all projects.

    Parameters
    ----------
    config : dict
        Parsed YAML with ``projects`` and ``dashboard.max_recent_branches``.
    token : str
        ``GITHUB_TOKEN`` for API requests.

    Returns
    -------
    dict or None
        Payload with UTC ``baked_at`` and per-project ``workflows``,
        optional ``panel_workflows`` and ``recent_branches``. Returns
        ``None`` if a ``RuntimeError`` is raised (e.g. auth failure).
        Individual fetch failures are counted and warned on stderr.

    """
    projects = config.get("projects", [])
    max_branches = config.get("dashboard", {}).get("max_recent_branches", 2)
    baked_projects: dict = {}
    total_calls = 0
    failures    = 0

    try:
        for proj in projects:
            pid   = proj["id"]
            owner = proj["owner"]
            repo  = proj["repo"]
            print(f"\n[{pid}]")

            proj_data: dict = {"workflows": {}}

            for wf in proj.get("overview_workflows", []):
                wf_file = wf["file"]
                print(f"  Fetching run: {wf_file} @ {BRANCH} ...", end=" ")
                run = fetch_workflow_run(owner, repo, wf_file, BRANCH, token)
                total_calls += 1
                if run:
                    proj_data["workflows"][wf_file] = {
                        "conclusion": run.get("conclusion") or run.get("status") or "unknown",
                        "updated_at": run.get("updated_at", ""),
                    }
                    print(proj_data["workflows"][wf_file]["conclusion"])
                else:
                    failures += 1
                    print("no data")

            # Fetch CI panel workflows (latest run on any branch)
            ci_cats = [c for c in proj.get("categories", [])
                       if c.get("type") == "ci"]
            panel_wfs = {wf["file"] for c in ci_cats
                         for wf in c.get("workflows", [])}
            # Exclude workflows already fetched for overview (avoid duplicate calls)
            overview_wfs = {wf["file"] for wf in proj.get("overview_workflows", [])}
            extra_panel_wfs = panel_wfs - overview_wfs
            panel_data: dict = {}

            # Re-fetch overview workflows without branch filter for panel use
            for wf_file in overview_wfs & panel_wfs:
                print(f"  Fetching panel run: {wf_file} (any branch) ...", end=" ")
                run = fetch_workflow_run_any_branch(owner, repo, wf_file, token)
                total_calls += 1
                if run:
                    panel_data[wf_file] = {
                        "conclusion":  run.get("conclusion") or run.get("status") or "unknown",
                        "updated_at":  run.get("updated_at", ""),
                        "head_branch": run.get("head_branch", ""),
                    }
                    print(panel_data[wf_file]["conclusion"])
                else:
                    failures += 1
                    print("no data")

            for wf_file in sorted(extra_panel_wfs):
                print(f"  Fetching panel run: {wf_file} (any branch) ...", end=" ")
                run = fetch_workflow_run_any_branch(owner, repo, wf_file, token)
                total_calls += 1
                if run:
                    panel_data[wf_file] = {
                        "conclusion":  run.get("conclusion") or run.get("status") or "unknown",
                        "updated_at":  run.get("updated_at", ""),
                        "head_branch": run.get("head_branch", ""),
                    }
                    print(panel_data[wf_file]["conclusion"])
                else:
                    failures += 1
                    print("no data")

            if panel_data:
                proj_data["panel_workflows"] = panel_data

            if not proj.get("fixed_branch", False):
                print("  Fetching recent branches ...", end=" ")
                branches = fetch_recent_branches(owner, repo, token, max_branches)
                total_calls += 1
                proj_data["recent_branches"] = branches
                print(branches if branches else "(none found)")

            baked_projects[pid] = proj_data

    except RuntimeError as exc:
        print(f"\nERROR: {exc}", file=sys.stderr)
        return None

    print(f"\nTotal API calls attempted: {total_calls}")

    payload = {
        "baked_at": datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ"),
        "projects": baked_projects,
    }

    if failures:
        print(f"\nWARNING: {failures} fetch(es) failed — baked data may be incomplete.",
              file=sys.stderr)

    return payload


# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------

def main() -> int:
    """Load config and assets, optionally bake CI data, write dashboard HTML.

    Reads ``CONFIG_PATH``, inlines CSS/JS/template, optionally calls
    ``bake_ci_data`` when ``GITHUB_TOKEN`` is set, renders with Jinja2, and
    writes to ``DASHBOARD_OUT`` or ``DEFAULT_OUT``.

    Returns
    -------
    int
        0 on success, 1 if baking was requested but failed.

    """
    # ── Load config ────────────────────────────────────────────────────
    print(f"Config : {CONFIG_PATH}")
    with open(CONFIG_PATH, encoding="utf-8") as fh:
        config = yaml.safe_load(fh)

    # ── Load source files ──────────────────────────────────────────────
    with open(CSS_PATH, encoding="utf-8") as fh:
        css_content = fh.read()
    with open(JS_PATH, encoding="utf-8") as fh:
        js_engine = fh.read()
    with open(TEMPLATE_PATH, encoding="utf-8") as fh:
        template_str = fh.read()

    print(f"CSS    : {CSS_PATH} ({len(css_content)} bytes)")
    print(f"JS     : {JS_PATH} ({len(js_engine)} bytes)")
    print(f"Templ  : {TEMPLATE_PATH}")

    # ── Bake CI data (if token available) ──────────────────────────────
    token = os.environ.get("GITHUB_TOKEN", "")
    prefetched = None
    if token:
        print("\nGITHUB_TOKEN found — baking CI data...")
        prefetched = bake_ci_data(config, token)
        if prefetched is None:
            print("ERROR: Bake failed.", file=sys.stderr)
            return 1
    else:
        print("\nNo GITHUB_TOKEN — skipping bake (live mode).")

    # ── Generate JS config ─────────────────────────────────────────────
    js_config = generate_js_config(config, prefetched)
    full_js = js_config + "\n\n" + js_engine

    # ── Render template ────────────────────────────────────────────────
    dashboard = config.get("dashboard", {})
    default_theme = dashboard.get("default_theme", "light")

    # Indent CSS for clean output inside <style> tags
    css_indented = textwrap.indent(css_content, "    ")

    env = Environment(autoescape=False)
    template = env.from_string(template_str)
    html = template.render(
        css=css_indented,
        js=full_js,
        default_theme=default_theme,
    )

    # ── Write output ───────────────────────────────────────────────────
    out_path = os.environ.get("DASHBOARD_OUT", DEFAULT_OUT)
    out_path = os.path.normpath(out_path)
    os.makedirs(os.path.dirname(out_path) or ".", exist_ok=True)

    with open(out_path, "w", encoding="utf-8") as fh:
        fh.write(html)

    print(f"\nOutput : {out_path} ({len(html)} bytes)")
    if prefetched:
        print(f"Snapshot: {prefetched['baked_at']}")
    else:
        print("Mode   : live (no baked data)")

    return 0


if __name__ == "__main__":
    sys.exit(main())
