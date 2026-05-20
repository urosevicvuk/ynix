{self, ...}: {
  flake.nixosModules.kube = {...}: {
    home-manager.sharedModules = [self.homeModules.kube];
  };

  flake.homeModules.kube = {pkgs, ...}: {
    home.packages = with pkgs; [
      kubectl
      kubectx
    ];
  };
}
