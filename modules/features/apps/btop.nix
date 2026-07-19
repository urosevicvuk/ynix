# btop system monitor
{self, ...}: {
  # Self-registers into the `apps` group (merged with the other apps modules).
  flake.nixosModules.apps.imports = [self.nixosModules.btop];

  flake.nixosModules.btop = {...}: {
    home-manager.sharedModules = [self.homeModules.btop];
  };

  flake.homeModules.btop = {
    pkgs,
    lib,
    config,
    ...
  }: let
    theme = config.theme.active;
  in {
    programs.btop = {
      enable = true;
      package = pkgs.btop-rocm;
      settings = {
        vim_keys = true;
        color_theme = lib.mkForce theme.btop-theme;
      };
    };
  };
}
