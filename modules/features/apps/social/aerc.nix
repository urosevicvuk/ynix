{self, ...}: {
  flake.nixosModules.aerc = {pkgs, ...}: {
    home-manager.sharedModules = [self.homeModules.aerc];
  };

  flake.homeModules.aerc = {...}: {
    programs.aerc = {
      enable = true;
    };
  };
}
