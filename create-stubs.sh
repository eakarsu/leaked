#!/bin/bash
# Create stub modules for internal Anthropic packages

create_stub() {
  local dir="node_modules/$1"
  mkdir -p "$dir"

  cat > "$dir/package.json" << 'PKGJSON'
{ "name": "$1", "version": "0.0.0", "main": "index.js", "type": "module" }
PKGJSON

  cat > "$dir/index.js" << 'STUBJS'
// Stub module - not available outside Anthropic
export const BROWSER_TOOLS = [];
export const buildComputerUseTools = () => [];
export const bindSessionContext = () => ({});
export const DEFAULT_GRANT_FLAGS = {};
export const getSentinelCategory = () => null;
export const API_RESIZE_PARAMS = {};
export const targetImageSize = () => ({});
export default {};
STUBJS
}

# Internal Anthropic packages
create_stub "@ant/claude-for-chrome-mcp"
create_stub "@ant/computer-use-mcp"
create_stub "@ant/computer-use-swift"
create_stub "@ant/computer-use-input"
create_stub "@anthropic-ai/claude-agent-sdk"
create_stub "@anthropic-ai/sandbox-runtime"
create_stub "@anthropic-ai/mcpb"

# Create subpath exports for computer-use-mcp
for subpath in types sentinelApps; do
  mkdir -p "node_modules/@ant/computer-use-mcp/$subpath"
  cat > "node_modules/@ant/computer-use-mcp/$subpath/index.js" << 'STUBJS'
export const DEFAULT_GRANT_FLAGS = {};
export const getSentinelCategory = () => null;
export default {};
STUBJS
done

echo "Stubs created successfully."
