{self, ...}: {
  flake.nixosModules.bat = {...}: {
    home-manager.sharedModules = [self.homeModules.bat];
  };

  flake.homeModules.bat = {pkgs, ...}: {
    programs.bat = {
      enable = true;

      #we can theme it more, but idk what i need yet
    };
  };
}
