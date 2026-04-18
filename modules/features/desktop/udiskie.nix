# Udiskie - automatic mounting of removable storage devices
{
  self,
  ...
}:
{
  flake.homeModules.udiskie =
    { ... }:
    {
      services.udiskie = {
        enable = true;
        notify = true;
        automount = true;
      };
    };

  flake.nixosModules.udiskie =
    { ... }:
    {
      home-manager.sharedModules = [ self.homeModules.udiskie ];
    };
}
