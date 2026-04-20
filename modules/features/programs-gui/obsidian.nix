{self, ...}: {
  flake.nixosModules.obsidian = {...}: {
    home-manager.sharedModules = [self.homeModules.obsidian];
  };

  flake.homeModules.obsidian = {pkgs, ...}: {
    programs.obsidian = {
      enable = true;
      vaults = {
        master = {
          enable = true;
          target = "/obsidian/master";
        };
      };
      cli.enable = true;
    };
  };
}
