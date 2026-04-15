# Udiskie - automatic mounting of removable storage devices
{...}: {
  flake.homeManagerModules.desktop = {...}: {
    services.udiskie = {
      enable = true;
      notify = true;
      automount = true;
    };
  };
}
