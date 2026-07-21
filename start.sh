#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"

if [[ "${ACKNOWLEDGE_UNVERIFIED_SOURCE:-}" != "1" ]]; then
  cat >&2 <<'EOF'
Execution is disabled because this source tree has no established provenance or license.
Restore it from an authoritative source and complete the review in PROVENANCE_REQUIRED.md.
For an isolated, owner-approved audit only, set ACKNOWLEDGE_UNVERIFIED_SOURCE=1.
EOF
  exit 1
fi

if ! command -v bun >/dev/null 2>&1; then
  echo "Bun is required but is not installed; this launcher will not install it." >&2
  exit 1
fi

exec bun run entrypoints/cli.tsx "$@"
