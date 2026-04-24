// Stub for internal Anthropic TungstenTool (tmux-based virtual terminal)
export const TungstenTool = {
  name: 'Tungsten',
  description: 'Internal tool - not available',
  async call() { return { output: 'Not available' } },
}

export function clearSessionsWithTungstenUsage() {}
export function resetInitializationState() {}
