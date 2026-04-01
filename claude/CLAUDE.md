Never enter plan mode when the user asks for a direct action (commit, post comment, make edit).
Execute the action immediately unless explicitly asked to plan first.
## Git Commits

- Start with a concise summary line describing the primary intent (the "why")
- Follow with a bullet list of specific changes (the "what")
- When there are many changes, group and paraphrase rather than listing every file
- Categorize incidental cleanup (e.g. removing eslint-disable comments, fixing lint, minor
  reformatting) separately as "Opportunistic tidying:" at the end
- Use imperative mood in the summary line (e.g. "add", "fix", "refactor")

## Code Style

Do not strip existing code comments when refactoring. Preserve all comments unless explicitly asked
to remove them.

## Code Review

When asked to review or analyze code/PRs, do NOT make code edits unless explicitly asked to. Keep
analysis and implementation as separate steps.

# TypeScript Style

## Naming & Formatting

- Prefer short but descriptive variable names
- Always use braces for control flow (no braceless `if`/`for`/`while`)
- Always use semicolons

## Functions & Mutation

- Avoid variable mutation; prefer `const` and new bindings over reassignment
- Prefer `const` arrow function expressions over `function` declarations (e.g. `const foo = () => {}`)
- Prefer early returns to keep nesting minimal
- Use parameter destructuring in function signatures
- Keep functions unary (single parameter); use an options object or currying for multiple args
- Prefer closures over classes unless many instances will be created
- Prefer functional patterns: composition, currying, pipe/flow, map/filter/reduce over imperative loops

## Types

- Prefer `type` over `interface`
- Use `import type` for type-only imports
- Use `?.` and `??` over defensive `if` checks or try-catch where possible

## Modules & Data

- Named exports only; no default exports
- Prefer `Map`/`Set` over plain objects for indexed or unique collections
- Minimal comments; code should be self-documenting

## Datadog

- Use the `pup` CLI for all Datadog operations (logs, traces, metrics, monitors, dashboards)
- Never use Datadog MCP server tools — use the dd-* skills or `pup` directly via Bash

## CSS

- **DO NOT USE TAILWIND OR CSS-IN-JS.** Ever. For any project.
- Use SCSS modules (`.module.scss`) as the default approach.
- Vanilla CSS or CSS modules (`.module.css`) are also acceptable.
