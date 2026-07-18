{self, ...}: {
  # Self-registers into the `dev` group (merged with the other dev modules).
  flake.nixosModules.dev.imports = [self.nixosModules.opencode];

  flake.nixosModules.opencode = {...}: {
    home-manager.sharedModules = [self.homeModules.opencode];
  };

  flake.homeModules.opencode = {
    pkgs,
    lib,
    config,
    ...
  }: let
    theme = config.theme.active;
  in {
    programs.opencode = {
      enable = true;
      enableMcpIntegration = true;

      tui = {
        theme = lib.mkForce theme.opencode-theme;
      };

      web.enable = true;

    };
  };
}
