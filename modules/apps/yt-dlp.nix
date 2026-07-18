{self, ...}: {
  # Self-registers into the `apps` group (merged with the other apps modules).
  flake.nixosModules.apps.imports = [self.nixosModules.yt-dlp];

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
