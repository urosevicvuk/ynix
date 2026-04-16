# Desktop application packages
{
  flake.homeModules.desktop = { pkgs, ... }: {
    home.packages = with pkgs; [
      obsidian
      signal-desktop
      vlc
      qbittorrent
      curtail
    ];
  };
}
