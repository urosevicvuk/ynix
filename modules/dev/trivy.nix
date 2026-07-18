{self, ...}: {
  # Self-registers into the `dev` group (merged with the other dev modules).
  flake.nixosModules.dev.imports = [self.nixosModules.trivy];

  flake.nixosModules.trivy = {...}: {
    home-manager.sharedModules = [self.homeModules.trivy];
  };

  flake.homeModules.trivy = {pkgs, ...}: {
    home.packages = with pkgs; [
      trivy
      lazytrivy
    ];
  };
}
