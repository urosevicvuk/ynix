{self, ...}: {
  # Self-registers into the `dev` group (merged with the other dev modules).
  flake.nixosModules.dev.imports = [self.nixosModules.opencode];

  flake.nixosModules.opencode = {pkgs, ...}: {
    home-manager.sharedModules = [self.homeModules.opencode];

    environment.systemPackages = with pkgs; [
      opencode
      opencode-desktop
    ];
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
