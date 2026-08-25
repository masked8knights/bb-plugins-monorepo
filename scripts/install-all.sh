#!/usr/bin/env bash
# install-all — install every bb plugin package in this monorepo into bb.
set -euo pipefail
for dir in packages/bb-plugin-*; do
  [ -d "$dir" ] || continue
  if bb plugin list 2>/dev/null | grep -q "^${dir#packages/bb-plugin-}@"; then
    echo "already installed: ${dir#packages/}"
  else
    echo "installing: ${dir#packages/}"
    bb plugin install "$dir" --yes
  fi
done