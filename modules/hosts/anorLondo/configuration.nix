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
      self.nixosModules.sunshine # GPU stream host -> Moonlight on ariandel
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

    # CPU is amd-pstate-epp ("active" mode), which only exposes performance/powersave
    # governors — the shared "schedutil" default silently falls back to powersave here.
    # Pin performance for max clocks on this machine only.
    powerManagement.cpuFreqGovernor = "performance";

    hardware.enableAllFirmware = true;
    boot.supportedFilesystems = ["ntfs"];
    boot.loader.grub.useOSProber = true;

    # Wake-on-LAN: let ariandel wake this box off the LAN before streaming.
    # Wake it with: `wol 04:42:1a:22:80:f9` (broadcast a magic packet on the LAN).
    # ethtool ships so you can confirm support:  ethtool enp10s0 | grep Wake-on
    networking.interfaces.enp10s0.wakeOnLan.enable = true;
    environment.systemPackages = [pkgs.ethtool];

    home-manager.users.${config.preferences.username} = {
      # home.file.".face.icon".source = ./_assets/anorLondo-profile.png;

      home.packages = with pkgs; [
        solaar
        piper
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
