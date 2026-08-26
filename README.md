# bb-plugins-monorepo

Public monorepo of bb plugins. Each `packages/bb-plugin-*` is a standard bb
plugin, installed with `bb plugin install <dir>` or built with `bb plugin build`.

## Packages

| Package | What | Source |
|---|---|---|
| `packages/bb-plugin-usage` | Usage dashboard plugin: logged-cost pricing, local-day buckets, cache savings, opencode skip-when-no-CLI, zero-token guard. | `MayankBansal12/bb-plugin-usage` |
| `packages/bb-plugin-antigravity-acp` | agy/Antigravity provider: one model entry per family + a real reasoning-effort picker (low/medium/high), re-encoded into the full agy id at turn time. | `nuchareviews-beep/bb-plugin-antigravity-acp` |
| `packages/bb-plugin-prime-agent` | prime-agent provider whose shim passes `--continue` so bb thread restarts resume the session. | `patleeman/bb-plugins` (`packages/bb-plugin-prime-agent`) |

Each package is a vendored snapshot refreshed by the `sync-plugins` automation:
while a fix PR is open it tracks the PR head on the fork; once the PR merges
upstream it re-sources from upstream's default branch and the fork is deleted.

## Layout

```
packages/bb-plugin-*/      the plugins (pnpm workspace)
scripts/install-all.sh     install every package into bb
AGENTS.md                  repo conventions
```

## Commands

```sh
pnpm install
pnpm build          # pnpm -r --if-present build
pnpm typecheck
./scripts/install-all.sh   # install every package into bb
```