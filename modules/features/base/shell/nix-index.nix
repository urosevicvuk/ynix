{self, ...}: {
  flake.nixosModules.nixIndex = {...}: {
    home-manager.sharedModules = [self.homeModules.nixIndex];
  };

  flake.homeModules.nixIndex = {...}: {
    programs.nix-index = {
      enable = true;
    };
  };
}
