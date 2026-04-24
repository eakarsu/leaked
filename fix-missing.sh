#!/bin/bash
# Iteratively find and stub missing modules
export PATH="$HOME/.bun/bin:$PATH"

MAX_ITERATIONS=50

for i in $(seq 1 $MAX_ITERATIONS); do
  OUTPUT=$(timeout 10 bun run entrypoints/cli.tsx --help 2>&1)

  # Check for success
  if echo "$OUTPUT" | grep -q "Usage:"; then
    echo "SUCCESS! CLI is working after $i iterations."
    echo "$OUTPUT"
    exit 0
  fi

  # Extract missing module
  MISSING=$(echo "$OUTPUT" | grep "Cannot find module" | head -1 | sed "s/.*Cannot find module '\([^']*\)'.*/\1/")
  FROMFILE=$(echo "$OUTPUT" | grep "Cannot find module" | head -1 | sed "s/.*from '\([^']*\)'.*/\1/")

  if [ -z "$MISSING" ]; then
    # Check for missing package
    MISSING_PKG=$(echo "$OUTPUT" | grep "Cannot find package" | head -1 | sed "s/.*Cannot find package '\([^']*\)'.*/\1/")
    if [ -n "$MISSING_PKG" ]; then
      echo "[$i] Missing package: $MISSING_PKG — installing..."
      bun add "$MISSING_PKG" 2>/dev/null || {
        echo "  Cannot install, creating stub..."
        PKGDIR="node_modules/$MISSING_PKG"
        mkdir -p "$PKGDIR"
        echo '{ "name": "'$MISSING_PKG'", "version": "0.0.0", "main": "index.js", "type": "module" }' > "$PKGDIR/package.json"
        echo 'export default {}' > "$PKGDIR/index.js"
      }
      continue
    fi

    echo "[$i] Unknown error:"
    echo "$OUTPUT" | tail -5
    exit 1
  fi

  echo "[$i] Missing module: $MISSING (from $FROMFILE)"

  # Resolve relative path
  if [[ "$MISSING" == ./* ]] || [[ "$MISSING" == ../* ]]; then
    FROMDIR=$(dirname "$FROMFILE")
    RESOLVED=$(cd "$FROMDIR" 2>/dev/null && realpath -m "$MISSING" 2>/dev/null || echo "$FROMDIR/$MISSING")
    # Remove .js extension and add .ts
    RESOLVED="${RESOLVED%.js}.ts"
  else
    # It's a package
    echo "  Installing package $MISSING..."
    bun add "$MISSING" 2>/dev/null || {
      echo "  Cannot install, creating stub..."
      PKGDIR="node_modules/$MISSING"
      mkdir -p "$PKGDIR"
      echo '{ "name": "'$MISSING'", "version": "0.0.0", "main": "index.js", "type": "module" }' > "$PKGDIR/package.json"
      echo 'export default {}' > "$PKGDIR/index.js"
    }
    continue
  fi

  echo "  Creating stub at: $RESOLVED"
  mkdir -p "$(dirname "$RESOLVED")"

  # Check if it's likely a tsx file
  if [[ "$MISSING" == *"Component"* ]] || [[ "$MISSING" == *"Monitor"* ]] || [[ "$MISSING" == *".tsx"* ]]; then
    RESOLVED="${RESOLVED%.ts}.tsx"
    cat > "$RESOLVED" << 'STUB'
import React from 'react'
export default function Stub() { return null }
export const stub = {}
STUB
  else
    cat > "$RESOLVED" << 'STUB'
// Auto-generated stub for missing module
export default {}
STUB
  fi
done

echo "Reached max iterations ($MAX_ITERATIONS) without success."
exit 1
