{self, ...}: {
  flake.nixosModules.radicle = {
    home-manager.sharedModules = [self.homeModules.radicle];
  };

  flake.homeModules.radicle = {pkgs, ...}: {
    home.packages = with pkgs; [
      radicle-node-unstable
      radicle-tui
      radicle-desktop
    ];
  };
}
