{self, ...}: {
  # Self-registers into the `creative` group (merged with the other creative modules).
  flake.nixosModules.creative.imports = [self.nixosModules.figma];

  flake.nixosModules.figma = {...}: {
    home-manager.sharedModules = [self.homeModules.figma];
  };

  flake.homeModules.figma = {pkgs, ...}: {
    home.packages = with pkgs; [
      figma-linux
    ];
  };
}
