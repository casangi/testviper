#!/usr/bin/env bash
set -eEo pipefail

exit_trap() {
    echo "Exiting with status code $?"
}

error_handler() {
    local exit_code=$?
    local line_number=$1
    echo "[ERROR] Command failed with exit code $exit_code at line $line_number" >&2
}

trap 'error_handler $LINENO' ERR
trap exit_trap EXIT SIGINT SIGTERM

usage() {
    echo "Run tests for the given TestViper component and publish results"
    echo "to ReportPortal"
    echo ""
    echo "Usage: $0 COMPONENT_NAME BASE_PATH TESTS_PATH"
    echo ""
    echo "  COMPONENT_NAME      The name of the component"
    echo ""
    echo "  BASE_PATH           The path to the root of the component, relative"
    echo "                       to TestViper's root"
    echo ""
    echo "  TESTS_PATH          The path to the component tests, relative to"
    echo "                       BASE_PATH"
}

SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
ROOT_DIR="$( cd -- "${SCRIPT_DIR}/.."  &> /dev/null && pwd )"
cd "$ROOT_DIR"

COMPONENT_NAME="${1:-}"
if [ -z "$COMPONENT_NAME" ]
then
    echo "ERROR: Missing COMPONENT_NAME parameter"
    usage
    exit 1
fi

BASE_PATH="${2:-}"
if [ -z "$BASE_PATH" ]
then
    echo "ERROR: Missing BASE_PATH parameter"
    usage
    exit 1
fi

TESTS_PATH="${3:-}"
if [ -z "$TESTS_PATH" ]
then
    echo "ERROR: Missing TESTS_PATH parameter"
    usage
    exit 1
fi

FULL_TEST_PATH="${BASE_PATH}/${TESTS_PATH}"
if [ ! -d "$FULL_TEST_PATH" ]
then
    echo "Test path $FULL_TEST_PATH does not exist for $COMPONENT_NAME!"
    exit 1
fi

PYTHON_VERSION="$(python --version | awk '{print $2}')"
COMPONENT_VERSION="$(python ./scripts/read_version.py "${BASE_PATH}")"

echo "+-------------------------------------------------------------------------"
echo "| Running tests for $COMPONENT_NAME $COMPONENT_VERSION"
echo "| Python: $PYTHON_VERSION"
echo "+-------------------------------------------------------------------------"
echo "| TV_SOURCE_REPO: $TV_SOURCE_REPO"
echo "| TV_SOURCE_REF: $TV_SOURCE_REF"
echo "| TV_SOURCE_SHA: $TV_SOURCE_SHA"
echo "| TV_SOURCE_ACTOR: $TV_SOURCE_ACTOR"
echo "| TV_SOURCE_WORKFLOW: $TV_SOURCE_WORKFLOW"
echo "| TV_SOURCE_RUN_ID: $TV_SOURCE_RUN_ID"
echo "| TV_SOURCE_RUN_NUMBER: $TV_SOURCE_RUN_NUMBER"
echo "| TV_TRIGGERED_BY: $TV_TRIGGERED_BY"
echo "| GITHUB_SHA: $GITHUB_SHA"
echo "| GITHUB_REF_NAME: $GITHUB_REF_NAME"
echo "| GITHUB_RUN_ID: $GITHUB_RUN_ID"
echo "| RUNNER_ARCH: $RUNNER_ARCH"
echo "| RUNNER_OS: $RUNNER_OS"
echo "| GITHUB_EVENT_NAME: $GITHUB_EVENT_NAME"
echo "+-------------------------------------------------------------------------"

## Build launch attributes string
LAUNCH_ATTRIBUTES="'pytest' 'python:${PYTHON_VERSION}' 'component:${COMPONENT_NAME}' 'version:${COMPONENT_VERSION}'"

[[ -n "$GITHUB_SHA" ]] && LAUNCH_ATTRIBUTES+=" 'testviper_sha:${GITHUB_SHA}'"
[[ -n "$GITHUB_REF_NAME" ]] && LAUNCH_ATTRIBUTES+=" 'testviper_ref:${GITHUB_REF_NAME}'"
[[ -n "$GITHUB_RUN_ID" ]] && LAUNCH_ATTRIBUTES+=" 'run_id:${GITHUB_RUN_ID}'"
[[ -n "$RUNNER_ARCH" ]] && LAUNCH_ATTRIBUTES+=" 'arch:${RUNNER_ARCH}'"
[[ -n "$RUNNER_OS" ]] && LAUNCH_ATTRIBUTES+=" 'os:${RUNNER_OS}'"
[[ -n "$GITHUB_EVENT_NAME" ]] && LAUNCH_ATTRIBUTES+=" 'event_name:${GITHUB_EVENT_NAME}'"

[[ -n "$TV_SOURCE_REPO" ]] && LAUNCH_ATTRIBUTES+=" 'source_repo:${TV_SOURCE_REPO}'"
[[ -n "$TV_SOURCE_REF" ]] && LAUNCH_ATTRIBUTES+=" 'source_ref:${TV_SOURCE_REF}'"
[[ -n "$TV_SOURCE_SHA" ]] && LAUNCH_ATTRIBUTES+=" 'source_sha:${TV_SOURCE_SHA}'"
[[ -n "$TV_SOURCE_ACTOR" ]] && LAUNCH_ATTRIBUTES+=" 'source_actor:${TV_SOURCE_ACTOR}'"
[[ -n "$TV_SOURCE_WORKFLOW" ]] && LAUNCH_ATTRIBUTES+=" 'source_workflow:${TV_SOURCE_WORKFLOW}'"
[[ -n "$TV_SOURCE_RUN_ID" ]] && LAUNCH_ATTRIBUTES+=" 'source_run_id:${TV_SOURCE_RUN_ID}'"
[[ -n "$TV_SOURCE_RUN_NUMBER" ]] && LAUNCH_ATTRIBUTES+=" 'source_run_number:${TV_SOURCE_RUN_NUMBER}'"
[[ -n "$TV_TRIGGERED_BY" ]] && LAUNCH_ATTRIBUTES+=" 'triggered_by:${TV_TRIGGERED_BY}'"

DEBUG=
if [[ -n "$RUNNER_DEBUG" ]]
then
    DEBUG="-v --log-cli-level=DEBUG"
fi

echo "+-------------------------------------------------------------------------"
echo "About to run:"
echo "python -m pytest $DEBUG \\"
echo "    --reportportal \\"
echo "    --rp-launch \"$COMPONENT_NAME $COMPONENT_VERSION\" \\"
echo "    -o \"rp_launch_attributes=${LAUNCH_ATTRIBUTES}\" \\"
echo "    $FULL_TEST_PATH"
echo "+-------------------------------------------------------------------------"

python -m pytest $DEBUG \
    --reportportal \
    -o "rp_endpoint=https://report-portal.nrao.casa" \
    -o "rp_project=testviper" \
    -o "rp_launch='Testviper'" \
    -o "rp_ignore_attributes='xfail' 'usefixture'" \
    -o "rp_verify_ssl=False" \
    -o "rp_launch_uuid_print=True" \
    -o "rp_api_retries=2" \
    --rp-launch "$COMPONENT_NAME $COMPONENT_VERSION" \
    -o "rp_launch_attributes=${LAUNCH_ATTRIBUTES}" \
    "${FULL_TEST_PATH}"
