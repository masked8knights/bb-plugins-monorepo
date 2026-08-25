---
name: test
description: Write and/or run tests for the current change. Run this when a change needs verification that its tests pass, or when a change should add tests.
---

# /test — verify with tests

Make the change provable.

1. Determine the project's test setup from its manifests/README (framework,
   command, how to run a single file). Never assume — check.
2. If the change adds behavior, add or update tests for it (edge cases
   included, not just the happy path). Keep tests aligned with existing style.
3. Run the test command. Fix failures. Also run the project's typecheck/lint
   if defined.
4. Report: what tests were run, the result, and any tests you deliberately
   skipped and why.

If there is genuinely no test setup, say so and propose the smallest useful
test harness rather than silently skipping verification.