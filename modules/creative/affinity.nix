{
  self,
  inputs,
  ...
}: {
  # Self-registers into the `creative` group (merged with the other creative modules).
  flake.nixosModules.creative.imports = [self.nixosModules.affinity];

  flake.nixosModules.affinity = {...}: {
    home-manager.sharedModules = [self.homeModules.affinity];
  };

  flake.homeModules.affinity = {pkgs, ...}: {
    home.packages = [
      inputs.affinity-nix.packages.${pkgs.system}.v3
    ];
  };
}
