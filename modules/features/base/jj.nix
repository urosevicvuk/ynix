{self, ...}: {
  flake.nixosModules.jj = {...}: {
    home-manager.sharedModules = [self.homeModules.jj];
  };

  flake.homeModules.jj = {pkgs, ...}: {
    programs = {
      jujutsu = {
        enable = true;
        ediff = true;
        settings = {
          # here we would add more settings and configure it properly
          # TODO: when I decide to use this, I will add more settings
        };
      };
      jjui = {
        enable = true;
      };
    };
  };
}
