{self, ...}: {
  # Self-registers into the `apps` group (merged with the other apps modules).
  flake.nixosModules.apps.imports = [self.nixosModules.zathura];

  flake.nixosModules.zathura = {...}: {
    home-manager.sharedModules = [self.homeModules.zathura];
  };

  flake.homeModules.zathura = {...}: {
    programs.zathura.enable = true;
  };
}
