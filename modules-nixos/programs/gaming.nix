{
  pkgs,
  config,
  ...
}: {
  # Gaming programs and utilities
  programs = {
    steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
    };
    gamescope.enable = true;
    gamemode.enable = true;
  };

  # Enable Steam hardware support (controllers, VR, etc.)
  hardware.steam-hardware.enable = true;

  # Home-manager gaming packages
  home-manager.users.${config.var.username}.home.packages = with pkgs; [
    lutris
    protonup-ng
    protonup-qt
    protontricks
    prismlauncher
    (wineWowPackages.stable.override {waylandSupport = true;})
    winetricks

    # Emulators
    # shadps4
  ];
}
