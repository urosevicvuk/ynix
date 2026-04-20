{
  self,
  inputs,
  ...
}:
{
  flake.homeModules.zen =
    { pkgs, ... }:
    {
      home.packages = [
        inputs.zen-browser.packages.${pkgs.system}.default
      ];
    };

  flake.nixosModules.zen =
    { ... }:
    {
      home-manager.sharedModules = [ self.homeModules.zen ];
    };
}
