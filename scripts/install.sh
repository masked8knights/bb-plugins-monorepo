#!/usr/bin/env bash
# bb-fixes-bundle installer — idempotent, safe, single-machine.
#
# Installs/verifies every fix in this bundle:
#   1. the three fixed plugins (usage, antigravity-acp, prime-agent)
#   2. the bb-app provider-acp patch that removes Cursor (bb-app 0.39.x)
#   3. the unified user skills (/init /plan /todos /review /test /docs)
#   4. the unified AGENTS.md (~/.bb/AGENTS.md)
#
# Re-running is safe; nothing is overwritten unless --force is passed for the
# file copies (skills + AGENTS.md).
set -euo pipefail

BUNDLE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DATA_DIR="${BB_DATA_DIR:-$HOME/.bb}"
FORCE=0
[[ "${1:-}" == "--force" ]] && FORCE=1

say()  { printf '\033[1;32m==>\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m[warn]\033[0m %s\n' "$*"; }
fail() { printf '\033[1;31m[error]\033[0m %s\n' "$*"; exit 1; }

command -v bb >/dev/null 2>&1 || fail "bb CLI not found on PATH. Install bb-app first: npm i -g bb-app"
command -v bb-app >/dev/null 2>&1 || fail "bb-app not found on PATH."

BB_VERSION="$(bb --version 2>/dev/null || true)"
say "bb version: ${BB_VERSION:-unknown} (need 0.39.x)"

# ---------------------------------------------------------------- 1. plugins
say "Installing plugins…"
for plugin in bb-plugin-usage bb-plugin-antigravity-acp bb-plugin-prime-agent; do
  dir="$BUNDLE_DIR/plugins/$plugin"
  [[ -d "$dir" ]] || { warn "missing $dir — skipping"; continue; }
  if bb plugin list 2>/dev/null | grep -q "^${plugin#bb-plugin-}@"; then
    say "  $plugin already installed — skipping (re-run with --force to reinstall)"
    continue
  fi
  say "  installing $plugin from $dir"
  bb plugin install "$dir" --yes
done

# ------------------------------------------------- 2. bb-app cursor removal
say "Applying bb-app provider-acp Cursor-removal patch…"
CANDIDATES=(
  "$(npm root -g 2>/dev/null)/bb-app/server/dist/builtin-plugins/provider-acp/dist/server.js"
)
TARGET=""
for c in "${CANDIDATES[@]}"; do [[ -f "$c" ]] && TARGET="$c" && break; done
if [[ -z "$TARGET" ]]; then
  warn "Could not locate bb-app's provider-acp server.js (bb-app upgrade?). Skipping Cursor removal."
elif grep -q "acp-cursor removed" "$TARGET"; then
  say "  provider-acp already patched — skipping"
else
  cp "$TARGET" "$TARGET.bak-cursor"
  (cd "$(dirname "$TARGET")" && patch -p0 < "$BUNDLE_DIR/patches/bb-app-provider-acp-remove-cursor.patch") \
    || { warn "patch did not apply cleanly; restored original"; cp "$TARGET.bak-cursor" "$TARGET"; }
  grep -q "acp-cursor removed" "$TARGET" && say "  patched $(basename "$TARGET")"
fi

# ------------------------------------------------------------------ 3. skills
say "Installing unified skills into $DATA_DIR/skills…"
mkdir -p "$DATA_DIR/skills"
for skilldir in "$BUNDLE_DIR"/skills/*/; do
  name="$(basename "$skilldir")"
  target="$DATA_DIR/skills/$name"
  if [[ -d "$target" ]] && (( FORCE == 0 )); then
    say "  skill /$name already present — skipping (--force to overwrite)"
    continue
  fi
  mkdir -p "$target"
  cp "$skilldir/SKILL.md" "$target/SKILL.md"
  say "  wrote /$name → $target/SKILL.md"
done

# -------------------------------------------------------------- 4. AGENTS.md
AGENTS_TARGET="$DATA_DIR/AGENTS.md"
if [[ -f "$AGENTS_TARGET" ]] && (( FORCE == 0 )); then
  warn "  $AGENTS_TARGET already exists — leaving it (--force to replace with the bundle copy)"
else
  cp "$BUNDLE_DIR/instructions/AGENTS.md" "$AGENTS_TARGET"
  say "  wrote $AGENTS_TARGET"
fi

# --------------------------------------------------------------- 5. verify
say "Reloading config + verifying…"
bb-app config refresh >/dev/null 2>&1 || true
sleep 2
say "Providers:"
bb provider list
say "Skills:"
bb skill list 2>/dev/null | grep -E "init|plan|todos|review|test|docs" || true
say "Done. Open the dashboard at http://localhost:38886 (Usage tab)."