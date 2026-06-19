{self, ...}: {
  flake.nixosModules.bruno = {...}: {
    home-manager.sharedModules = [self.homeModules.bruno];
  };

  flake.homeModules.bruno = {pkgs, ...}: {
    home.packages = [pkgs.bruno];
  };
}
