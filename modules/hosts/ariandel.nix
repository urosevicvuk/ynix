{
  self,
  inputs,
  ...
}: {
  flake.nixosConfigurations.ariandel = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.ariandel
    ];
  };

  flake.nixosModules.ariandel = {
    pkgs,
    lib,
    ...
  }: {
    imports = [
      self.nixosModules.core
      self.nixosModules.desktop
      self.nixosModules.programs

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

    programs.nh.flake = "/home/vyke/code/ynix";
    environment.variables.NH_FLAKE = "/home/vyke/code/ynix";

    home-manager.users.vyke = {
      home.stateVersion = "24.05";
      home.file.".face.icon".source = ./_assets/ariandel-profile.png;

      home.packages = with pkgs; [
        obsidian
        slack
        signal-desktop
        vlc
        qbittorrent
        opencloud-desktop
        kdePackages.qtstyleplugin-kvantum

        claude-code
        opencode
        gh
        bruno
        code-cursor
        zed-editor
        vscode
        jetbrains.idea
        jetbrains.goland
        jetbrains.datagrip

        nh
        nix-init
        ntfs3g
        p7zip
        ffmpeg
        optipng
        bluez
        curtail
        moreutils
        vulkan-tools

        acpi
        powertop
        figlet
        radeontop

        peaclock
        cbonsai
        pipes
        cmatrix
        neo-cowsay
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
}
