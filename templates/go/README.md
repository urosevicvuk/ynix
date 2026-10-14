# Go project

Nix pins the toolchain (go, gopls, goimports, delve); go modules manage the
dependencies.

## Getting started

```sh
git init                                   # flakes only see git-tracked files
go mod init github.com/<you>/<project>     # creates go.mod
direnv allow                               # or: nix develop
```

## Where does a dependency go?

- **A package the code imports** (cobra, testify, pgx) → `go get`, then
  `go mod tidy`. It lands in `go.mod` and `go.sum`.
- **A standalone binary you only invoke** (golangci-lint, air, just) →
  `packages` in `nix/devshell.nix`. Don't `go install` — it escapes the pin.

## When go wants a newer toolchain

`GOTOOLCHAIN=local` stops go from downloading one behind your back, so a
`go.mod` asking for a newer version than nixpkgs ships fails instead. Run
`nix flake update`, or lower the `go` line in `go.mod`.

## Committing

Commit `flake.lock`, `go.mod` and `go.sum` — together they reproduce the
environment on any machine.
