{self, ...}: {
  # Self-registers into the `dev` group (merged with the other dev modules).
  flake.nixosModules.dev.imports = [self.nixosModules.cursor];

  flake.nixosModules.cursor = {...}: {
    home-manager.sharedModules = [self.homeModules.cursor];
  };

  flake.homeModules.cursor = {pkgs, ...}: {
    home.packages = with pkgs; [
      code-cursor
    ];
  };
}
