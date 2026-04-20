{self, ...}: {
  flake.nixosModules.figma = {...}: {
    home-manager.sharedModules = [self.homeModules.figma];
  };

  flake.homeModules.figma = {pkgs, ...}: {
    home.packages = with pkgs; [
      figma-linux
    ];
  };
}
