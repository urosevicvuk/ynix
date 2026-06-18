{
  self,
  inputs,
  ...
}: {
  flake.nixosModules.affinity = {...}: {
    home-manager.sharedModules = [self.homeModules.affinity];
  };

  flake.homeModules.affinity = {pkgs, ...}: {
    home.packages = [
      inputs.affinity-nix.packages.${pkgs.system}.v3
    ];
  };
}
