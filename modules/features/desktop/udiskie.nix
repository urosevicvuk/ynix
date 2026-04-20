# Udiskie - automatic mounting of removable storage devices
{self, ...}: {
  flake.nixosModules.udiskie = {...}: {
    home-manager.sharedModules = [self.homeModules.udiskie];
  };

  flake.homeModules.udiskie = {...}: {
    services.udiskie = {
      enable = true;
      notify = true;
      automount = true;
    };
  };
}
