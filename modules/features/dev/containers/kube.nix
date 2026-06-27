{self, ...}: {
  flake.nixosModules.kube = {...}: {
    home-manager.sharedModules = [self.homeModules.kube];
  };

  flake.homeModules.kube = {
    config,
    pkgs,
    ...
  }: {
    programs = {
      kubeswitch = {
        enable = true;
      };
      kubecolor = {
        enable = true;
        enableAlias = true;
      };
      k9s = {
        enable = true;

        plugins = [
          #we can add plugins to k9s here
        ];
      };
    };

    home.packages = with pkgs; [
      kubectl
      kubectx
    ];
  };
}
