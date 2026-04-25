{self, ...}: {
  flake.nixosModules.carapace = {...}: {
    home-manager.sharedModules = [self.homeModules.carapace];
  };

  flake.homeModules.carapace = {pkgs, ...}: {
    programs.carapace = {
      enable = true;
      enableNushellIntegration = true;
      enableBashIntegration = true;
      ignoreCase = true;
    };
  };
}
