{self, ...}: {
  flake.nixosModules.k3s = {
    config,
    pkgs,
    ...
  }: {
    services.k3s = {
      enable = true;
      role = "server";
      extraFlags =
        toString [
          "--disable=traefik"
          "--write-kubeconfig-mode=644"
        ]
        + " --tls-san=${config.networking.hostName}";
    };

    networking.firewall.allowedTCPPorts = [
      6443
      10250
    ];

    environment.systemPackages = with pkgs; [
      kubectl
      kubernetes-helm
      stern
      kubectx
      k3s
      kubeseal
    ];

    environment.sessionVariables.KUBECONFIG = "/etc/rancher/k3s/k3s.yaml";

    home-manager.sharedModules = [self.homeModules.k3s];
  };

  flake.homeModules.k3s = {...}: {
    programs.k9s = {
      enable = true;
      plugins = [
        #we can add pluginsto k9s here
      ];
    };
  };
}
