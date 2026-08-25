# bb-plugins-monorepo

Private monorepo holding every bb plugin and fix used on this machine, so the
scattered repos stay out of the way. pnpm workspace (`plugins/*`), plus the
non-plugin assets that make the setup reproducible.

## Layout

| Path | What |
|---|---|
| `plugins/bb-plugin-usage` | Usage dashboard plugin (logged-cost pricing, local-day buckets, cache savings, opencode skip-when-no-CLI). Source: `masked8knights/bb-plugin-usage` (PR #20) + `MayankBansal12/bb-plugin-usage`. |
| `plugins/bb-plugin-antigravity-acp` | agy/Antigravity provider: one model entry per family + a real reasoning-effort picker (low/medium/high), re-encoded into the full agy id at turn time. Source: `masked8knights/bb-plugin-antigravity-acp` (PR to `nuchareviews-beep/bb-plugin-antigravity-acp`). |
| `plugins/bb-plugin-prime-agent` | prime-agent provider whose shim passes `--continue` so bb thread restarts resume the session. Source: `masked8knights/bb-plugins` (PR to `patleeman/bb-plugins`). |
| `patches/bb-app-provider-acp-remove-cursor.patch` | bb-app 0.39.x patch: drops the Cursor provider while keeping the ACP tier alive for opencode + prime-agent. |
| `prime-agent/acp-fixes.patch`, `prime-agent/pa-acp.sh` | Optional prime-agent *source* slash-command patch + reference shim (from the retired `bb-fixes` repo). |
| `skills/*/SKILL.md` | Unified bb skills → `/init /plan /todos /review /test /docs` in every thread/provider. |
| `instructions/AGENTS.md` | Unified, bb-wide agent instructions (copy to `~/.bb/AGENTS.md`). |
| `scripts/install.sh` | Idempotent installer: plugins → cursor patch → skills → AGENTS.md → verify. |
| `scripts/fork-pr-lifecycle.sh` | bb automation script: sync each fork's PR branch with upstream until merged, then delete the fork. |
| `scripts/update-all.sh` | bb automation script: update plugins, provider CLIs in use (opencode/agy/prime-agent), skills, and bb-app (guarded). |

## Install

```sh
./scripts/install.sh            # add --force to overwrite existing skills/AGENTS.md
```

## bb automations (both registered on this machine)

### fork-pr-lifecycle (hourly)
Keeps the PR branches synced with upstream until upstream merges, then deletes
the fork. Configured via the `PRS` env (JSON array) — currently:
`bb-plugin-usage` PR #20, `bb-plugin-antigravity-acp` PR, `bb-plugins` PR.

### update-all (daily)
Updates bb plugins (`bb plugin update --all`), the CLIs in use
(`opencode upgrade`, `agy update`, `prime-agent update`), resyncs the unified
skills from this repo, and upgrades bb-app itself when a newer version exists
(detached + guarded so the running server restarts cleanly).

Deliberately does **not** run `bb updates apply`, which would install the
Codex and Claude Code CLIs that are intentionally disabled here.

## Notes / known limits

- The Cursor-removal patch lives in bb-app's node_modules — re-run
  `install.sh` after any `npm i -g bb-app`.
- Vendored plugins are snapshots; refresh from their upstream repos for newer
  fixes. Sources are listed above.
- `prime-agent/acp-fixes.patch` is source-only and optional.
- Deleting the retired `bb-fixes` repo requires a `delete_repo`-scoped GitHub
  token (`gh auth refresh -h github.com -s delete_repo`).