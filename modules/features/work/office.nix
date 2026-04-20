# Work / office software
{
  self,
  ...
}:
{
  flake.homeModules.office =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        libreoffice-fresh
        slack
      ];
    };

  flake.nixosModules.office =
    { ... }:
    {
      home-manager.sharedModules = [ self.homeModules.office ];
    };
}
