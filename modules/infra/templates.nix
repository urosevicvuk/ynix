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
      description = "Python: flake-parts devshell, Nix-pinned interpreter, uv-managed dependencies";
      welcomeText = ''
        # => Python project

        Next steps:

            git init      # flakes only see git-tracked files
            uv init       # creates pyproject.toml
            direnv allow  # or: nix develop

        See README.md for where each kind of dependency belongs.
      '';
    };

    rust = {
      path = ../../templates/rust;
      description = "Rust: flake-parts devshell, Nix-pinned toolchain, cargo-managed crates";
      welcomeText = ''
        # => Rust project

        Next steps:

            git init      # flakes only see git-tracked files
            cargo init    # creates Cargo.toml
            direnv allow  # or: nix develop

        See README.md for where each kind of dependency belongs.
      '';
    };

    go = {
      path = ../../templates/go;
      description = "Go: flake-parts devshell, Nix-pinned toolchain, go-module dependencies";
      welcomeText = ''
        # => Go project

        Next steps:

            git init                  # flakes only see git-tracked files
            go mod init <module path> # creates go.mod
            direnv allow              # or: nix develop

        See README.md for where each kind of dependency belongs.
      '';
    };
  };
}
