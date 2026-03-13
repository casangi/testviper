#!/usr/bin/env python3
"""
bake_dashboard.py — Pre-bake CI status data into dashboard-live-index.html.

Fetches the latest GitHub Actions workflow run status (main branch) and
recently-active branch names for all five VIPER projects using an
authenticated GITHUB_TOKEN (5,000 requests/hour), then injects the data
as a PREFETCHED_CI_DATA JSON constant and the CI_OVERVIEW_PROJECTS config
array into the dashboard HTML file.

The resulting HTML renders the CI overview table instantly on page load
with zero browser API calls.  When a user selects a non-main branch from
the dropdown, the dashboard falls back to live API fetches as normal.

Usage (called by bake-dashboard.yml):
    GITHUB_TOKEN=<token> python scripts/bake_dashboard.py

Environment variables:
    GITHUB_TOKEN   Required. GitHub personal access token or Actions token.
    DASHBOARD_SRC  Optional. Path to the source HTML file.
                   Default: ci/html/dashboard-live-index.html
    DASHBOARD_OUT  Optional. Path to write the baked HTML file.
                   Default: same as DASHBOARD_SRC (in-place)
"""

import json
import os
import sys
import urllib.error
import urllib.request
from datetime import datetime, timezone


# ---------------------------------------------------------------------------
# Configuration — single source of truth for project/workflow config.
# CI_OVERVIEW_PROJECTS in dashboard-live-index.html is generated from this
# list at bake time and no longer needs to be maintained separately.
# ---------------------------------------------------------------------------

PROJECTS = [
    {
        "id":           "testviper",
        "owner":        "casangi",
        "repo":         "testviper",
        "fixed_branch": False,
        "workflows": [
            {"file": "integration_tests_linux.yml",    "label": "Branch Python Tests (Linux)"},
            {"file": "dispatch-receiver.yml",          "label": "Repository Dispatch Receiver"},
            {"file": "python-tests-allure-report.yml", "label": "Python Tests & Allure Reports"},
        ],
    },
    {
        "id":           "xradio",
        "owner":        "casangi",
        "repo":         "xradio",
        "fixed_branch": False,
        "workflows": [
            {"file": "python-testing-linux.yml", "label": "Python Tests (Linux)"},
            {"file": "python-testing-macos.yml", "label": "Python Tests (macOS)"},
        ],
    },
    {
        "id":           "astroviper",
        "owner":        "casangi",
        "repo":         "astroviper",
        "fixed_branch": False,
        "workflows": [
            {"file": "python-testing-linux.yml", "label": "Python Tests (Linux)"},
            {"file": "python-testing-macos.yml", "label": "Python Tests (macOS)"},
        ],
    },
    {
        "id":           "graphviper",
        "owner":        "casangi",
        "repo":         "graphviper",
        "fixed_branch": False,
        "workflows": [
            {"file": "python-testing-linux.yml", "label": "Python Tests (Linux)"},
            {"file": "python-testing-macos.yml", "label": "Python Tests (macOS)"},
        ],
    },
    {
        "id":           "toolviper",
        "owner":        "casangi",
        "repo":         "toolviper",
        "fixed_branch": False,
        "workflows": [
            {"file": "python-testing-linux.yml", "label": "Python Tests (Linux)"},
            {"file": "python-testing-macos.yml", "label": "Python Tests (macOS)"},
        ],
    },
]

# Exact strings in the HTML that mark injection points.
# Must match the lines written in dashboard-live-index.html exactly.
INJECTION_MARKER    = "const PREFETCHED_CI_DATA = null;"
INJECTION_MARKER_OV = "const CI_OVERVIEW_PROJECTS = null; /* INJECTED_BY_BAKE */"

BRANCH   = "main"
API_BASE = "https://api.github.com"


# ---------------------------------------------------------------------------
# GitHub API helpers
# ---------------------------------------------------------------------------

