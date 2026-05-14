# Audit Note — leaked

## Bucket: JUNK-NAME — RECOMMEND ARCHIVE (large vendored tree)

## True state (verified 2026-05-06)
- Source files (.js .ts .tsx .jsx .py): **1,916**.
- LLM-reference scan: **867 files** match `openrouter|openai|anthropic|claude|chat/completions`.
- Sample matches: `history.ts`, `main.tsx`, `Tool.ts`, `commands.ts`, `dialogLaunchers.tsx`, `cost-tracker.ts`, plus large `bridge/`, `commands/`, `components/`, `hooks/` trees.
- Stack: Bun + TypeScript + Ink (terminal UI). Contains `bun.lock`, `bunfig.toml`, `claud.key` artifact.
- Presence of `.gitleaksignore` and the project name "leaked" strongly suggests this is a **leaked / decompiled / extracted snapshot of someone else's CLI tool**, not original work.

## Original audit reference
Per `_AUDIT/reports/batch_10.md` §23: "Unclear (possibly data breach / leak detection). … Boilerplate Node app. Verdict: SKELETON. Node boilerplate, no routes."
Note: the audit-time TSV undercounted code dramatically — the tree is in fact dense, but it appears to be a republished third-party codebase rather than a green-field product.

## Decision
"leaked" is one of the explicit junk-name examples in the apply guidance. Beyond the naming signal, the contents (claud.key file, gitleaks ignore, very large vendored TS tree with anthropic SDK references) are red flags for leaked third-party code. Adding Express + ai.js scaffolding here would be both meaningless (already AI-wired) and inadvisable (extends content of unclear provenance).

## Files with LLM references (false-positive scope)
867 files — full list available via:
`find /Users/erolakarsu/projects/leaked -type f \( -name "*.ts" -o -name "*.tsx" -o -name "*.js" \) | xargs grep -lEi "openrouter|openai|anthropic|claude|chat/completions"`

## Recommendation
**Archive offline and remove from active project tree.** Investigate provenance of `claud.key` and the bundled CLI before any further use. Do not scaffold.

## Action taken in this batch
None. No code changes. This note only.
