{
  pkgs,
  pkgs-stable,
  config,
  lib,
  ...
}: {
  imports = [
    ../../modules-home/core
    ../../modules-home/desktop
    ../../modules-home/programs/btop.nix
    ../../modules-home/programs/browsers.nix
    ../../modules-home/programs/discord.nix
    ../../modules-home/programs/opencode.nix
    ../../modules-home/programs/spicetify.nix
    ../../modules-home/programs/zathura.nix
    ../../modules-home/programs/nextcloud.nix
    ../../modules-home/nvim
    ../../modules-home/scripts
    ../../secrets/shared
    ./variables.nix
  ];

  home = {
    inherit (config.var) username;
    homeDirectory = lib.mkForce ("/home/" + config.var.username);

    packages =
      (with pkgs; [
        # Apps
        obsidian
        slack
        signal-desktop
        vlc
        qbittorrent

        # Dev
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

    file.".face.icon" = {
      source = ./profile_picture.png;
    };

    # Don't touch this
    stateVersion = "24.05";
  };

  programs.home-manager.enable = true;
}
