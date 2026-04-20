# Development tool packages shared across all dev hosts
{self, ...}: {
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
