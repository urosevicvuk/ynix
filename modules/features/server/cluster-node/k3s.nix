{self, ...}: {
  flake.nixosModules.k3s = {
    config,
    pkgs,
    ...
  }: {
    # k3s tuned to hand networking + LB + policy over to Cilium.
    # See apps/system/networking/cilium/values.yaml in ykube for the matching Helm values.
    services.k3s = {
      enable = true;
      role = "server";
      extraFlags =
        toString [
          "--disable=traefik" # Gateway API + Cilium Gateway instead
          "--disable=servicelb" # Cilium L2 announces LB IPs
          "--flannel-backend=none" # Cilium replaces the CNI
          "--disable-network-policy" # Cilium enforces NetworkPolicies + CiliumNetworkPolicies
          "--disable-kube-proxy" # Cilium replaces kube-proxy
          "--write-kubeconfig-mode=644"
          "--kubelet-arg=max-pods=250" # default 110 is too tight for this homelab's pod density
        ]
        + " --tls-san=${config.networking.hostName}";
    };

    networking.firewall.allowedTCPPorts = [
      6443
      10250
      4240 # cilium-health
      4244 # hubble peer
    ];
    networking.firewall.allowedUDPPorts = [
      8472 # cilium VXLAN
    ];

    networking.firewall.extraCommands = ''
      iptables -A nixos-fw -i lxc+ -j nixos-fw-accept
    '';

    environment.systemPackages = with pkgs; [
      kubectl
      kubernetes-helm
      stern
      kubectx
      k3s
      cilium-cli
      hubble
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
