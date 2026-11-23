# Working with Shad

Shad (he/him). These rules apply to every project. A project's own instructions can refine them.

## Shad's understanding comes first

- With Claude doing much of the work, Shad's picture of how a system works drifts from reality unless it's kept current. Most rules below exist to keep it current.
- Explain choices in the conversation: what changed, why, the alternative rejected, and what verifies it.
- "Why" questions during review are questions. Answer them, without proposing changes unless asked.
- Report results faithfully, including what wasn't verified.

## What's at stake decides when to ask

- **Reversible and local** (the working tree, a branch of Claude's own): act, then explain. Try an idea rather than asking whether to try it.
- **Live, shared or hard to undo** (a running system, the house, `main`, publishing, deleting data): explain what and why, and get Shad's OK first.
- When Shad runs commands, label each block with the machine or terminal it runs in.
- When Shad is needed (a decision, a command to run, something to review or test, a blocker, a long task finished), send a push notification that leads with what to act on. Skip it for routine progress.
- Shad watches CI and runs his own dev servers. After opening a PR, hand over the link; check CI only when asked or when the next step depends on it. Use his running servers instead of starting more.

## Less is more

- Don't add code, tests, docs or rules that nothing needs. Delete what's unused rather than maintain it.
- Prefer a general rule over a list of cases. Simplify freely, even when a specific detail is lost.
- Don't write code for cases that can't be exercised end to end. If the default outcome is recoverable, leave the guard out, say so, and make sure the case would show up in logs.

## Single source of truth

- Code, config and live systems are the truth. Comments, docs and memory describe them and go stale, and future sessions trust a description more than the code, so a stale one poisons later reasoning.
- Point to the source instead of copying it. Record only what the source can't hold: why, intent, outside facts, gotchas.
- When a description disagrees with the source, trust the source and fix the description.
- Let go of what no longer applies. Delete it rather than marking it retired; git keeps the history.

## Project knowledge

- It goes in auto-memory by default, so updating it doesn't need a PR. A project can choose otherwise in its CLAUDE.md.
- Each fact lives in one place. Don't repeat in a project what this file already says.

## Docs

- Draw diagrams in design docs with Mermaid, not ASCII art.

## Code

### Comments

- Write self-documenting code. Before reaching for a comment, improve names, extract a function or restructure.
- No temporal comments, the kind that only make sense next to the current change ("now handles X", "moved here so that…").
- A comment is acceptable for a lasting fact the code can't express and a reader would get wrong without.
- The reason for a change goes in the reply, commit message or PR.

### Organization

- Group a type by concern (in Swift, an `extension` per concern or conformance), and split a long file along concern lines before reordering it.
- Declarations first: nested types, statics, stored then computed properties, factories, `init`.
- Then methods in stepdown order: single-use helpers directly below their caller, shared helpers at the bottom of their section.

### Tests

- Test what a caller or user depends on. No change-detector tests that only pin incidental output (log wording, levels, description formats); pin an exact string only when something consumes it.
- Tests call code the way production does. No default arguments added just so tests can omit them.
- Prefer unit tests. Add an e2e test only when the trigger comes from an outside system, and say why a unit test can't cover it.
- Build and run the tests before reporting or opening a PR.

### Git and PRs

- Agreed multi-step work: one PR per step, branched off an up-to-date `main`. Wait for Shad's review before starting the next step.
- Follow-ups amend the PR's commit and push with `--force-with-lease` (Claude's own branches only). Stack commits only when they're meant to become separate PRs.
- A PR description says what changed and how it was tested, including what wasn't. Design rationale goes in the chat.
