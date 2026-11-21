{
  self,
  inputs,
  ...
}: {
  flake.nixosModules.apps.imports = [self.nixosModules.helium];

  flake.nixosModules.helium = {...}: {
    home-manager.sharedModules = [self.homeModules.helium];
  };

  flake.homeModules.helium = {pkgs, ...}: {
    home.packages = [
      inputs.helium-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];
  };
}
