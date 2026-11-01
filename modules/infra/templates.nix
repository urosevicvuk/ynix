{...}: {
  # Project starters, usable from anywhere:
  #   nix flake init -t ~/Projects/urosevicvuk/ynix#python
  #   nix flake init -t github:urosevicvuk/ynix#python
  #
  # Add a new one by dropping a directory under ../../templates and listing it
  # here. Note that `nix flake init` evaluates this whole flake, so a cold run on
  # a machine without the lock cached pulls the full input closure.
  flake.templates = {
    python = {
      path = ../../templates/python;
      description = "Python: Nix-pinned interpreter, uv-managed dependencies, uv2nix build and checks";
      welcomeText = ''
        # => Python project

        Next steps:

            git init && git add -A  # flakes only see git-tracked files
            direnv allow            # or: nix develop
            uv init --package       # creates pyproject.toml
            uv lock                 # creates uv.lock
            git add -A

        Then `nix flake check` builds, tests and lints it. See README.md.
      '';
    };

    rust = {
      path = ../../templates/rust;
      description = "Rust: Nix-pinned toolchain, cargo-managed crates, crane build and checks";
      welcomeText = ''
        # => Rust project

        Next steps:

            git init && git add -A   # flakes only see git-tracked files
            direnv allow             # or: nix develop
            cargo init               # creates Cargo.toml
            cargo generate-lockfile  # creates Cargo.lock
            git add -A

        Then `nix flake check` builds, tests and lints it. See README.md.
      '';
    };

    go = {
      path = ../../templates/go;
      description = "Go: Nix-pinned toolchain, go-module dependencies, buildGoModule build and checks";
      welcomeText = ''
        # => Go project

        Next steps:

            git init && git add -A     # flakes only see git-tracked files
            direnv allow               # or: nix develop
            go mod init <module path>  # creates go.mod
            git add -A

        Then `nix flake check` builds, tests and lints it. After the first
        `go get`, see README.md about vendorHash.
      '';
    };
  };
}
