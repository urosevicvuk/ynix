{
  pkgs,
  pkgs-stable,
  config,
  inputs,
  lib,
  ...
}: {
  imports = [
    ../../modules-home/core
    ../../modules-home/desktop
    ../../modules-home/programs/btop.nix
    ../../modules-home/programs/discord.nix
    ../../modules-home/programs/obs-studio.nix
    ../../modules-home/programs/spicetify.nix
    ../../modules-home/programs/zen.nix
    ../../modules-home/programs/zathura.nix
    ../../modules-home/programs/nextcloud.nix
    ../../modules-home/nvim
    ../../modules-home/scripts
    ../../secrets/shared
    ./variables.nix
  ];

  home = {
    inherit (config.var) username;
    homeDirectory = "/home/" + config.var.username;

    packages =
      (with pkgs; [
        # Apps
        obsidian
        vlc
        libreoffice-fresh
        figma-linux
        pinta
        qbittorrent

        # Affinity
        inputs.affinity-nix.packages.x86_64-linux.v3

        # Dev
        claude-code
        opencode
        gh
        bruno
        vscode
        jetbrains.goland
        jetbrains.idea
        jetbrains.datagrip
        jetbrains.webstorm

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

        # TUI system managers
        bluetuith
        wiremix

        # Virtualization
        freerdp

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

    file.".face.icon" = {
      source = ./profile_picture.png;
    };

    # Don't touch this
    stateVersion = "24.05";
  };

  programs.home-manager.enable = true;
}
