# Udiskie - automatic mounting of removable storage devices
{ ... }:
{
  flake.modules.homeManager.desktop = [
    (
      { ... }:
      {
        services.udiskie = {
          enable = true;
          notify = true;
          automount = true;
        };
      }
    )
  ];
}
