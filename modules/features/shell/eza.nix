{self, ...}: {
  # Self-registers into the `shell` group (merged with the other shell modules).
  flake.nixosModules.shell.imports = [self.nixosModules.eza];

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
