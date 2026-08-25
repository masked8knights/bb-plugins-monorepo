---
name: todos
description: Maintain a structured task list for the current thread. Run this to read, create, or update the work items being tracked.
---

# /todos — task list

Keep a single, current task list for this thread.

- If no task list exists yet, create one from the current goal: checkboxes per
  discrete unit of work, ordered, with a short note per item.
- Keep it updated as work progresses: mark items done as they are verified,
  not merely started.
- When asked (or at natural checkpoints), output the list in a compact form
  such as:

  - [ ] item — note
  - [x] done item — note

Do not drift into unrelated work that is not on the list; if the goal changes,
rewrite the list to match. Prefer editing existing files over starting a new
list unless the thread context was lost.