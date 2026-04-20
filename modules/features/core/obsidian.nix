{self, ...}: {
  # TODO: add stylix support config for this shit
  flake.nixosModules.obsidian = {...}: {
    home-manager.sharedModules = [self.homeModules.obsidian];
  };

  flake.homeModules.obsidian = {pkgs, ...}: {
    home.packages = with pkgs; [
      obsidian
    ];
  };
}
