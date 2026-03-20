# Qtil — CodeQL Utility Library

## Architecture

Qtil is a **multi-language CodeQL utility library** published as `advanced-security/qtil`. It has a layered structure:

- **Core pack** (`src/`): Language-agnostic utilities — tuples, lists, strings, graphs, inheritance helpers, parameterization aids. Entry point: `src/qtil/Qtil.qll` re-exports everything via one `module Qtil { ... }`.
- **Language packs** (`cpp/`, `java/`, `python/`, etc.): Each wraps the core pack and adds language-specific features (e.g., `TwoOperands`, `QlFormat`, `CustomPathProblem`). Entry point pattern: `cpp/src/qtil/Cpp.qll` imports `Common::Qtil` then adds cpp-specific modules.
- **Test packs** (`test/`, `<lang>/test/`): Mirror the src structure. Core tests use the `Qnit` unit testing framework; language tests analyze real source files.

Language-specific features like `TwoOperands`, `QlFormat`, and `CustomPathProblem` require language types and are intentionally **not** imported in the core `Qtil.qll` — they live in language packs only.

## Developer Workflow

- **CodeQL CLI version**: Pinned in `.codeqlversion` (currently `2.20.1`). CI reads this file.
- **Install packs**: `codeql pack install src` (core), `codeql pack install <lang>/src` (language-specific).
- **Run tests**: `codeql test run test/` (core) or `codeql test run <lang>/test/` (language-specific).
- **Format code**: `codeql query format --in-place <file.ql|file.qll>`. CI enforces formatting on all `.ql`/`.qll` files.
- **Code generation**: `python scripts/generate_fnqll.py` generates arity-based `.qll` files in `src/qtil/fn/generated/` from Jinja2 templates in `scripts/templates/`. Never hand-edit generated files.
- **Version bumps**: All packs share the same base version. When updating, bump `version` in `src/qlpack.yml` and all `<lang>/src/qlpack.yml` files, and update each language pack's dependency on `advanced-security/qtil` to match. Test packs don't need version bumps. See `.github/skills/update-pack-versions/SKLL.md`.

## CodeQL Conventions

- **QLDoc**: Every public module, class, and predicate gets a `/** ... */` doc comment with usage examples.
- **Imports**: Use `private import` for internal dependencies. Only the entry-point module (`Qtil.qll` / `Cpp.qll`) uses public imports.
- **Naming**: Modules are `PascalCase`, predicates are `camelCase`, type parameters are single uppercase letters (`T`, `R`, `A`, `B`).
- **Parameterized modules**: Heavy use with nested sub-modules. Example: `Ordered<T>::GroupBy<Division>::Type`. Use `Final<T>::Type` instead of `final class FinalFoo = Foo;` aliases.
- **Signature types**: Use the hierarchy from `SignatureTypes.qll` — `FiniteType`, `FiniteStringableType`, `InfiniteType`, `InfiniteStringableType`. Use `Signature<T>::Type` to create ad-hoc signature types from existing types.
- **`bindingset`**: Required on infinite types and predicates operating on infinite domains.

## Testing with Qnit

Core library tests use Qnit (`import qtil.testing.Qnit`), not standard CodeQL test assertions:

```ql
class MyTest extends Test, Case {
  override predicate run(Qnit test) {
    if someCondition()
    then test.pass("unique description")
    else test.fail("failure description")
  }
}
```

- Each test class should pass or fail with a **unique** string.
- Expected file for passing tests: `| 1 test passed. |` or `| All N tests passed. |`
- Language-specific tests (e.g., `cpp/test/`) use standard CodeQL test format with `test.cpp` + `.ql` + `.expected` pipe-delimited tables.
- Test helper libraries (`.qll`) go in the test directory alongside test files.

## Key Files

| Path | Purpose |
|------|---------|
| `src/qtil/Qtil.qll` | Core module entry point — all language-agnostic exports |
| `<lang>/src/qtil/<Lang>.qll` | Language pack entry point (e.g., `Cpp.qll`) |
| `src/qtil/parameterization/SignatureTypes.qll` | Reusable signature type hierarchy |
| `src/qtil/parameterization/SignaturePredicates.qll` | Signature predicates by arity (Nullary–Senary) |
| `scripts/generate_fnqll.py` | Code generator for arity-based modules |
| `.codeqlversion` | Pinned CodeQL CLI version |
| `.codeqlmanifest.json` | Workspace manifest listing all qlpacks |
