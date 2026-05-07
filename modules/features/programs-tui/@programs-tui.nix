{self, ...}: {
  flake.nixosModules.programs-tui = {pkgs, ...}: {
    imports = [
      self.nixosModules.btop
      self.nixosModules.yazi
      self.nixosModules.yt-dlp
      self.nixosModules.trivy
      self.nixosModules.aerc
    ];

    home-manager.sharedModules = [self.homeModules.programs-tui];
  };

  flake.homeModules.programs-tui = {...}: {
    programs = {
      fastfetch.enable = true;
      bat.enable = true;
      fd.enable = true;
      ripgrep.enable = true;
      jq.enable = true;
    };
  };
}
