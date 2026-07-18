{self, ...}: {
  # Self-registers into the `apps` group (merged with the other apps modules).
  flake.nixosModules.apps.imports = [self.nixosModules.aerc];

  flake.nixosModules.aerc = {pkgs, ...}: {
    home-manager.sharedModules = [self.homeModules.aerc];
  };

  flake.homeModules.aerc = {...}: {
    programs.aerc = {
      enable = true;
    };
  };
}
