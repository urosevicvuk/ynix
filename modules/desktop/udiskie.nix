# Udiskie - automatic mounting of removable storage devices
{...}: {
  flake.homeModules.desktop = {...}: {
    services.udiskie = {
      enable = true;
      notify = true;
      automount = true;
    };
  };
}
