// Preload shim for bun:bundle feature() and MACRO globals
// This makes the source code runnable without the full Anthropic build pipeline

// Define MACRO as a global (normally inlined at build time)
declare global {
  var MACRO: {
    VERSION: string
    BUILD_TIME: string
    ISSUES_EXPLAINER: string
    FEEDBACK_CHANNEL: string
  }
}

globalThis.MACRO = {
  VERSION: '2.0.0',
  BUILD_TIME: new Date().toISOString(),
  ISSUES_EXPLAINER: 'report the issue at https://github.com/anthropics/claude-code/issues',
  FEEDBACK_CHANNEL: '#claude-code-feedback',
}
