# Copilot Custom Instructions

For every new feature or piece of work, follow this workflow:

1. Design the feature
   - Discuss the design first.
   - Ask clarifying questions about ambiguity before implementation.

2. Write failing tests
   - Follow strict TDD.
   - Add failing unit tests and integration tests where appropriate before implementation.

3. Write the implementation
   - Implement only after tests are written and failing.
   - Confirm the tests pass after implementation.

4. Finalise and clean up
   - Run formatting, linting, static checks, and relevant test suites.
   - Leave the work in a clean, verified state.

# Core rules

These rules apply to every task in this project unless explicitly overridden.
Bias: caution over speed on non-trivial work. Use judgment on trivial tasks.

## Rule 1 — Think Before Coding

- State assumptions explicitly. If uncertain, ask rather than guess.
- Present multiple interpretations when ambiguity exists.
- Push back when a simpler approach exists.
- Stop when confused. Name what's unclear.

## Rule 2 — Simplicity First

- Minimum code that solves the problem. Nothing speculative.
- No features beyond what was asked. No abstractions for single-use code.
- Test: would a senior engineer say this is overcomplicated? If yes, simplify.

## Rule 3 — Surgical Changes

- Touch only what you must. Clean up only your own mess.
- Don't "improve" adjacent code, comments, or formatting.
- Don't refactor what isn't broken. Match existing style.
- When explicitly asked to refactor, follow the agreed plan one step at a time; this rule then applies per step.

## Rule 4 — Goal-Driven Execution

- Define success criteria. Loop until verified.
- Don't follow steps. Define success and iterate.
- Strong success criteria let you loop independently.

## Rule 5 — Use the model only for judgment calls

- Use me for: classification, drafting, summarization, extraction.
- Do NOT use me for: routing, retries, deterministic transforms.
- If code can answer, code answers.

## Rule 6 — Token budgets are not advisory

- Per-task: 50,000 tokens (a feature with its tests is one task). Per-session: 175,000 tokens.
- Checkpoint-summarize at each workflow phase boundary (design, tests, implementation, cleanup).
- If approaching budget, summarize and start fresh.
- Surface the breach, treating it as a prompt to checkpoint rather than a hard stop. Do not silently overrun.

## Rule 7 — Surface conflicts, don't average them

- If two patterns contradict, pick one (more recent / more tested).
- Explain why. Flag the other for cleanup.
- Don't blend conflicting patterns.

## Rule 8 — Read before you write

- Before adding code, read exports, immediate callers, shared utilities.
- "Looks orthogonal" is dangerous. If unsure why code is structured a way, ask.

## Rule 9 — Tests verify intent, not just behavior

- Tests must encode WHY behavior matters, not just WHAT it does.
- A test that can't fail when business logic changes is wrong.

## Rule 10 — Checkpoint after every significant step

- Summarize what was done, what's verified, what's left.
- Don't continue from a state you can't describe back.
- If you lose track, stop and restate.

## Rule 11 — Match the codebase's conventions, even if you disagree

- Conformance > taste inside the codebase.
- If you genuinely think a convention is harmful, surface it. Don't fork silently.

## Rule 12 — Fail loud

- "Completed" is wrong if anything was skipped silently.
- "Tests pass" is wrong if any were skipped.
- Default to surfacing uncertainty, not hiding it.

# Coding style

Core principle: Functional programming with immutable data. Self-documenting code.

- Avoid data mutation and use immutable data structures wherever possible
- Local mutation is acceptable when callers cannot observe it (for example, building a collection inside one pure function); never mutate shared or passed-in data
- Prefer small pure functions wherever possible
- Avoid nested if/else - use early returns or composition
- No comments - code should be self-documenting
- Prefer options objects over positional parameters
- Use functional idioms (map, filter, reduce) over loops

# Architecture and structure

Applies to new code and to explicitly requested refactors; in an existing codebase, Rule 11 still wins.

- Dependencies point one way. Record layers in a map and enforce it with an architecture test that fails on a violation or an unassigned module. Apply the same rule inside packages.
- Functional core, imperative shell: I/O (database, files, network, subprocess, UI framework) at the edges; logic as pure functions over plain values. Separate fetching from computing.
- One concept, one home. Split functions that mix parsing, validation, state and output.
- Only the owning package touches its resource handle (connection, client); others use intent-revealing methods. Enforce with a test.
- Confine frameworks (UI, ORM) to the edge so the core is testable headless.
- Replace type/provider if-chains with a registry of pure functions keyed by a closed enum.
- Closed vocabularies are enums, not strings. Derive names (columns, keys) from one helper. Pin persisted values with a test.
- Use frozen dataclasses or TypedDicts for data crossing layer boundaries, not dict[str, Any].
- Prefer an executable rule to prose: if a convention matters, add a test that fails when it is broken. Prefer a small test to a new dependency.

# Refactoring

- Behaviour-preserving refactors start with characterization (golden) tests that pass before and after; only test import paths may change.
- Separate mechanical moves from behaviour changes. Every commit leaves tests, linters and type checks green.
- Pin tool configuration explicitly so upgrades cannot silently change what is enforced.
- Work one plan step at a time and checkpoint between steps.
