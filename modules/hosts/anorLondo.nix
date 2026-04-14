{
  config,
  inputs,
  ...
}:
let
  nixos = config.flake.modules.nixos;
in
{
  flake.nixosConfigurations.anorLondo = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = {
      inherit inputs;
      pkgs-stable = import inputs.nixpkgs-stable {
        system = "x86_64-linux";
        config.allowUnfree = true;
      };
    };
    modules =
      nixos.core
      ++ nixos.desktop
      ++ nixos.programs
      ++ nixos.services
      ++ [
        inputs.sops-nix.nixosModules.sops
        ./_hardware/anorLondo.nix
        ./_hardware/anorLondo-peripherals.nix
        (
          {
            pkgs,
            lib,
            ...
          }:
          {
            networking.hostName = "anorLondo";
            system.stateVersion = "24.05";

            hardware.enableAllFirmware = true;
            boot.supportedFilesystems = [ "ntfs" ];
            boot.loader.grub.useOSProber = true;

            programs.nh.flake = "/home/vyke/code/ynix";
            environment.variables.NH_FLAKE = "/home/vyke/code/ynix";

            home-manager.users.vyke = {
              home.stateVersion = "24.05";
              home.file.".face.icon".source = ./_assets/anorLondo-profile.png;

              home.packages = with pkgs; [
                obsidian
                slack
                signal-desktop
                vlc
                libreoffice-fresh
                figma-linux
                qbittorrent

                inputs.affinity-nix.packages.x86_64-linux.v3

                claude-code
                opencode
                gh
                bruno
                vscode
                code-cursor
                zed-editor
                jetbrains.goland
                jetbrains.idea
                jetbrains.datagrip
                jetbrains.webstorm

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
                bluetuith
                wiremix
                freerdp

                peaclock
                cbonsai
                pipes
                cmatrix
                neo-cowsay
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
          }
        )
      ];
  };
}
