{self, ...}: {
  flake.nixosModules.shell.imports = [self.nixosModules.atuin];

  flake.nixosModules.atuin = {...}: {
    home-manager.sharedModules = [self.homeModules.atuin];
  };

  flake.homeModules.atuin = {pkgs, ...}: {
    programs.atuin = {
      enable = true;
      enableNushellIntegration = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
    };
  };
}
