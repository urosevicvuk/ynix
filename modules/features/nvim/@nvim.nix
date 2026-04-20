{
  self,
  ...
}:
{
  flake.nixosModules.nvim =
    { ... }:
    {
      home-manager.sharedModules = [ self.homeModules.nvim ];
    };
}
