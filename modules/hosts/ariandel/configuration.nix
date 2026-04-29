{
  self,
  inputs,
  ...
}: {
  flake.nixosConfigurations.ariandel = inputs.nixpkgs.lib.nixosSystem {
    modules = [self.nixosModules.ariandel];
  };

  flake.nixosModules.ariandel = {
    pkgs,
    config,
    ...
  }: {
    imports = [
      self.nixosModules.base
      self.nixosModules.desktop
      self.nixosModules.dev
      self.nixosModules.gaming
      self.nixosModules.programs-gui
      self.nixosModules.programs-tui
      self.nixosModules.work

      self.nixosModules.stylix
      self.nixosModules.sops

      inputs.nixos-hardware.nixosModules.framework-amd-ai-300-series
      inputs.determinate.nixosModules.default
    ];

    networking.hostName = "ariandel";
    system.stateVersion = "26.05";

    hardware.enableRedistributableFirmware = true;
    hardware.enableAllFirmware = true;
    hardware.framework.enableKmod = true;

    services.fprintd.enable = true;

    home-manager.users.${config.preferences.username} = {
      # home.file.".face.icon".source = ./_assets/ariandel-profile.png;

      home.packages = with pkgs; [
        acpi
        powertop
        figlet
        radeontop
      ];

      wayland.windowManager.hyprland.settings = {
        monitor = [
          "eDP-1,2880x1920@120,0x0,1.5"
          "DP-2,1920x1080@144,0x-1080,1"
          ",preferred,auto,1"
        ];
        input = {
          sensitivity = "0.2";
        };
        cursor.default_monitor = "eDP-1";
        env = [
          "GDK_SCALE,1.5"
        ];
      };
    };

    # Fix fingerprint reader after suspend/resume
    powerManagement.powerDownCommands = ''
      ${pkgs.systemd}/bin/systemctl stop fprintd.service 2>/dev/null || true
    '';
    # Reset xHCI controller after resume to recover fingerprint reader
    powerManagement.resumeCommands = ''
      # Unbind the dead xHCI controller
      echo '0000:c1:00.4' > /sys/bus/pci/drivers/xhci_hcd/unbind 2>/dev/null || true

      # Rebind to reset it
      echo '0000:c1:00.4' > /sys/bus/pci/drivers/xhci_hcd/bind 2>/dev/null || true

      # fprintd will auto-start when needed
    '';
  };
}
