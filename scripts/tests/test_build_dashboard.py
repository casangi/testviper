#!/usr/bin/env python3
"""
Tests for the dashboard build pipeline.

Run with:  pytest scripts/tests/test_build_dashboard.py -v

These tests validate:
  1. Source file integrity (all inputs exist and are non-empty)
  2. YAML config structure (required fields, no duplicates, valid types)
  3. JS config generation (all constants present, correct structure)
  4. Full build output (valid HTML, inlined assets, no unresolved templates)
  5. Baked data structure (contract compliance with mocked API)
  6. Config-to-output consistency (every project in YAML appears in output)
"""

import json
import os
import re
import sys
import tempfile
from unittest import mock

import pytest
import yaml

SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
SCRIPTS_DIR = os.path.dirname(SCRIPT_DIR)
REPO_ROOT = os.path.normpath(os.path.join(SCRIPTS_DIR, ".."))

sys.path.insert(0, SCRIPTS_DIR)
import build_dashboard  # noqa: E402


# ── Fixtures ──────────────────────────────────────────────────────────────

@pytest.fixture(scope="session")
def config():
    with open(build_dashboard.CONFIG_PATH, encoding="utf-8") as fh:
        return yaml.safe_load(fh)


@pytest.fixture(scope="session")
def built_html():
    """Run a full build (no baking) and return the output HTML."""
    with tempfile.NamedTemporaryFile(suffix=".html", delete=False) as tmp:
        tmp_path = tmp.name
    try:
        with mock.patch.dict(os.environ, {"DASHBOARD_OUT": tmp_path}, clear=False):
            with mock.patch.dict(os.environ, {"GITHUB_TOKEN": ""}, clear=False):
                rc = build_dashboard.main()
        assert rc == 0, f"build_dashboard.main() returned {rc}"
        with open(tmp_path, encoding="utf-8") as fh:
            return fh.read()
    finally:
        if os.path.exists(tmp_path):
            os.unlink(tmp_path)


# ═══════════════════════════════════════════════════════════════════════════
# 1. Source file integrity
# ═══════════════════════════════════════════════════════════════════════════

class TestSourceFiles:
    """All source files required by the build must exist and be non-empty."""

    @pytest.mark.parametrize("path,label", [
        (build_dashboard.CONFIG_PATH,   "projects.yaml"),
        (build_dashboard.TEMPLATE_PATH, "base.html"),
        (build_dashboard.CSS_PATH,      "style.css"),
        (build_dashboard.JS_PATH,       "app.js"),
    ])
    def test_source_file_exists_and_nonempty(self, path, label):
        assert os.path.isfile(path), f"{label} not found at {path}"
        assert os.path.getsize(path) > 0, f"{label} is empty"

    def test_worker_js_exists(self):
        worker_path = os.path.join(REPO_ROOT, "ci", "cloudflare", "worker.js")
        assert os.path.isfile(worker_path), "worker.js not found"


# ═══════════════════════════════════════════════════════════════════════════
# 2. YAML config validation
# ═══════════════════════════════════════════════════════════════════════════

