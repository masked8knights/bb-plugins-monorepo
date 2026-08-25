#!/usr/bin/env bash
# fork-pr-lifecycle — keep each fork's PR branch in sync with upstream until the
# PR merges, then delete the fork. Designed to run as a bb automation (script
# mode, e.g. --cron "0 * * * *").
#
# Config comes from the PRS env var (JSON array):
#   [ { "upstream": "owner/repo", "fork": "owner/repo", "pr": 20,
#       "head": "branch", "dir": "/abs/path/to/clone" }, ... ]
#
# On MERGED: deletes the fork. On OPEN: merges upstream's base branch into the
# PR head and pushes (additive, no force-push). On CLOSED: no action, reports.
set -uo pipefail

PRS="${PRS:-[]}"
report() { printf '%s\n' "$*"; }

process() {
  local upstream="$1" fork="$2" pr="$3" head="$4" dir="$5"
  local state base
  state="$(gh pr view "$pr" --repo "$upstream" --json state --jq .state 2>/dev/null || echo unknown)"
  case "$state" in
    MERGED)
      if gh repo delete "$fork" --yes >/dev/null 2>&1; then
        report "PR ${upstream}#${pr} merged → deleted fork ${fork}"
      else
        report "PR ${upstream}#${pr} merged but fork delete failed (need delete_repo scope)"
      fi
      ;;
    CLOSED)
      report "PR ${upstream}#${pr} closed without merge — no action"
      ;;
    OPEN)
      [ -d "$dir" ] || { report "PR ${upstream}#${pr} open but clone missing at $dir"; return; }
      base="$(gh pr view "$pr" --repo "$upstream" --json baseRefName --jq .baseRefName 2>/dev/null)"
      [ -n "$base" ] || { report "PR ${upstream}#${pr} open but baseRefName unknown"; return; }
      ( cd "$dir" || return
        git remote get-url upstream >/dev/null 2>&1 || git remote add upstream "https://github.com/$upstream.git"
        git fetch upstream "$base" >/dev/null 2>&1 || { report "PR ${upstream}#${pr}: fetch upstream/$base failed"; return; }
        git checkout "$head" >/dev/null 2>&1 || { report "PR ${upstream}#${pr}: head branch $head missing"; return; }
        if git merge-base --is-ancestor "upstream/$base" HEAD; then
          report "PR ${upstream}#${pr}: up to date with upstream ${base}"
        else
          if git merge "upstream/$base" -m "merge: sync with upstream ${base}" >/dev/null 2>&1 \
             && git push origin "$head" >/dev/null 2>&1; then
            report "PR ${upstream}#${pr}: synced ${head} with upstream ${base}"
          else
            report "PR ${upstream}#${pr}: merge/push failed (conflict?) — needs attention"
          fi
        fi )
      ;;
    *)
      report "PR ${upstream}#${pr}: state=${state} — no action"
      ;;
  esac
}

report "fork-pr-lifecycle run @ $(date -u +%FT%TZ)"
node -e 'const p=JSON.parse(process.env.PRS||"[]");for(const e of p){console.log([e.upstream||"",e.fork||"",e.pr||"",e.head||"",e.dir||""].join("\t"))}' \
  | while IFS=$'\t' read -r upstream fork pr head dir; do
      [ -n "$upstream" ] && [ -n "$fork" ] && [ -n "$pr" ] && process "$upstream" "$fork" "$pr" "$head" "$dir"
    done