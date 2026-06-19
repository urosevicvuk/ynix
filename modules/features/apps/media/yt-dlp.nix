{self, ...}: {
  flake.nixosModules.yt-dlp = {...}: {
    home-manager.sharedModules = [self.homeModules.yt-dlp];
  };

  flake.homeModules.yt-dlp = {pkgs, ...}: {
    programs.yt-dlp = {
      enable = true;

      #can input config here, but idk what i need yet
    };
  };
}
