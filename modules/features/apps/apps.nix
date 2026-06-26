{self, ...}: {
  flake.nixosModules.apps = {...}: {
    imports = [
      # Browsers
      self.nixosModules.helium
      self.nixosModules.zen

      # Media
      self.nixosModules.calibre
      self.nixosModules.qbitorrent
      self.nixosModules.spicetify
      self.nixosModules.vlc     # TODO: perhaps move this? 
      self.nixosModules.yt-dlp  # TODO: perhaps move this?
      self.nixosModules.zathura

      # Productivity
      self.nixosModules.obsidian

      # Social
      self.nixosModules.aerc
      self.nixosModules.discord
      self.nixosModules.signal

      # Terminal
      self.nixosModules.ghostty
      self.nixosModules.kitty

      # Utils
      self.nixosModules.bitwarden
      self.nixosModules.btop
      self.nixosModules.nautilus
      self.nixosModules.opencloud
      self.nixosModules.yazi
    ];
  };
}
