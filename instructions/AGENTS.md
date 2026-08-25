# Unified Agent Instructions (bb-wide)

This file is injected into **every** provider-backed thread on this machine
(opencode, Prime Agent, Antigravity, and any future provider). It is the
single source of truth for how agents behave here. Keep it short and
enforceable.

## Operating rules

1. **Follow bb's conventions first.** Prefer bb's curated skills and this
   file's rules over the agent's own built-in "best practices" when they
   conflict. bb is the orchestrator; the agent is the executor.
2. **Use the unified skill set.** Use `/init`, `/plan`, `/todos`, `/review`,
   `/test`, `/docs` (available in every bb thread) as the shared workflow.
   These are defined in bb's user skills (`~/.bb/skills`); do not reinvent
   them or rely on provider-specific equivalents.
3. **Keep native behavior, don't duplicate it.** Keep your native execution
   tools (file access, shell, terminal, MCP servers, your provider's own
   permission model) — they are how you actually do work. Do **not** load or
   invoke redundant copies of the same thing bb already provides (a second
   task tracker, a parallel plan file, another docs system). One workflow,
   one source of truth.
4. **Don't run agent-native "auto" behaviors that fight the thread.** No
   self-invoked cleanup, auto-install of skills/plugins into the repo, or
   background agents unless the user asks. Keep the repo clean of agent-owned
   artifacts.
5. **Concurrency etiquette.** Another agent may be working in the same
   workspace on a different bb thread. Before editing shared files:
   - Check for stale/moved files first (`git status`), and re-read before
     writing.
   - Lock nothing by convention alone — rely on bb's per-thread environments
     where available; otherwise make small, idempotent edits and verify.
   - Never clobber files another thread created. Prefer additive changes and
     ask when a destructive operation is unavoidable.
   - Treat concurrent writes as a real risk: when two threads must touch the
     same file, propose sequencing rather than racing.

## Project-specific rules

Add repo-level rules to `<workspace>/.bb/AGENTS.md` (tracked in git so fresh
worktrees inherit them). Project rules override this file's generic rules.

## Boundaries

This file intentionally does **not** disable your native tools or skills —
doing so would break how you work and is not what "unified" means here.
"Unified front" = one set of conventions, skills, and instructions that every
agent follows, not a shared sandbox. If you believe a rule here is
unachievable or unsafe in a given context, say so instead of silently
violating or silently refusing.