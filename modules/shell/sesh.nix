{self, ...}: {
  # Self-registers into the `shell` group (merged with the other shell modules).
  flake.nixosModules.shell.imports = [self.nixosModules.sesh];

  flake.nixosModules.sesh = {...}: {
    home-manager.sharedModules = [self.homeModules.sesh];
  };

  flake.homeModules.sesh = {lib, ...}: {
    programs.sesh = {
      enable = true;
      enableAlias = false;
      enableTmuxIntegration = false;
      icons = true;
    };
  };
}
