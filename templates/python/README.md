# Python project

Nix pins the interpreter and the standalone tools, and builds and checks the
project with uv2nix; uv manages the Python dependencies into a local `.venv`.

## Getting started

```sh
git init && git add -A     # flakes only see git-tracked files
direnv allow               # or: nix develop
uv init --package          # creates pyproject.toml, named after this directory
uv lock                    # creates uv.lock, which the Nix build reads
git add -A
```

`--package` gives the project a build system and a `src/` layout, so `nix
build` installs it with its scripts in `./result/bin`. Without it, the Nix
build is only the dependencies.

The shell never touches the venv or the lock file on its own. `uv sync`
creates `.venv` from `uv.lock`; then `uv run <cmd>` runs inside it, or
`source .venv/bin/activate` to stay there.

## Where does a dependency go?

- **Something the code imports** (pandas, pytest, requests) → `uv add`, or
  `uv add --dev` for dev-only. It lands in `pyproject.toml` and `uv.lock`.
- **A standalone binary you only invoke** (ruff, just, a database CLI) →
  `packages` in `nix/devshell.nix`, so it stays out of the venv.

## When an import fails with `libfoo.so: cannot open shared object file`

Add the providing package to `wheelLibs` in `nix/devshell.nix`. This happens
because the interpreter comes from Nix, so the nix-ld shim never runs for it and
the wheel's compiled extension has to be told where the library lives.

## Building and checking

- `nix build` builds a virtualenv with the project and its runtime
  dependencies into `./result` (`nix/package.nix`). Every package comes from
  `uv.lock`, hashes included.
- `nix flake check` builds every check, each in the Nix sandbox from the locked
  inputs:
  - `build`: the virtualenv above
  - `lock`: `uv lock --check`, so uv.lock matches pyproject.toml
  - `test`: `pytest`, once it's a dependency (`uv add --dev pytest`)
  - `treefmt`: formatting, and ruff's lints
  - `devshell`: the shell builds

  They're defined in `nix/checks.nix`, where adding another (mypy, say) is a
  few lines. `nix build .#checks.x86_64-linux.test` runs just one.
- `nix fmt` formats everything: alejandra and deadnix for Nix, ruff format and
  ruff check for Python.
- `nix run .#install-hooks` (once per clone) installs a pre-commit hook that
  runs the same formatter. If it changes anything the commit stops, so
  re-stage and commit again.

## CI

There's no CI script beyond `nix flake check`: it does the same thing on every
machine.

- Pushes and your own pull requests are built by nixbot (ynix's
  docs/nixbot.md).
- Pull requests from forks are held there until approved, and
  `.github/workflows/ci.yml` runs `nix flake check` for them on GitHub's
  machines instead.
- `.github/workflows/update-flake-lock.yml` only runs when you start it from
  the Actions tab. It bumps `flake.lock` and opens a PR. Locally,
  `nix flake update` does the same.

## Committing

Commit `flake.lock`, `pyproject.toml` and `uv.lock` — together they reproduce
the environment on any machine.
