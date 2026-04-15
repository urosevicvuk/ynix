# Desktop application packages shared across all desktop hosts
{
  flake.homeModules.desktop = { pkgs, ... }: {
    home.packages = with pkgs; [
      obsidian
      slack
      signal-desktop
      vlc
      qbittorrent
      libreoffice-fresh
      figma-linux

      bluez
      curtail
      vulkan-tools
      bluetuith
      wiremix
      freerdp
    ];
  };
}
