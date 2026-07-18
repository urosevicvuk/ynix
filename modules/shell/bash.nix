{self, ...}: {
  # Self-registers into the `shell` group (merged with the other shell modules).
  flake.nixosModules.shell.imports = [self.nixosModules.bash];

  flake.nixosModules.bash = {...}: {
    programs.bash = {
      enable = true;
    };

    home-manager.sharedModules = [self.homeModules.bash];
  };

  flake.homeModules.bash = {pkgs, ...}: {
    home.shell.enableBashIntegration = true;
    programs.bash = {
      enable = true;

      historySize = 100000;
      historyFileSize = 100000;

      shellAliases = {
        gitui = "lazygit";
        ssh = "kitten ssh";
      };
    };
  };
}