class TestConfigValidation:

    def test_has_dashboard_section(self, config):
        assert "dashboard" in config
        dash = config["dashboard"]
        assert "title" in dash
        assert "default_theme" in dash
        assert dash["default_theme"] in ("dark", "light", "slate", "system")

    def test_has_themes(self, config):
        assert "themes" in config
        assert len(config["themes"]) >= 1

    def test_has_projects(self, config):
        assert "projects" in config
        assert len(config["projects"]) >= 1

    def test_no_duplicate_project_ids(self, config):
        ids = [p["id"] for p in config["projects"]]
        assert len(ids) == len(set(ids)), f"Duplicate project ids: {ids}"

    @pytest.mark.parametrize("field", ["id", "name", "owner", "repo"])
    def test_project_required_fields(self, config, field):
        for proj in config["projects"]:
            assert field in proj, f"Project missing '{field}': {proj.get('id', '?')}"
            assert proj[field], f"Project '{field}' is empty: {proj.get('id', '?')}"

    def test_every_project_has_overview_workflows(self, config):
        for proj in config["projects"]:
            wfs = proj.get("overview_workflows", [])
            assert len(wfs) >= 1, (
                f"Project '{proj['id']}' has no overview_workflows"
            )
            for wf in wfs:
                assert "file" in wf, f"Workflow missing 'file' in {proj['id']}"
                assert "label" in wf, f"Workflow missing 'label' in {proj['id']}"

    def test_every_project_has_categories(self, config):
        for proj in config["projects"]:
            cats = proj.get("categories", [])
            assert len(cats) >= 1, f"Project '{proj['id']}' has no categories"

    def test_no_duplicate_category_ids_per_project(self, config):
        for proj in config["projects"]:
            cat_ids = [c["id"] for c in proj.get("categories", [])]
            assert len(cat_ids) == len(set(cat_ids)), (
                f"Duplicate category ids in '{proj['id']}': {cat_ids}"
            )

    VALID_TYPES = {"ci", "report", "bench", "coverage", "docs", "repo", "custom"}

    def test_category_types_are_valid(self, config):
        for proj in config["projects"]:
            for cat in proj.get("categories", []):
                assert cat["type"] in self.VALID_TYPES, (
                    f"Invalid type '{cat['type']}' in {proj['id']}/{cat['id']}"
                )

    def test_ci_categories_have_workflows(self, config):
        for proj in config["projects"]:
            for cat in proj.get("categories", []):
                if cat["type"] == "ci":
                    wfs = cat.get("workflows", [])
                    assert len(wfs) >= 1, (
                        f"CI category in '{proj['id']}' has no workflows"
                    )

    def test_coverage_categories_have_codecov(self, config):
        for proj in config["projects"]:
            for cat in proj.get("categories", []):
                if cat["type"] == "coverage":
                    assert "codecov" in cat, (
                        f"Coverage category in '{proj['id']}' missing 'codecov'"
                    )
                    cc = cat["codecov"]
                    for key in ("service", "owner", "repo"):
                        assert key in cc, (
                            f"codecov.{key} missing in {proj['id']}/coverage"
                        )


# ═══════════════════════════════════════════════════════════════════════════
# 3. JS config generation
# ═══════════════════════════════════════════════════════════════════════════

class TestJsConfigGeneration:

    def test_generate_js_config_no_bake(self, config):
        js = build_dashboard.generate_js_config(config, None)
        assert "const PROJECTS =" in js
        assert "const LANDING_TITLE =" in js
        assert "const LAUNCH_PANEL_TYPES =" in js
        assert "const LAUNCH_PANEL_URLS =" in js
        assert "const DEFAULT_THEME =" in js
        assert "const THEME_LABELS =" in js
        assert "const WORKER_URL =" in js
        assert "const MAX_RECENT_BRANCHES =" in js
        assert "const PREFETCHED_CI_DATA = null;" in js
        assert "const CI_OVERVIEW_PROJECTS =" in js

    def test_generate_js_config_with_bake(self, config):
        fake_bake = {
            "baked_at": "2025-01-01T00:00:00Z",
            "projects": {"testviper": {"workflows": {}, "recent_branches": []}},
        }
        js = build_dashboard.generate_js_config(config, fake_bake)
        assert "const PREFETCHED_CI_DATA =" in js
        assert "PREFETCHED_CI_DATA = null" not in js
        assert "2025-01-01T00:00:00Z" in js

    def test_projects_array_matches_config(self, config):
        js = build_dashboard.generate_js_config(config, None)
        match = re.search(r"const PROJECTS = (.+?);$", js, re.MULTILINE)
        assert match, "PROJECTS constant not found"
        projects_js = json.loads(match.group(1))
        yaml_ids = {p["id"] for p in config["projects"]}
        js_ids = {p["id"] for p in projects_js}
        assert yaml_ids == js_ids, f"Mismatch: YAML={yaml_ids}, JS={js_ids}"

    def test_ci_overview_matches_config(self, config):
        js = build_dashboard.generate_js_config(config, None)
        match = re.search(r"const CI_OVERVIEW_PROJECTS = (.+?);$", js, re.MULTILINE)
        assert match, "CI_OVERVIEW_PROJECTS constant not found"
        overview = json.loads(match.group(1))
        yaml_ids = {p["id"] for p in config["projects"]}
        overview_ids = {p["id"] for p in overview}
        assert yaml_ids == overview_ids

    def test_worker_url_from_config(self, config):
        js = build_dashboard.generate_js_config(config, None)
        expected_url = config.get("dashboard", {}).get("worker_url", "")
        assert f'const WORKER_URL = "{expected_url}"' in js

    def test_max_recent_branches_from_config(self, config):
        js = build_dashboard.generate_js_config(config, None)
        expected = config.get("dashboard", {}).get("max_recent_branches", 4)
        assert f"const MAX_RECENT_BRANCHES = {expected};" in js

    def test_yaml_categories_to_js_ci(self):
        proj = {
            "id": "test", "name": "Test", "owner": "org", "repo": "r",
            "categories": [{
                "id": "ci", "label": "CI", "type": "ci",
                "url": "https://example.com",
                "workflows": [{"file": "test.yml", "label": "Test"}],
            }],
        }
        cats = build_dashboard.yaml_categories_to_js(proj)
        assert len(cats) == 1
        assert cats[0]["github"] == {"owner": "org", "repo": "r"}
        assert cats[0]["workflows"] == [{"file": "test.yml", "label": "Test"}]

    def test_yaml_categories_to_js_coverage(self):
        proj = {
            "id": "test", "name": "Test", "owner": "org", "repo": "r",
            "categories": [{
                "id": "cov", "label": "Coverage", "type": "coverage",
                "url": "https://codecov.io/test",
                "codecov": {"service": "github", "owner": "org", "repo": "r"},
            }],
        }
        cats = build_dashboard.yaml_categories_to_js(proj)
        assert cats[0]["codecov"] == {"service": "github", "owner": "org", "repo": "r"}
        assert cats[0]["github"] == {"owner": "org", "repo": "r"}

    def test_yaml_categories_to_js_repo(self):
        proj = {
            "id": "test", "name": "Test", "owner": "org", "repo": "r",
            "categories": [{
                "id": "repo", "label": "Repo", "type": "repo",
                "url": "https://github.com/org/r",
            }],
        }
        cats = build_dashboard.yaml_categories_to_js(proj)
        assert "github" not in cats[0]
        assert "workflows" not in cats[0]


