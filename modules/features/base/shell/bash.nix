{self, ...}: {
  flake.nixosModules.bash = {...}: {
    home-manager.sharedModules = [self.homeModules.bash];
    programs.bash = {
      enable = true;
      completion.enable = true;
    };
  };

  flake.homeModules.bash = {pkgs, ...}: {
    programs.bash.enable = true;
  };
}
