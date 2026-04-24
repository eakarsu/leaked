#!/bin/bash
# Start Claude Code from source
export PATH="$HOME/.bun/bin:$PATH"
export IS_DEMO=1

# Skip version check by setting a high version (already in preload.ts)

echo "Starting Claude Code from source..."
echo "Press Ctrl+C to exit"
echo ""

bun run entrypoints/cli.tsx "$@"
