{inputs, ...}: {
  imports = [inputs.git-hooks.flakeModule];

  perSystem = {
    config,
    pkgs,
    ...
  }: {
    pre-commit = {
      check.enable = false;

      settings.hooks.treefmt = {
        enable = true;
        package = config.treefmt.build.wrapper;
      };
    };

    apps.install-hooks = {
      type = "app";
      program = "${pkgs.writeShellScript "install-hooks" config.pre-commit.installationScript}";
      meta.description = "Install the pre-commit hooks into .git/hooks";
    };
  };
}
