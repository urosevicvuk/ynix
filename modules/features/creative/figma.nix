{
  self,
  ...
}:
{
  flake.homeModules.figma =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        figma-linux
      ];
    };

  flake.nixosModules.figma =
    { ... }:
    {
      home-manager.sharedModules = [ self.homeModules.figma ];
    };
}
