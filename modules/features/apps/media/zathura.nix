{self, ...}: {
  flake.nixosModules.zathura = {...}: {
    home-manager.sharedModules = [self.homeModules.zathura];
  };

  flake.homeModules.zathura = {...}: {
    programs.zathura.enable = true;
  };
}
