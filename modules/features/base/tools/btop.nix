# btop system monitor
{self, ...}: {
  flake.nixosModules.btop = {...}: {
    home-manager.sharedModules = [self.homeModules.btop];
  };

  flake.homeModules.btop = {
    pkgs,
    lib,
    ...
  }: {
    programs.btop = {
      enable = true;
      package = pkgs.btop-rocm;
      settings = {
        vim_keys = true;
        color_theme = lib.mkForce "gruvbox_dark_v2";
      };
    };
  };
}