def _gh_get(path: str, token: str) -> dict:
    """Make an authenticated GET request to the GitHub REST API.

    Raises RuntimeError on authentication failures (HTTP 401/403) so the
    caller can abort immediately rather than continuing with an invalid token.
    Returns {} for other HTTP errors (transient failures, 404s, etc.).
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
        if exc.code == 401:
            raise RuntimeError(
                "Authentication failed (HTTP 401) — check GITHUB_TOKEN"
            ) from exc
        if exc.code == 403:
            raise RuntimeError(
                f"Access denied or rate limit exceeded (HTTP 403) for {url}"
            ) from exc
        print(f"  WARNING: HTTP {exc.code} for {url}", file=sys.stderr)
        return {}
    except Exception as exc:
        print(f"  WARNING: {exc} for {url}", file=sys.stderr)
        return {}


def fetch_workflow_run(owner: str, repo: str, workflow_file: str,
                       branch: str, token: str) -> dict | None:
    """Return the latest run entry for a workflow on a specific branch, or None."""
    path = (
        f"/repos/{owner}/{repo}/actions/workflows/{workflow_file}/runs"
        f"?branch={branch}&per_page=1"
    )
    data = _gh_get(path, token)
    runs = data.get("workflow_runs", [])
    return runs[0] if runs else None


def fetch_recent_branches(owner: str, repo: str, token: str,
                           max_branches: int = 2) -> list[str]:
    """Return up to max_branches non-main branch names recently active in CI."""
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
# Main
# ---------------------------------------------------------------------------

def main() -> int:
    token = os.environ.get("GITHUB_TOKEN", "")
    if not token:
        print("ERROR: GITHUB_TOKEN environment variable is not set.", file=sys.stderr)
        return 1

    src_path = os.environ.get(
        "DASHBOARD_SRC",
        os.path.join(os.path.dirname(__file__), "..", "ci", "html",
                     "dashboard-live-index.html"),
    )
    out_path = os.environ.get("DASHBOARD_OUT", src_path)

    src_path = os.path.normpath(src_path)
    out_path = os.path.normpath(out_path)

    print(f"Source : {src_path}")
    print(f"Output : {out_path}")

    # Verify the source file exists and contains both injection markers
    with open(src_path, encoding="utf-8") as fh:
        html = fh.read()

    for marker in (INJECTION_MARKER, INJECTION_MARKER_OV):
        if marker not in html:
            print(
                f"ERROR: injection marker not found in {src_path}.\n"
                f"Expected: {marker!r}",
                file=sys.stderr,
            )
            return 1

    # ------------------------------------------------------------------
    # Fetch CI data for all projects
    # ------------------------------------------------------------------
    baked_projects: dict = {}
    total_calls = 0
    failures    = 0

    try:
        for proj in PROJECTS:
            pid   = proj["id"]
            owner = proj["owner"]
            repo  = proj["repo"]
            print(f"\n[{pid}]")

            proj_data: dict = {"workflows": {}}

            # Workflow run status (main branch)
            for wf in proj["workflows"]:
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

            # Recent branch discovery (only for projects with a branch dropdown)
            if not proj["fixed_branch"]:
                print("  Fetching recent branches ...", end=" ")
                branches = fetch_recent_branches(owner, repo, token)
                total_calls += 1
                proj_data["recent_branches"] = branches
                print(branches if branches else "(none found)")

            baked_projects[pid] = proj_data

    except RuntimeError as exc:
        print(f"\nERROR: {exc}", file=sys.stderr)
        return 1

    print(f"\nTotal API calls attempted: {total_calls}")

    # ------------------------------------------------------------------
    # Build the JSON payloads and inject both constants
    # ------------------------------------------------------------------
    payload = {
        "baked_at": datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ"),
        "projects": baked_projects,
    }

    json_str    = json.dumps(payload, separators=(",", ":"))
    replacement = f"const PREFETCHED_CI_DATA = {json_str};"

    # Build CI_OVERVIEW_PROJECTS from the canonical PROJECTS list so the
    # HTML config is always in sync with what was fetched — no manual sync needed.
    ov_projects = [
        {
            "id":          p["id"],
            "fixedBranch": p["fixed_branch"],
            "workflows":   [{"file": wf["file"], "label": wf["label"]} for wf in p["workflows"]],
        }
        for p in PROJECTS
    ]
    ov_json_str    = json.dumps(ov_projects, separators=(",", ":"))
    ov_replacement = f"const CI_OVERVIEW_PROJECTS = {ov_json_str};"

    baked_html = html.replace(INJECTION_MARKER,    replacement,    1)
    baked_html = baked_html.replace(INJECTION_MARKER_OV, ov_replacement, 1)

    os.makedirs(os.path.dirname(out_path) or ".", exist_ok=True)
    with open(out_path, "w", encoding="utf-8") as fh:
        fh.write(baked_html)

    print(f"\nInjected PREFETCHED_CI_DATA    ({len(json_str)} bytes) into {out_path}")
    print(f"Injected CI_OVERVIEW_PROJECTS  ({len(ov_json_str)} bytes) into {out_path}")
    print(f"Snapshot timestamp: {payload['baked_at']}")

    if failures:
        print(f"\n⚠  {failures} fetch(es) failed — baked data may be incomplete.", file=sys.stderr)
        return 1

    return 0


if __name__ == "__main__":
    sys.exit(main())