# ═══════════════════════════════════════════════════════════════════════════
# 4. Full build output validation
# ═══════════════════════════════════════════════════════════════════════════

class TestBuildOutput:

    def test_html_is_valid_document(self, built_html):
        assert built_html.startswith("<!DOCTYPE html>")
        assert "<html" in built_html
        assert "</html>" in built_html
        assert "<head>" in built_html
        assert "</head>" in built_html
        assert "<body>" in built_html
        assert "</body>" in built_html

    def test_css_is_inlined(self, built_html):
        assert "<style>" in built_html
        assert "box-sizing" in built_html, "CSS content not found in output"

    def test_js_is_inlined(self, built_html):
        assert "<script>" in built_html
        assert "function ghApiUrl" in built_html, "JS engine not found in output"

    def test_js_constants_present(self, built_html):
        for const in [
            "const PROJECTS =",
            "const LANDING_TITLE =",
            "const DEFAULT_THEME =",
            "const THEME_LABELS =",
            "const WORKER_URL =",
            "const MAX_RECENT_BRANCHES =",
            "const PREFETCHED_CI_DATA =",
            "const CI_OVERVIEW_PROJECTS =",
        ]:
            assert const in built_html, f"Missing JS constant: {const}"

    def test_no_unresolved_jinja_variables(self, built_html):
        unresolved = re.findall(r"\{\{.*?\}\}", built_html)
        assert not unresolved, f"Unresolved Jinja2 variables: {unresolved}"

    def test_theme_attribute_set(self, built_html):
        assert 'data-theme="light"' in built_html or 'data-theme="dark"' in built_html

    def test_key_html_elements_present(self, built_html):
        for element_id in [
            "projbar", "brand", "proj-tabs", "theme-switcher",
            "catbar", "cat-tabs",
            "landing", "hero-card", "ci-overview",
            "main-frame",
            "launch-panel",
            "coverage-panel",
            "ci-panel",
        ]:
            assert f'id="{element_id}"' in built_html, (
                f"Missing HTML element: #{element_id}"
            )

    def test_output_is_reasonably_sized(self, built_html):
        size_kb = len(built_html) / 1024
        assert size_kb > 50, f"Output too small ({size_kb:.0f} KB) — likely broken"
        assert size_kb < 5000, f"Output too large ({size_kb:.0f} KB) — likely bloated"


