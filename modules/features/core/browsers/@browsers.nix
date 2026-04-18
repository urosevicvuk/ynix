{
  self,
  ...
}:
{
  flake.nixosModules.browsers =
    { ... }:
    {
      imports = [
        self.nixosModules.zen
        self.nixosModules.helium
      ];
    };
}
