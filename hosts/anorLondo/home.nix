{
  pkgs,
  config,
  inputs,
  ...
}: {
  imports = [
    # Programs
    ../../modules-home/programs/fetch
    ../../modules-home/programs/nvf
    ../../modules-home/programs/shell
    ../../modules-home/programs/btop.nix
    ../../modules-home/programs/direnv.nix
    ../../modules-home/programs/editorconfig.nix
    ../../modules-home/programs/git.nix
    ../../modules-home/programs/kitty.nix
    ../../modules-home/programs/nextcloud.nix
    ../../modules-home/programs/obs-studio.nix
    ../../modules-home/programs/spicetify.nix
    ../../modules-home/programs/thunar.nix
    ../../modules-home/programs/walker.nix
    ../../modules-home/programs/zathura.nix
    ../../modules-home/programs/zen.nix

    # Scripts
    ../../modules-home/scripts # All scripts

    # System
    ../../modules-home/system/hyprland
    ../../modules-home/system/clipman.nix
    ../../modules-home/system/hypridle.nix
    ../../modules-home/system/hyprlock.nix
    # ../../modules-home/system/hyprpanel.nix  # Disabled - replaced by QuickShell
    ../../modules-home/system/quickshell.nix
    ../../modules-home/system/hyprpaper.nix
    ../../modules-home/system/mime.nix
    ../../modules-home/system/udiskie.nix

    # Secrets
    ../../secrets/shared

    ./variables.nix
  ];

  #All the programs that are not importes as modules
  programs = {
  };
  services = {
  };

  # Overlays
  #nixpkgs.overlays = [
  #  (final: prev: {

  #  })
  #];

  home = {
    inherit (config.var) username;
    homeDirectory = "/home/" + config.var.username;

    packages =
      (with pkgs; [
        # Apps
        obsidian
        vlc
        vesktop
        libreoffice-fresh
        figma-linux
        pinta
        qbittorrent

        # Affinity
        inputs.affinity-nix.packages.x86_64-linux.v3

        # Dev
        pnpm
        nodejs
        claude-code
        opencode
        gh
        gnumake
        postman
        bruno
        vscode
        rstudioWrapper
        jetbrains.goland
        jetbrains.idea-ultimate
        jetbrains.datagrip
        jetbrains.webstorm
        android-studio

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
        bluetuith # Bluetooth manager
        wiremix # PipeWire audio mixer
        # nmtui is built-in with NetworkManager (no need to install)

        # Virtualization
        freerdp

        # Just cool
        peaclock
        cbonsai
        pipes
        cmatrix
        neo-cowsay
      ])
      ++ (with pkgs.stable; [
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
