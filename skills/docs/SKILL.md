---
name: docs
description: Create or update documentation for the current change or project area. Run this when a change affects public behavior, usage, or setup.
---

# /docs — documentation

Keep docs truthful and current.

1. Identify the docs that a change affects: README, man pages, `docs/`,
   example configs, setup/install notes, and the repo's AGENTS.md if behavior
   changed.
2. Update them to match the actual behavior. State commands and examples
   accurately; never document something that does not exist.
3. Keep changes minimal and consistent with the existing doc style. If a
   section is redundant or wrong, fix it rather than duplicating.
4. List what you changed and why.

Do not generate docs for its own sake; only touch docs that a real change
affects.