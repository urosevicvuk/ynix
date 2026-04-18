{
  self,
  inputs,
  ...
}:
{
  flake.nixosModules.core =
    { ... }:
    {
      imports = [
        self.nixosModules.zen
        self.nixosModules.helium
        self.nixosModules.discord
        self.nixosModules.spicetify
      ];
    };
}
