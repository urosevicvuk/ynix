{
  self,
  ...
}:
{
  flake.nixosModules.gaming =
    { ... }:
    {
      imports = [
        self.nixosModules.steam
        self.nixosModules.gamemode
      ];
    };
}
