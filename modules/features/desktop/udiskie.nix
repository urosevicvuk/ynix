# Udiskie - automatic mounting of removable storage devices
{self, ...}: {
  # Self-registers into the `desktop` group (merged with the other desktop modules).
  flake.nixosModules.desktop.imports = [self.nixosModules.udiskie];

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
