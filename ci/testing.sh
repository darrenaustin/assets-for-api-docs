#!/bin/bash
set -e

# So that users can run this script from anywhere and it will work as expected.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null && pwd)"
REPO_DIR="$(dirname "$SCRIPT_DIR")"

if [[ -n "$CIRRUS_CI" ]]; then
  echo "Updating PATH."
  export PATH="$FLUTTER_DIR/bin:$FLUTTER_DIR/bin/cache/dart-sdk/bin:$PATH"
else
  echo "Updating packages."
  "$SCRIPT_DIR/pub_upgrade.sh"
fi

# Default to the first arg if SHARD isn't set, and to "test" if neither are set.
SHARD="${SHARD:-${1:-test}}"

if [[ "$SHARD" == "test" ]]; then
  echo "Running tests."
  (cd "$REPO_DIR/bin" && pub run test)
  (cd "$REPO_DIR/packages/diagram_capture" && flutter test)
fi
