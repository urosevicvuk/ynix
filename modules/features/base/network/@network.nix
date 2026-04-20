{
  self,
  ...
}:
{
  flake.nixosModules.network =
    { ... }:
    {
      imports = [
        self.nixosModules.networking
        self.nixosModules.ssh
        self.nixosModules.tailscale
      ];
    };
}
