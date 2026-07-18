{self, ...}: {
  # Self-registers into the `apps` group (merged with the other apps modules).
  flake.nixosModules.apps.imports = [self.nixosModules.qbitorrent];

  flake.nixosModules.qbitorrent = {...}: {
    home-manager.sharedModules = [self.homeModules.qbitorrent];
  };

  flake.homeModules.qbitorrent = {pkgs, ...}: {
    home.packages = with pkgs; [
      qbittorrent
    ];
  };
}
