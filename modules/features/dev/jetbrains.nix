# Development tool packages shared across all dev hosts
{
  self,
  ...
}:
{
  flake.homeModules.jetbrains =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        jetbrains.idea
        jetbrains.datagrip
      ];
    };

  flake.nixosModules.jetbrains =
    { ... }:
    {
      home-manager.sharedModules = [ self.homeModules.jetbrains ];
    };
}
