# Rust project

Nix pins the toolchain (cargo, rustc, clippy, rustfmt, rust-analyzer); cargo
manages the crates.

## Getting started

```sh
git init            # flakes only see git-tracked files
cargo init          # creates Cargo.toml, named after this directory
direnv allow        # or: nix develop
```

## Where does a dependency go?

- **A crate the code uses** (serde, rand, tokio) → `cargo add`, or
  `cargo add --dev` for test-only. It lands in `Cargo.toml` and `Cargo.lock`.
- **A standalone binary you only invoke** (bacon, cargo-nextest, just) →
  `packages` in `nix/devshell.nix`. Don't `cargo install` — it escapes the pin.

## When a build fails with `could not find system library 'foo'`

Add the providing package (e.g. `openssl`) to `nativeLibs` in
`nix/devshell.nix`. This happens with `*-sys` crates, whose build scripts look
the C library up through pkg-config.

## Committing

Commit `flake.lock`, `Cargo.toml` and `Cargo.lock` — together they reproduce
the environment on any machine.
