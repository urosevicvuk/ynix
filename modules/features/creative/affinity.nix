{
  self,
  inputs,
  ...
}: {
  flake.nixosModules.creative.imports = [self.nixosModules.affinity];

  flake.nixosModules.affinity = {...}: {
    home-manager.sharedModules = [self.homeModules.affinity];
  };

  flake.homeModules.affinity = {pkgs, ...}: {
    home.packages = [
      inputs.affinity-nix.packages.${pkgs.stdenv.hostPlatform.system}.v3
    ];
  };
}
