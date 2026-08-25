---
name: init
description: Initialize agent context for this repository or task. Run this when starting a thread or task in an unfamiliar project to build a shared mental model before doing any work.
---

# /init — initialize context

Establish a shared understanding of the project before acting.

1. Read the repository layout: walk the top-level tree, then read the primary
   manifest/readme files (`README.md`, `package.json`, `pyproject.toml`,
   `go.mod`, `Cargo.toml`, etc.) appropriate to the stack.
2. Read `AGENTS.md` / `.bb/AGENTS.md` / `CLAUDE.md` and any `.bb/skills`
   relevant to the task. Follow the conventions there.
3. Identify the entry points, test commands, build/lint commands, and how the
   project runs locally. Record them.
4. State concisely: what the project is, the stack, how to build/test/run,
   and any constraints you found. Do not modify files during /init.

If the project is already known and the context is fresh, a short summary is
sufficient. Never fabricate facts about the repository — if something is
unclear, say so.