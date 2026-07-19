{self, ...}: {
  # Self-registers into the `dev` group (merged with the other dev modules).
  flake.nixosModules.dev.imports = [self.nixosModules.bruno];

  flake.nixosModules.bruno = {...}: {
    home-manager.sharedModules = [self.homeModules.bruno];
  };

  flake.homeModules.bruno = {pkgs, ...}: {
    home.packages = [pkgs.bruno];
  };
}
