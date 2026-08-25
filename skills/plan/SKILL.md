---
name: plan
description: Produce a concrete implementation plan before writing code. Run this before substantial changes so the user can review and approve the approach first.
---

# /plan — implementation plan

Design before code. Do not edit files while producing the plan.

1. Restate the goal from the request. Resolve ambiguities by asking or by
   picking the least surprising interpretation and noting it.
2. Inspect the relevant code paths so the plan is grounded in the real
   structure (do not plan against guesses).
3. Write a plan with:
   - Steps, each with the files/functions it touches and why.
   - Anything risky or irreversible (migrations, deletions, API changes).
   - How you will verify each step (tests, typecheck, build, manual check).
4. Present the plan and wait for approval before implementing, unless the
   user asked you to proceed without confirmation.

Keep the plan tight and scannable. If the task is trivial, a one-liner plan
is fine.