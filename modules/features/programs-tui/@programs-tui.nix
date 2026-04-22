{self, ...}: {
  flake.nixosModules.programs-tui = {pkgs, ...}: {
    imports = [
      self.nixosModules.btop
      self.nixosModules.yazi
      self.nixosModules.yt-dlp
    ];

    home-manager.sharedModules = [self.homeModules.programs-tui];
  };

  flake.homeModules.programs-tui = {...}: {
    programs = {
      jq = {
        enable = true;
      };
      fd = {
        enable = true;
      };
      ripgrep = {
        enable = true;
      };
      bat = {
        enable = true;
      };
    };
  };
}
