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
      self.nixosModules.steam
      self.nixosModules.programs-gui
      self.nixosModules.programs-tui

      self.nixosModules.stylix
      self.nixosModules.sops

      inputs.nixos-hardware.nixosModules.framework-amd-ai-300-series
    ];

    networking.hostName = "ariandel";
    system.stateVersion = "26.05";

    preferences.theme = "gruvbox";

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

      programs.niri.settings.outputs = {
        "eDP-1" = {
          scale = 1.5;
          mode = {
            width = 2880;
            height = 1920;
            refresh = 120.0;
          };
          position = {
            x = 0;
            y = 0;
          };
        };
        "DP-2" = {
          scale = 1.0;
          mode = {
            width = 1920;
            height = 1080;
            refresh = 144.0;
          };
          position = {
            x = 0;
            y = -1080;
          };
        };
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
