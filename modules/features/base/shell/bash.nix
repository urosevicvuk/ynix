{self, ...}: {
  flake.nixosModules.bash = {...}: {
    home-manager.sharedModules = [self.homeModules.bash];
  };

  flake.homeModules.bash = {pkgs, ...}: {
    programs.bash = {
      enable = true;
      enableCompletion = true;
    };
  };
}
