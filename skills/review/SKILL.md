---
name: review
description: Review the current uncommitted changes for correctness, risks, and style. Run this before finishing work on a task.
---

# /review — self-review

Review the current change set before declaring work done.

1. Inspect the diff (staged and unstaged) for the workspace. Use the project's
   git status/diff; if no VCS context exists, review the files touched.
2. Check for:
   - Correctness: logic errors, off-by-one, wrong branching, dead code.
   - Regressions: changed behavior beyond the task scope.
   - Risks: secrets/credentials, destructive operations, breaking changes.
   - Style/consistency: matches the surrounding code and repo conventions;
     no stray comments, debug prints, or leftover scaffolding.
   - Tests: the change has appropriate test coverage or a stated reason not to.
3. Report findings as a short list: what looks good, what should change, what
   must change. Fix the "must" items before finishing, then re-verify.

Do not inflate review with trivia; focus on what matters for the change.