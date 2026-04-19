{self, ...}: {
  flake.homeModules.obsidian = {pkgs, ...}: {
    home.packages = with pkgs; [
      obsidian
    ];
  };

  flake.nixosModules.obsidian = {...}: {
    home-manager.sharedModules = [self.homeModules.obsidian];
  };
}
