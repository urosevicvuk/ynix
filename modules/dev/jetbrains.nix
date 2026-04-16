# Development tool packages shared across all dev hosts
{
  flake.homeModules.jetbrains = {pkgs, ...}: {
    home.packages = with pkgs; [
      jetbrains.idea
      jetbrains.datagrip
    ];
  };
}
