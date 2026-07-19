{self, ...}: {
  # Self-registers into the `shell` group (merged with the other shell modules).
  flake.nixosModules.shell.imports = [self.nixosModules.zoxide];

  flake.nixosModules.zoxide = {...}: {
    home-manager.sharedModules = [self.homeModules.zoxide];
  };

  flake.homeModules.zoxide = {...}: {
    programs.zoxide = {
      enable = true;
      enableNushellIntegration = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
    };
  };
}
