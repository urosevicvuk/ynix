{self, ...}: {
  flake.homeModules.qbitorrent = {pkgs, ...}: {
    home.packages = with pkgs; [
      qbittorrent
    ];
  };

  flake.nixosModules.qbitorrent = {...}: {
    home-manager.sharedModules = [self.homeModules.qbitorrent];
  };
}