# ═══════════════════════════════════════════════════════════════════════════
# 5. Baked data structure (mocked API)
# ═══════════════════════════════════════════════════════════════════════════

class TestBakeDataStructure:

    @staticmethod
    def _mock_gh_get(path, token):
        if "workflows" in path and "runs" in path:
            return {
                "workflow_runs": [{
                    "conclusion": "success",
                    "status": "completed",
                    "updated_at": "2025-06-01T12:00:00Z",
                    "head_branch": "main",
                    "name": "Test Workflow",
                }]
            }
        if "actions/runs" in path:
            return {
                "workflow_runs": [
                    {"head_branch": "feature-a"},
                    {"head_branch": "main"},
                    {"head_branch": "feature-b"},
                    {"head_branch": "feature-a"},
                ]
            }
        return {}

    def test_bake_returns_valid_structure(self, config):
        with mock.patch.object(build_dashboard, "_gh_get", side_effect=self._mock_gh_get):
            result = build_dashboard.bake_ci_data(config, "fake-token")

        assert result is not None
        assert "baked_at" in result
        assert "projects" in result

        for proj in config["projects"]:
            pid = proj["id"]
            assert pid in result["projects"], f"Missing project '{pid}' in baked data"
            proj_data = result["projects"][pid]
            assert "workflows" in proj_data

            for wf in proj.get("overview_workflows", []):
                wf_file = wf["file"]
                assert wf_file in proj_data["workflows"], (
                    f"Missing workflow '{wf_file}' in baked data for '{pid}'"
                )
                wf_data = proj_data["workflows"][wf_file]
                assert "conclusion" in wf_data
                assert "updated_at" in wf_data

            if not proj.get("fixed_branch", False):
                assert "recent_branches" in proj_data

    def test_bake_panel_workflows_present(self, config):
        with mock.patch.object(build_dashboard, "_gh_get", side_effect=self._mock_gh_get):
            result = build_dashboard.bake_ci_data(config, "fake-token")

        assert result is not None
        for proj in config["projects"]:
            pid = proj["id"]
            ci_cats = [c for c in proj.get("categories", []) if c.get("type") == "ci"]
            panel_wfs = {wf["file"] for c in ci_cats for wf in c.get("workflows", [])}
            if not panel_wfs:
                continue
            proj_data = result["projects"][pid]
            assert "panel_workflows" in proj_data, (
                f"Missing panel_workflows in baked data for '{pid}'"
            )
            for wf_file in panel_wfs:
                assert wf_file in proj_data["panel_workflows"], (
                    f"Missing panel workflow '{wf_file}' in baked data for '{pid}'"
                )
                wf_data = proj_data["panel_workflows"][wf_file]
                assert "conclusion" in wf_data
                assert "updated_at" in wf_data
                assert "head_branch" in wf_data, (
                    f"Missing head_branch in panel workflow '{wf_file}' for '{pid}'"
                )

    def test_bake_recent_branches_excludes_main(self, config):
        with mock.patch.object(build_dashboard, "_gh_get", side_effect=self._mock_gh_get):
            result = build_dashboard.bake_ci_data(config, "fake-token")

        for proj in config["projects"]:
            if not proj.get("fixed_branch", False):
                branches = result["projects"][proj["id"]].get("recent_branches", [])
                assert "main" not in branches

    def test_bake_timestamp_is_iso8601(self, config):
        with mock.patch.object(build_dashboard, "_gh_get", side_effect=self._mock_gh_get):
            result = build_dashboard.bake_ci_data(config, "fake-token")

        assert re.match(
            r"\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}Z",
            result["baked_at"],
        )

    def test_bake_handles_api_failure_gracefully(self, config):
        def failing_gh_get(path, token):
            return {}

        with mock.patch.object(build_dashboard, "_gh_get", side_effect=failing_gh_get):
            result = build_dashboard.bake_ci_data(config, "fake-token")

        assert result is not None, "Bake should not return None on partial failures"
        assert "projects" in result

    def test_bake_returns_none_on_auth_failure(self, config):
        def auth_failure(path, token):
            raise RuntimeError("GitHub API error (HTTP 401)")

        with mock.patch.object(build_dashboard, "_gh_get", side_effect=auth_failure):
            result = build_dashboard.bake_ci_data(config, "fake-token")

        assert result is None


