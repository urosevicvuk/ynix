{
  self,
  inputs,
  ...
}: {
  flake.nixosConfigurations.anorLondo = inputs.nixpkgs.lib.nixosSystem {
    modules = [self.nixosModules.anorLondo];
  };

  flake.nixosModules.anorLondo = {
    pkgs,
    lib,
    config,
    ...
  }: {
    imports = [
      self.nixosModules.system
      self.nixosModules.shell
      self.nixosModules.desktop
      self.nixosModules.dev
      self.nixosModules.apps
      self.nixosModules.gaming
      #self.nixosModules.creative
      self.nixosModules.work

      self.nixosModules.stylix
      self.nixosModules.sops
    ];

    networking.hostName = "anorLondo";
    system.stateVersion = "26.05";

    powerManagement.cpuFreqGovernor = "performance";

    hardware.enableAllFirmware = true;
    boot.supportedFilesystems = ["ntfs"];
    boot.loader.grub.useOSProber = true;

    home-manager.users.${config.preferences.username} = {
      # home.file.".face.icon".source = ./_assets/anorLondo-profile.png;

      home.packages = with pkgs; [
        solaar
        piper

        deadlock-mod-manager
      ];

      programs.niri.settings.input.keyboard.xkb.variant = lib.mkForce ",latin,";

    };

    # Hardware peripherals support - gaming mice, RGB controllers, Logitech devices
    services = {
      ratbagd.enable = true;
      hardware.openrgb.enable = true;

      udev = {
        packages = [pkgs.solaar];
        extraRules = ''
          SUBSYSTEM=="hidraw", ATTRS{idVendor}=="046d", MODE="0664", GROUP="input"
          SUBSYSTEM=="hidraw", KERNELS=="*046D*", MODE="0664", GROUP="input"
        '';
      };
    };
  };
}
