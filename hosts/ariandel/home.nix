{
  pkgs,
  pkgs-stable,
  config,
  lib,
  ...
}: {
  imports = [
    # Programs
    ../../modules-home/programs/btop.nix
    ../../modules-home/programs/direnv.nix
    ../../modules-home/programs/editorconfig.nix
    ../../modules-home/programs/discord.nix
    ../../modules-home/programs/ghostty.nix
    ../../modules-home/programs/fetch
    ../../modules-home/programs/git.nix
    ../../modules-home/programs/kitty.nix
    ../../modules-home/programs/nextcloud.nix
    ../../modules-home/programs/nvf
    ../../modules-home/programs/shell
    ../../modules-home/programs/spicetify.nix
    ../../modules-home/programs/thunar.nix
    ../../modules-home/programs/walker.nix
    ../../modules-home/programs/zathura.nix
    ../../modules-home/programs/zen.nix

    # Scripts
    ../../modules-home/scripts # All scripts

    # System
    ../../modules-home/system/hypridle.nix
    ../../modules-home/system/hyprland
    ../../modules-home/system/mime.nix
    ../../modules-home/system/udiskie.nix

    # Secrets
    ../../secrets/shared

    ./variables.nix

    # Noctalia Shell (switched back from QuickShell)
    ../../modules-home/system/noctalia.nix
  ];

  home = {
    inherit (config.var) username;
    homeDirectory = lib.mkForce ("/home/" + config.var.username);

    packages =
      (with pkgs; [
        # Apps
        obsidian
        slack
        vlc
        qbittorrent

        # Dev pnpm nodejs opencode
        claude-code
        opencode
        gh
        bruno
        code-cursor
        zed-editor
        vscode
        jetbrains.idea
        jetbrains.datagrip

        # Utils
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

        # Laptop utilities
        acpi
        powertop
        figlet
        radeontop

        # Just cool
        peaclock
        cbonsai
        pipes
        cmatrix
        neo-cowsay
      ])
      ++ (with pkgs-stable; [
        # Stable packages (25.05)
      ]);

    # Import my profile picture, used by the hyprpanel dashboard
    file.".face.icon" = {
      source = ./profile_picture.png;
    };

    # Don't touch this
    stateVersion = "24.05";
  };

  programs.home-manager.enable = true;
}
