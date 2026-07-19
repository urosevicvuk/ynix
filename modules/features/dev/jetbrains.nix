# Development tool packages shared across all dev hosts
{self, ...}: {
  # Self-registers into the `dev` group (merged with the other dev modules).
  flake.nixosModules.dev.imports = [self.nixosModules.jetbrains];

  flake.nixosModules.jetbrains = {...}: {
    home-manager.sharedModules = [self.homeModules.jetbrains];
  };

  flake.homeModules.jetbrains = {pkgs, ...}: {
    home.packages = with pkgs; [
      jetbrains.idea
      jetbrains.datagrip
    ];
  };
}
