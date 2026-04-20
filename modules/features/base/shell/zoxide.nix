{
  self,
  ...
}:
{
  flake.homeModules.zoxide =
    { ... }:
    {
      programs.zoxide = {
        enable = true;
        enableZshIntegration = true;
      };
    };

  flake.nixosModules.zoxide =
    { ... }:
    {
      home-manager.sharedModules = [ self.homeModules.zoxide ];
    };
}
