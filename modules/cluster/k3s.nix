{ ... }:
{
  flake.modules.nixos.cluster = [
    (
      {
        config,
        pkgs,
        ...
      }:
      {
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
          k9s
          stern
          kubectx
          k3s
          kubeseal
        ];

        environment.sessionVariables.KUBECONFIG = "/etc/rancher/k3s/k3s.yaml";
      }
    )
  ];
}
