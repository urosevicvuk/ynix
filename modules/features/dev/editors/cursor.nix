{self, ...}: {
  flake.nixosModules.cursor = {...}: {
    home-manager.sharedModules = [self.homeModules.cursor];
  };

  flake.homeModules.cursor = {pkgs, ...}: {
    home.packages = with pkgs; [
      code-cursor
    ];
  };
}
