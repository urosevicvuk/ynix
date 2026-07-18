{self, ...}: {
  # Self-registers into the `apps` group (merged with the other apps modules).
  flake.nixosModules.apps.imports = [self.nixosModules.obsidian];

  flake.nixosModules.obsidian = {...}: {
    home-manager.sharedModules = [self.homeModules.obsidian];
  };

  flake.homeModules.obsidian = {pkgs, ...}: {
    programs.obsidian = {
      enable = true;
      vaults = {
        master = {
          enable = true;
          target = "/Documents/obsidian/master";
        };
      };
      cli.enable = true;
    };
  };
}
