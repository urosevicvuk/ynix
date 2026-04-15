# Zen and Helium browsers
{inputs, ...}: {
  flake.homeManagerModules.programs = {pkgs, ...}: {
    home.packages = [
      inputs.helium-browser.packages.${pkgs.system}.default
      inputs.zen-browser.packages.${pkgs.system}.default
    ];
  };
}
