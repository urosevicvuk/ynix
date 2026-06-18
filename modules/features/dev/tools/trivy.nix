{self, ...}: {
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
