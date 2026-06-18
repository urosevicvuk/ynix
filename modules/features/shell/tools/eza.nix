{self, ...}: {
  flake.nixosModules.eza = {...}: {
    home-manager.sharedModules = [self.homeModules.eza];
  };

  flake.homeModules.eza = {...}: {
    programs.eza = {
      enable = true;
      enableBashIntegration = true;
      icons = "auto";
      extraOptions = [
        "--group-directories-first"
        "--no-quotes"
        "--icons=always"
        "--long"
      ];
    };
  };
}
