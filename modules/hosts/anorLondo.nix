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
      self.nixosModules.gaming
      self.nixosModules.docker
      self.nixosModules.filesharing
      self.nixosModules.discord
      self.nixosModules.spicetify
      self.nixosModules.browsers
      self.nixosModules.btop
      self.nixosModules.obs
      self.nixosModules.zathura

      inputs.home-manager.nixosModules.default
      inputs.sops-nix.nixosModules.sops
      ./_hardware/anorLondo.nix
      ./_hardware/anorLondo-peripherals.nix
    ];

    networking.hostName = "anorLondo";
    system.stateVersion = "24.05";

    hardware.enableAllFirmware = true;
    boot.supportedFilesystems = ["ntfs"];
    boot.loader.grub.useOSProber = true;

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      backupFileExtension = "hm-backup";
      users.vyke = {
        imports = [
          self.homeModules.base
          self.homeModules.desktop
          self.homeModules.dev
          self.homeModules.nvim
        ];
        home.stateVersion = "24.05";
        home.username = "vyke";
        home.homeDirectory = "/home/vyke";
        programs.home-manager.enable = true;
        home.file.".face.icon".source = ./_assets/anorLondo-profile.png;

        home.packages = with pkgs; [
          inputs.affinity-nix.packages.x86_64-linux.v3
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
    };
  };
}
