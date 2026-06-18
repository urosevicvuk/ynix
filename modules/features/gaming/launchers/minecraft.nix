{self, ...}: {
  flake.nixosModules.minecraft = {...}: {
    home-manager.sharedModules = [self.homeModules.minecraft];
  };

  flake.homeModules.minecraft = {...}: {
    programs.prismlauncher = {
      enable = true;
    };
  };
}
