#!/usr/bin/env bash
# update-all — updates everything bb manages on this machine:
#   1. bb plugins            (bb plugin update --all)
#   2. provider CLIs in use  (opencode / agy / prime-agent)
#   3. unified skills        (resync from the bb-plugins-monorepo checkout)
#   4. bb-app itself         (guarded, detached upgrade + restart when newer)
# Designed to run as a bb automation (script mode, e.g. --cron "0 3 * * *").
#
# Deliberately does NOT run `bb updates apply`, which installs the Codex and
# Claude Code CLIs (those providers are disabled here). Only the CLIs in use
# are touched.
set -uo pipefail

MONO_REPO_DIR="${MONO_REPO_DIR:-$HOME/bb-plugins-monorepo}"
report() { printf '%s\n' "$*"; }
report "bb update-all run @ $(date -u +%FT%TZ)"
command -v bb >/dev/null 2>&1 || { report "bb CLI not found"; exit 1; }
report "current bb: $(bb --version 2>/dev/null || echo unknown)"

# ---- 1. plugins ----
report "-- plugins --"
if bb plugin outdated --json 2>/dev/null | node -e 'let s="";process.stdin.on("data",d=>s+=d).on("end",()=>{try{const j=JSON.parse(s);const n=Array.isArray(j)?j.filter(p=>p.outcome&&p.outcome!=="current").length:0;console.log(n)}catch(e){console.log(0)}})' | grep -qv "^0$"; then
  bb plugin update --all --yes 2>&1 | grep -vE "^\s*$" | while read -r l; do report "  $l"; done
else
  report "  no plugin updates"
fi

# ---- 2. provider CLIs in use ----
report "-- provider CLIs --"
for bin in opencode agy prime-agent; do
  if command -v "$bin" >/dev/null 2>&1; then
    case "$bin" in
      opencode)   out="$("$bin" upgrade 2>&1 | tail -1)" ;;
      agy)        out="$("$bin" update 2>&1 | tail -1)" ;;
      prime-agent) out="$("$bin" update 2>&1 | tail -1)" ;;
    esac
    report "  $bin: ${out:-done}"
  else
    report "  $bin not installed — skipped"
  fi
done

# ---- 3. unified skills (resync from the monorepo) ----
report "-- skills --"
if [ -d "$MONO_REPO_DIR" ]; then
  ( cd "$MONO_REPO_DIR" && git pull --ff-only >/dev/null 2>&1 )
  mkdir -p "$HOME/.bb/skills"
  n=0
  for d in "$MONO_REPO_DIR"/skills/*/; do
    [ -d "$d" ] || continue
    name="$(basename "$d")"
    mkdir -p "$HOME/.bb/skills/$name"
    cp "$d/SKILL.md" "$HOME/.bb/skills/$name/SKILL.md"
    n=$((n+1))
  done
  report "  synced $n skills from $MONO_REPO_DIR"
else
  report "  monorepo not found at $MONO_REPO_DIR; skills unchanged"
fi

# ---- 4. system (bb-app) — guarded + detached, only when a newer version exists ----
report "-- system --"
if [ "${UPDATE_BB_APP:-1}" = "1" ]; then
  VER="$(bb settings version --json 2>/dev/null || true)"
  NEWER="$(printf '%s' "$VER" | node -e 'let s="";process.stdin.on("data",d=>s+=d).on("end",()=>{try{const j=JSON.parse(s);console.log(j.updateAvailable?String(j.latestVersion||"new"):"")}catch(e){console.log("")}})' 2>/dev/null || true)"
  if [ -n "$NEWER" ]; then
    report "  newer bb-app (${NEWER}) available — scheduling detached upgrade + restart in 30s"
    nohup bash -c 'sleep 30; npm i -g bb-app@latest && systemctl --user restart bb-app' >/dev/null 2>&1 &
  else
    report "  bb-app up to date"
  fi
else
  report "  bb-app auto-upgrade disabled (UPDATE_BB_APP!=1)"
fi

report "update-all finished"