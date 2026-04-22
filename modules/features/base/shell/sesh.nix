{self, ...}: {
  flake.nixosModules.sesh = {...}: {
    home-manager.sharedModules = [self.homeModules.sesh];
  };

  flake.homeModules.sesh = {pkgs, ...}: {
    programs.sesh = {
      enable = true;
      enableAlias = false;
      enableTmuxIntegration = false;
      icons = true;
    };
  };
}
