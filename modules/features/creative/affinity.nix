{
  self,
  inputs,
  ...
}:
{
  flake.homeModules.affinity =
    { pkgs, ... }:
    {
      home.packages = [
        inputs.affinity-nix.packages.${pkgs.system}.v3
      ];
    };

  flake.nixosModules.affinity =
    { ... }:
    {
      home-manager.sharedModules = [ self.homeModules.affinity ];
    };
}
