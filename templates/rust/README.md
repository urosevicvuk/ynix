# Rust project

Nix pins the toolchain (cargo, rustc, clippy, rustfmt, rust-analyzer) and
builds and checks the project with crane; cargo manages the crates.

## Getting started

```sh
git init && git add -A     # flakes only see git-tracked files
direnv allow               # or: nix develop
cargo init                 # creates Cargo.toml, named after this directory
cargo generate-lockfile    # creates Cargo.lock, which the Nix build needs
git add -A
```

## Where does a dependency go?

- **A crate the code uses** (serde, rand, tokio) → `cargo add`, or
  `cargo add --dev` for test-only. It lands in `Cargo.toml` and `Cargo.lock`.
- **A standalone binary you only invoke** (bacon, cargo-nextest, just) →
  `packages` in `nix/devshell.nix`. Don't `cargo install` — it escapes the pin.

## When a build fails with `could not find system library 'foo'`

Add the providing package (e.g. `openssl`) to `nativeLibs` in
`nix/package.nix`; the devshell picks it up from there too. This happens with
`*-sys` crates, whose build scripts look the C library up through pkg-config.

## Building and checking

- `nix build` builds the binaries into `./result/bin` (`nix/package.nix`).
  The dependencies are compiled once in a derivation of their own, so
  changing your code doesn't rebuild them.
- `nix flake check` builds every check, each in the Nix sandbox from the locked
  inputs:
  - `build`: `cargo build --release --locked`
  - `clippy`: `cargo clippy --all-targets`, with warnings as errors
  - `test`: `cargo test --locked`
  - `treefmt`: formatting
  - `devshell`: the shell builds

  They're defined in `nix/checks.nix`, where adding another is a few lines
  (crane also has `cargoDoc`, `cargoNextest`, `cargoAudit` and `cargoDeny`).
  `nix build .#checks.x86_64-linux.clippy` runs just one.
- `nix fmt` formats everything: alejandra and deadnix for Nix, rustfmt for
  Rust.
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

Commit `flake.lock`, `Cargo.toml` and `Cargo.lock` — together they reproduce
the environment on any machine.
