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
      self.nixosModules.base
      self.nixosModules.desktop
      self.nixosModules.dev
      self.nixosModules.nvim
      self.nixosModules.gaming
      self.nixosModules.core
      self.nixosModules.creative
      self.nixosModules.work

      self.nixosModules.stylix
      self.nixosModules.sops
    ];

    networking.hostName = "anorLondo";
    system.stateVersion = "26.05";

    hardware.enableAllFirmware = true;
    boot.supportedFilesystems = ["ntfs"];
    boot.loader.grub.useOSProber = true;

    home-manager.users.${config.preferences.username} = {
      # home.file.".face.icon".source = ./_assets/anorLondo-profile.png;

      home.packages = with pkgs; [
        solaar
        piper
      ];

      wayland.windowManager.hyprland.settings = {
        monitor = [
          "DP-2, 1920x1080@144, 0x0, 1"
          "DP-3, preferred, auto, 1, transform, 1"
          "HDMI-A-1, preferred, auto, 1, mirror, DP-2"
          ",preferred,auto,1"
        ];
        input = {
          sensitivity = "-0.5";
          kb_variant = lib.mkForce ",latin,";
        };
        cursor.default_monitor = "DP-2";
        env = [
          "GDK_SCALE,1"
        ];
      };
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
