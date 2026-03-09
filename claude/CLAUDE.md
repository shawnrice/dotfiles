Never enter plan mode when the user asks for a direct action (commit, post comment, make edit). 
Execute the action immediately unless explicitly asked to plan first.

Add under a ## Code Style section in CLAUDE.md\n\nDo not strip existing code comments when 
refactoring. Preserve all comments unless explicitly asked to remove them.

Add under a ## Code Review section in CLAUDE.md\n\nWhen asked to review or analyze code/PRs, do NOT 
make code edits unless explicitly asked to. Keep analysis and implementation as separate steps.

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
