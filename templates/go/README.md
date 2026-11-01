# Go project

Nix pins the toolchain (go, gopls, goimports, delve) and builds and checks the
project; go modules manage the dependencies.

## Getting started

```sh
git init && git add -A                     # flakes only see git-tracked files
direnv allow                               # or: nix develop
go mod init github.com/<you>/<project>     # creates go.mod
git add -A
```

## Where does a dependency go?

- **A package the code imports** (cobra, testify, pgx) → `go get`, then
  `go mod tidy`. It lands in `go.mod` and `go.sum`.
- **A standalone binary you only invoke** (golangci-lint, air, just) →
  `packages` in `nix/devshell.nix`. Don't `go install` — it escapes the pin.

## After go.sum changes: the vendor hash

Nix fetches the modules go.sum names in a separate step, and checks them
against `vendorHash` at the top of `nix/package.nix`. Whenever go.sum changes,
the next `nix build` or `nix flake check` fails with a hash mismatch:

```
specified: sha256-AAAA…
   got:    sha256-SuU3c1yj…
```

Paste the `got:` value into `vendorHash` and build again. It starts out as
`lib.fakeHash`, so this also happens after the first `go get`.

## When go wants a newer toolchain

`GOTOOLCHAIN=local` stops go from downloading one behind your back, so a
`go.mod` asking for a newer version than nixpkgs ships fails instead. Run
`nix flake update`, or lower the `go` line in `go.mod`.

## Building and checking

- `nix build` builds the binaries into `./result/bin` (`nix/package.nix`).
- `nix flake check` builds every check, each in the Nix sandbox from the locked
  inputs:
  - `build`: compiles and runs `go test ./...`
  - `lint`: `golangci-lint run`
  - `tidy`: `go mod tidy -diff`, so go.mod and go.sum match the imports
  - `treefmt`: formatting
  - `devshell`: the shell builds

  They're defined in `nix/checks.nix`, where adding another is a few lines.
  `nix build .#checks.x86_64-linux.lint` runs just one.
- `nix fmt` formats everything: alejandra and deadnix for Nix, goimports for
  Go.
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

Commit `flake.lock`, `go.mod` and `go.sum` — together they reproduce the
environment on any machine.
