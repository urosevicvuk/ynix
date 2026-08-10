# k3s cluster node: control plane, Longhorn storage prerequisites, firewall
{self, ...}: {
  # Self-registers into the `server` group (merged with the other server modules).
  flake.nixosModules.server.imports = [self.nixosModules.cluster];

  flake.nixosModules.cluster = {
    config,
    lib,
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
          "--disable=local-storage" # Longhorn is the cluster's only StorageClass
          "--flannel-backend=none" # Cilium replaces the CNI
          "--disable-network-policy" # Cilium enforces NetworkPolicies + CiliumNetworkPolicies
          "--disable-kube-proxy" # Cilium replaces kube-proxy
          "--write-kubeconfig-mode=644"
          "--kubelet-arg=max-pods=250" # default 110 is too tight for this homelab's pod density
        ]
        + " --tls-san=${config.networking.hostName}";
    };

    # Storage prerequisites for Longhorn distributed storage
    services.openiscsi = {
      enable = true;
      name = "iqn.2024-01.org.nixos:initiator";
    };

    systemd.services.iscsid.serviceConfig = {
      PrivateMounts = "yes";
      BindPaths = "/run/current-system/sw/bin:/bin";
    };

    boot.kernelModules = ["iscsi_tcp"];
    boot.supportedFilesystems = ["nfs"];

    services.rpcbind.enable = true;

    systemd.tmpfiles.rules = [
      "L+ /usr/sbin/iscsiadm - - - - /run/current-system/sw/bin/iscsiadm"
    ];

    networking.firewall = {
      enable = true;

      allowedTCPPorts = [
        80
        443
        6443
        10250
        4240 # cilium-health
        4244 # hubble peer
      ];

      allowedUDPPorts = [
        8472 # cilium VXLAN
      ];

      extraCommands = ''
        iptables -A nixos-fw -i lxc+ -j nixos-fw-accept
      '';

      allowPing = lib.mkForce true;
      logRefusedConnections = false;
    };

    environment.systemPackages = with pkgs; [
      kubectl
      kubernetes-helm
      stern
      kubectx
      k3s
      cilium-cli
      hubble
      nfs-utils
      openiscsi
    ];

    environment.sessionVariables.KUBECONFIG = "/etc/rancher/k3s/k3s.yaml";
  };
}
