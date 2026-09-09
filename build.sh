#!/usr/bin/env bash
# Generate project files with Premake and build with make.
# Usage:
#   ./build.sh [Debug|Release] [--cc=gcc|clang] [--verbose]
#   ./build.sh --help
set -euo pipefail

CONFIG="Debug"
CC_OPT=""
VERBOSE=0

for arg in "$@"; do
    case "$arg" in
        Debug|Release) CONFIG="$arg" ;;
        --cc=*) CC_OPT="$arg" ;;
        --verbose) VERBOSE=1 ;;
        -h|--help)
            sed -n '2,8p' "$0"
            exit 0
            ;;
        *) echo "Unknown argument: $arg" >&2; exit 1 ;;
    esac
done

command -v premake5 >/dev/null || {
    echo "Error: premake5 not found. See premake/README.md." >&2
    exit 1
}

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PREMAKE_DIR="$SCRIPT_DIR/premake"

echo "==> premake5 gmake (config=$CONFIG ${CC_OPT:-default cc})"
# shellcheck disable=SC2086
premake5 --file="$PREMAKE_DIR/premake5.lua" ${CC_OPT:-} gmake

echo "==> make config=${CONFIG,,}"
MAKE_ARGS=("config=${CONFIG,,}")
[ "$VERBOSE" -eq 1 ] && MAKE_ARGS+=("verbose=1")
make -C "$SCRIPT_DIR/build" "${MAKE_ARGS[@]}"

echo "Binaries under bin/<Project>_<...>/<Config>/"
