{self, ...}: {
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
