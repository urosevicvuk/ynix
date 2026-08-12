{...}: {
  # Project starters, usable from anywhere:
  #   nix flake init -t ~/Projects/personal/ynix#python
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
  };
}
