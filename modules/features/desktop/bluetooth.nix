{self, ...}: {
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
