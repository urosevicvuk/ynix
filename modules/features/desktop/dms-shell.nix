{
  self,
  inputs,
  ...
}: {
  # Self-registers into the `desktop` group (merged with the other desktop modules).
  flake.nixosModules.desktop.imports = [self.nixosModules.dms-shell];

  flake.nixosModules.dms-shell = {pkgs, ...}: {
    imports = [
      inputs.dms-plugin-registry.nixosModules.default
    ];

    programs.dms-shell = {
      enable = true;

      systemd = {
        enable = true;
        restartIfChanged = true;
      };

      enableSystemMonitoring = true;
      enableVPN = true;
      enableDynamicTheming = true;
      enableAudioWavelength = true;
      enableCalendarEvents = true;

      plugins = {
        dankBatteryAlerts.enable = true;
        dockerManager.enable = true;
      };

    };

    home-manager.sharedModules = [self.homeModules.dms-shell];
  };

  flake.homeModules.dms-shell = {...}: {
  };
}
