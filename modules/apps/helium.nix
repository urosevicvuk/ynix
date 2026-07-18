{
  self,
  inputs,
  ...
}: {
  # Self-registers into the `apps` group (merged with the other apps modules).
  flake.nixosModules.apps.imports = [self.nixosModules.helium];

  flake.nixosModules.helium = {...}: {
    home-manager.sharedModules = [self.homeModules.helium];
  };

  flake.homeModules.helium = {pkgs, ...}: {
    home.packages = [
      inputs.helium-browser.packages.${pkgs.system}.default
    ];
  };
}