# ═══════════════════════════════════════════════════════════════════════════
# 6. API helper unit tests
# ═══════════════════════════════════════════════════════════════════════════

class TestApiHelpers:

    def test_fetch_workflow_run_returns_first_run(self):
        fake_run = {"conclusion": "success", "updated_at": "2025-01-01T00:00:00Z"}
        with mock.patch.object(
            build_dashboard, "_gh_get",
            return_value={"workflow_runs": [fake_run]},
        ):
            result = build_dashboard.fetch_workflow_run("org", "repo", "test.yml", "main", "tok")
        assert result == fake_run

    def test_fetch_workflow_run_returns_none_on_empty(self):
        with mock.patch.object(
            build_dashboard, "_gh_get",
            return_value={"workflow_runs": []},
        ):
            result = build_dashboard.fetch_workflow_run("org", "repo", "test.yml", "main", "tok")
        assert result is None

    def test_fetch_workflow_run_any_branch_returns_first_run(self):
        fake_run = {
            "conclusion": "success",
            "updated_at": "2025-01-01T00:00:00Z",
            "head_branch": "feature-x",
        }
        with mock.patch.object(
            build_dashboard, "_gh_get",
            return_value={"workflow_runs": [fake_run]},
        ):
            result = build_dashboard.fetch_workflow_run_any_branch("org", "repo", "test.yml", "tok")
        assert result == fake_run

    def test_fetch_workflow_run_any_branch_returns_none_on_empty(self):
        with mock.patch.object(
            build_dashboard, "_gh_get",
            return_value={"workflow_runs": []},
        ):
            result = build_dashboard.fetch_workflow_run_any_branch("org", "repo", "test.yml", "tok")
        assert result is None

    def test_fetch_workflow_run_any_branch_no_branch_param(self):
        """Verify the API path does not include a branch query parameter."""
        with mock.patch.object(build_dashboard, "_gh_get", return_value={"workflow_runs": []}) as m:
            build_dashboard.fetch_workflow_run_any_branch("org", "repo", "test.yml", "tok")
        called_path = m.call_args[0][0]
        assert "branch=" not in called_path

    def test_fetch_recent_branches_deduplicates(self):
        runs = [
            {"head_branch": "feat-a"},
            {"head_branch": "feat-a"},
            {"head_branch": "main"},
            {"head_branch": "feat-b"},
        ]
        with mock.patch.object(
            build_dashboard, "_gh_get",
            return_value={"workflow_runs": runs},
        ):
            result = build_dashboard.fetch_recent_branches("org", "repo", "tok", 5)
        assert result == ["feat-a", "feat-b"]

    def test_fetch_recent_branches_respects_limit(self):
        runs = [
            {"head_branch": f"branch-{i}"} for i in range(10)
        ]
        with mock.patch.object(
            build_dashboard, "_gh_get",
            return_value={"workflow_runs": runs},
        ):
            result = build_dashboard.fetch_recent_branches("org", "repo", "tok", 2)
        assert len(result) == 2


# ═══════════════════════════════════════════════════════════════════════════
# 7. Config-to-output consistency
# ═══════════════════════════════════════════════════════════════════════════

class TestConfigOutputConsistency:

    def test_all_project_ids_in_output(self, config, built_html):
        for proj in config["projects"]:
            assert f'"{proj["id"]}"' in built_html, (
                f"Project '{proj['id']}' not found in built output"
            )

    def test_all_workflow_files_in_output(self, config, built_html):
        for proj in config["projects"]:
            for wf in proj.get("overview_workflows", []):
                assert wf["file"] in built_html, (
                    f"Workflow '{wf['file']}' from {proj['id']} not in output"
                )

    def test_worker_url_in_output(self, config, built_html):
        url = config.get("dashboard", {}).get("worker_url", "")
        if url:
            assert url in built_html

    def test_theme_labels_in_output(self, config, built_html):
        for theme_id in config.get("themes", {}):
            assert f'"{theme_id}"' in built_html
