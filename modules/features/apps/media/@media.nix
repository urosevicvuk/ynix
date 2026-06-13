# Media — music, video, books, documents, downloads.
{self, ...}: {
  flake.nixosModules.media = {pkgs, ...}: {
    imports = [
      self.nixosModules.spicetify
      self.nixosModules.calibre
      self.nixosModules.qbitorrent
      self.nixosModules.yt-dlp
      self.nixosModules.zathura
    ];

    environment.systemPackages = [pkgs.vlc];
  };
}
