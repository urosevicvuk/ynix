{
  self,
  ...
}:
{
  flake.homeModules.nixIndex =
    { ... }:
    {
      programs.nix-index = {
        enable = true;
        enableZshIntegration = true;
      };
    };

  flake.nixosModules.nixIndex =
    { ... }:
    {
      home-manager.sharedModules = [ self.homeModules.nixIndex ];
    };
}
