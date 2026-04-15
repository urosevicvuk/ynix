# Zen and Helium browsers
{ inputs, ... }:
{
  flake.nixosModules.browsers = { config, pkgs, ... }: {
    home-manager.users.${config.preferences.username} = {
      home.packages = [
        inputs.helium-browser.packages.${pkgs.system}.default
        inputs.zen-browser.packages.${pkgs.system}.default
      ];
    };
  };
}
