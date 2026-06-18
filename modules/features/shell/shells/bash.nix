{self, ...}: {
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
