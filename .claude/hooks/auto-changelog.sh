#!/usr/bin/env bash
# Unix adapter only. On Windows, registries must call Node — never ShellExecute this file:
#   node .agents/hooks/ba-kit-run.mjs changelog
set -euo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"
ROOT="$(cd "$HERE/../.." && pwd)"
if [ -f "$ROOT/.agents/hooks/ba-kit-run.mjs" ]; then
  exec node "$ROOT/.agents/hooks/ba-kit-run.mjs" changelog
fi
if [ -f "$HERE/ba-kit-run.mjs" ]; then
  exec node "$HERE/ba-kit-run.mjs" changelog
fi
echo "ba-kit-run.mjs not found; skip changelog" >&2
exit 0
