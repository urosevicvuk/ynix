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
    lib,
    config,
    ...
  }: {
    imports = [
      self.nixosModules.base
      self.nixosModules.desktop
      self.nixosModules.docker
      self.nixosModules.discord
      self.nixosModules.spicetify
      self.nixosModules.browsers
      self.nixosModules.btop
      self.nixosModules.obs
      self.nixosModules.zathura

      inputs.home-manager.nixosModules.default
      inputs.nixos-hardware.nixosModules.framework-amd-ai-300-series
      inputs.determinate.nixosModules.default
      inputs.sops-nix.nixosModules.sops
      ./_hardware/ariandel.nix
      ./_hardware/ariandel-framework.nix
    ];

    networking.hostName = "ariandel";
    system.stateVersion = "24.05";

    hardware.enableRedistributableFirmware = true;
    hardware.framework.enableKmod = true;

    services.fprintd.enable = true;

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
        home.file.".face.icon".source = ./_assets/ariandel-profile.png;

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
    };
  };
}
