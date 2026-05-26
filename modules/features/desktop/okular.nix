{self, ...}: {
  flake.nixosModules.okular = {...}: {
    home-manager.sharedModules = [self.homeModules.okular];
  };

  flake.homeModules.okular = {pkgs, ...}: {
    home.packages = with pkgs; [
      kdePackages.okular
    ];
  };
}
