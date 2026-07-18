{self, ...}: {
  # Self-registers into the `dev` group (merged with the other dev modules).
  flake.nixosModules.dev.imports = [self.nixosModules.kube];

  flake.nixosModules.kube = { config, ...}: {
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

    home.sessionVariables = {
      KUBECONFIG = "~/.kube/firelink.kubeconfig";
    };
  };
}
