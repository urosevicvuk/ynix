# btop system monitor
{ ... }:
{
  flake.nixosModules.btop = { config, pkgs, lib, ... }: {
    home-manager.users.${config.preferences.username} = {
      programs.btop = {
        enable = true;
        package = pkgs.btop-rocm;
        settings = {
          vim_keys = true;
          color_theme = lib.mkForce "gruvbox_dark_v2";
        };
      };
    };
  };
}
