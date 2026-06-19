{
  self,
  inputs,
  ...
}: {
  flake.nixosModules.helium = {...}: {
    home-manager.sharedModules = [self.homeModules.helium];
  };

  flake.homeModules.helium = {pkgs, ...}: {
    home.packages = [
      inputs.helium-browser.packages.${pkgs.system}.default
    ];
  };
}
