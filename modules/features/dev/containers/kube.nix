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

        # Tell k9s which skin to load (-> ~/.config/k9s/config.yaml)
        settings.k9s.ui.skin = "gruvbox-dark";

        # Each key -> ~/.config/k9s/skins/<key>.yaml
        skins = {
          gruvbox-dark = ./skins/gruvbox-dark.yaml;
          # add more skins here, then point ui.skin above at one to switch
        };

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
