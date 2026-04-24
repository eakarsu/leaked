#!/usr/bin/env bun
// Debug launcher - traces where startup hangs

console.error('[0] Starting...')

import './preload.ts'

console.error('[1] Preload done, importing cli...')

const startTime = Date.now()

// Patch console.error to add timestamps
const origError = console.error
console.error = (...args: any[]) => {
  origError(`[${Date.now() - startTime}ms]`, ...args)
}

await import('./entrypoints/cli.js')
