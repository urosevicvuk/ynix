{inputs, ...}: {
  imports = [inputs.git-hooks.flakeModule];

  perSystem = {
    config,
    pkgs,
    ...
  }: {
    pre-commit = {
      # treefmt already runs its own check under `nix flake check`; running the
      # hooks there too would only format everything twice.
      check.enable = false;

      settings.hooks.treefmt = {
        enable = true;
        package = config.treefmt.build.wrapper;
      };
    };

    # Installed on request rather than on shell entry: `nix run .#install-hooks`
    # from the repo root, once per clone. Rerun it after changing the hooks.
    apps.install-hooks = {
      type = "app";
      program = "${pkgs.writeShellScript "install-hooks" config.pre-commit.installationScript}";
      meta.description = "Install the pre-commit hooks into .git/hooks";
    };
  };
}
