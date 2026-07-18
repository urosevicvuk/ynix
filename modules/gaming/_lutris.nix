{self, ...}: {
  flake.nixosModules.lutris = {...}: {
    home-manager.sharedModules = [self.homeModules.lutris];
  };

  flake.homeModules.lutris = {...}: {
    programs.lutris = {
      enable = true;
    };
  };
}
