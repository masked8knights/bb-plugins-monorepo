# bb-plugins-monorepo

Public monorepo of bb plugins — forked and created. pnpm workspace (`plugins/*`).

## Plugins

| Package | What | Upstream source |
|---|---|---|
| `plugins/bb-plugin-usage` | Usage dashboard plugin: logged-cost pricing, local-day buckets, cache savings, opencode skip-when-no-CLI, zero-token guard. | `masked8knights/bb-plugin-usage` (PR #20) → `MayankBansal12/bb-plugin-usage` |
| `plugins/bb-plugin-antigravity-acp` | agy/Antigravity provider: one model entry per family + a real reasoning-effort picker (low/medium/high), re-encoded into the full agy id at turn time. | `masked8knights/bb-plugin-antigravity-acp` (PR #1) → `nuchareviews-beep/bb-plugin-antigravity-acp` |
| `plugins/bb-plugin-prime-agent` | prime-agent provider whose shim passes `--continue` so bb thread restarts resume the session. | `masked8knights/bb-plugins` (PR #4) → `patleeman/bb-plugins` |

The vendored copies are snapshots of each plugin's current fixed state. Refresh
them from the upstream sources listed above to pick up newer changes.

## The fixes & setup

The machine-level fixes (bb-app Cursor-removal patch, unified skills, AGENTS.md,
prime-agent source patch, install + automation scripts) live in the **private**
`masked8knights/bb-fixes` repo — see that repo's README for how to apply them.