# Python project

Nix pins the interpreter and the standalone tools; uv manages the Python
dependencies into a local `.venv`.

## Getting started

```sh
git init            # flakes only see git-tracked files
uv init             # creates pyproject.toml, named after this directory
direnv allow        # or: nix develop
```

Entering the shell runs `uv sync` and activates `.venv`.

## Where does a dependency go?

- **Something the code imports** (pandas, pytest, requests) → `uv add`, or
  `uv add --dev` for dev-only. It lands in `pyproject.toml` and `uv.lock`.
- **A standalone binary you only invoke** (ruff, just, a database CLI) →
  `packages` in `nix/devshell.nix`, so it stays out of the venv.

## When an import fails with `libfoo.so: cannot open shared object file`

Add the providing package to `wheelLibs` in `nix/devshell.nix`. This happens
because the interpreter comes from Nix, so the nix-ld shim never runs for it and
the wheel's compiled extension has to be told where the library lives.

## Committing

Commit `flake.lock`, `pyproject.toml` and `uv.lock` — together they reproduce
the environment on any machine.
