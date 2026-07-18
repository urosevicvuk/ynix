{self, ...}: {
  # Self-registers into the `shell` group (merged with the other shell modules).
  flake.nixosModules.shell.imports = [self.nixosModules.carapace];

  flake.nixosModules.carapace = {...}: {
    home-manager.sharedModules = [self.homeModules.carapace];
  };

  flake.homeModules.carapace = {pkgs, ...}: {
    programs.carapace = {
      enable = true;
      enableNushellIntegration = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      ignoreCase = true;
    };
  };
}
