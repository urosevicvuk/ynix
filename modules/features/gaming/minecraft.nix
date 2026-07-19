{self, ...}: {
  # Self-registers into the `gaming` group (merged with the other gaming modules).
  flake.nixosModules.gaming.imports = [self.nixosModules.minecraft];

  flake.nixosModules.minecraft = {...}: {
    home-manager.sharedModules = [self.homeModules.minecraft];
  };

  flake.homeModules.minecraft = {...}: {
    programs.prismlauncher = {
      enable = true;
    };
  };
}
