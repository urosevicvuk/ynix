{self, ...}: {
  flake.nixosModules.kube = {...}: {
    home-manager.sharedModules = [self.homeModules.kube];
  };

  flake.homeModules.kube = {
    config,
    pkgs,
    ...
  }: {
    home.packages = with pkgs; [
      kubectl
      kubectx
    ];
    home.sessionVariables.KUBECONFIG = "${config.home.homeDirectory}/.kube/firelink.yaml";
  };
}
