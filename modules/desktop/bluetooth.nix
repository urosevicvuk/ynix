{self, ...}: {
  # Self-registers into the `desktop` group (merged with the other desktop modules).
  flake.nixosModules.desktop.imports = [self.nixosModules.bluetooth];

  flake.nixosModules.bluetooth = {pkgs, ...}: {
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
    };

    services.blueman.enable = true;
    hardware.xpadneo.enable = false;

    home-manager.sharedModules = [self.homeModules.bluetooth];
  };

  flake.homeModules.bluetooth = {...}: {
    programs = {
      bluetuith = {
        enable = true;
      };
    };
  };
}
