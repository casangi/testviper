#!/usr/bin/env bash
set -euo pipefail

# Fetch and checkout VIPER component repos at desired refs.
# Usage examples:
#   scripts/sync_components.sh                       # all at main
#   scripts/sync_components.sh --all feature/foo     # set same ref for all
#   scripts/sync_components.sh --xradio dev --graphviper v0.3.1 --astroviper abcd123
#   scripts/sync_components.sh --comp-dir external   # specify clone directory
#
# Supported flags:
#   --all <ref>
#   --xradio <ref>
#   --graphviper <ref>
#   --astroviper <ref>
#   --toolviper <ref>
#   --comp-dir <path>            # default: external

BASE_URL="https://github.com/casangi"
COMP_DIR="external"

ALL_REF=""
XRADIO_REF=""
GRAPHVIPER_REF=""
ASTROVIPER_REF=""
TOOLVIPER_REF=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --all)
      ALL_REF="$2"; shift 2 ;;
    --xradio)
      XRADIO_REF="$2"; shift 2 ;;
    --graphviper)
      GRAPHVIPER_REF="$2"; shift 2 ;;
    --astroviper)
      ASTROVIPER_REF="$2"; shift 2 ;;
    --toolviper)
      TOOLVIPER_REF="$2"; shift 2 ;;
    --comp-dir)
      COMP_DIR="$2"; shift 2 ;;
    --help|-h)
      echo "Usage: $0 [--comp-dir DIR] [--all REF] [--xradio REF] [--graphviper REF] [--astroviper REF] [--toolviper REF]"; exit 0 ;;
    *)
      echo "Unknown argument: $1" >&2; exit 2 ;;
  esac
done

mkdir -p "$COMP_DIR"

sync_repo() {
  local name="$1" ref="$2"
  local url="$BASE_URL/$name.git"
  local dir="$COMP_DIR/$name"

  if [ ! -d "$dir/.git" ]; then
    git clone --origin origin "$url" "$dir"
  fi

  git -C "$dir" fetch origin --tags --prune

  # Resolve desired ref: prefer component-specific, else ALL_REF, else main
  local desired_ref
  desired_ref="${ref:-${ALL_REF:-main}}"

  # Try origin/<ref> first (branch), then tag/commit directly
  if git -C "$dir" rev-parse --verify --quiet "origin/$desired_ref" >/dev/null; then
    git -C "$dir" checkout -q --recurse-submodules "origin/$desired_ref"
  else
    git -C "$dir" checkout -q --recurse-submodules "$desired_ref" || {
      echo "Failed to checkout ref '$desired_ref' for $name" >&2
      exit 3
    }
  fi

  # Initialize/update submodules if any
  if [ -f "$dir/.gitmodules" ]; then
    git -C "$dir" submodule update --init --recursive
  fi

  # Print final state
  printf "%s -> %s @ %s\n" "$name" "$desired_ref" "$(git -C "$dir" rev-parse --short HEAD)"
}

sync_repo xradio      "$XRADIO_REF"
sync_repo graphviper  "$GRAPHVIPER_REF"
sync_repo astroviper  "$ASTROVIPER_REF"
sync_repo toolviper   "$TOOLVIPER_REF"
