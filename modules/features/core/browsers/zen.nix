{inputs, ...}: {
  flake.homeModules.zen = {pkgs, ...}: {
    home.packages = [
      inputs.zen-browser.packages.${pkgs.system}.default
    ];
  };
}
