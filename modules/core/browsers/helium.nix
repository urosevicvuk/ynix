{inputs, ...}: {
  flake.homeModules.helium = {pkgs, ...}: {
    home.packages = [
      inputs.helium-browser.packages.${pkgs.system}.default
    ];
  };
}
