# k3s server. DISABLED (leading `_`: import-tree skips this file); rke2.nix is
# the active Kubernetes. To switch back: rename this to k3s.nix and rke2.nix to
# _rke2.nix. Never both: they claim the same ports.
#
# Multi-node: the first server starts with --cluster-init (embedded etcd).
# Others join with, in their host config:
#   services.k3s.serverAddr = "https://firelink1:6443";
#   services.k3s.tokenFile = "/var/lib/rancher/k3s/token";  # copy of firelink1:/var/lib/rancher/k3s/server/token
# (--cluster-init is only passed while serverAddr is empty.)
{self, ...}: {
  flake.nixosModules.server.imports = [self.nixosModules.k3s];

  flake.nixosModules.k3s = {
    config,
    lib,
    pkgs,
    ...
  }: {
    services.k3s = {
      enable = true;
      role = "server";
      extraFlags =
        toString (
          # Embedded etcd instead of SQLite on the first server, so others can
          # join later. Joining servers (serverAddr set) skip it.
          lib.optional (config.services.k3s.serverAddr == "") "--cluster-init"
          ++ [
            "--disable=traefik"
            "--disable=servicelb"
            "--disable=local-storage"
            "--flannel-backend=none"
            "--disable-network-policy"
            "--disable-kube-proxy"
            "--write-kubeconfig-mode=644"
            "--kubelet-arg=max-pods=250"
            # Same networks as rke2.nix and ykube's Cilium values.
            "--cluster-cidr=10.244.0.0/16"
            "--service-cidr=10.96.0.0/16"
            "--cluster-dns=10.96.0.10"
          ]
        )
        + " --tls-san=${config.networking.hostName}";
    };

    services.openiscsi = {
      enable = true;
      name = "iqn.2024-01.org.nixos:initiator";
    };

    systemd.services.iscsid.serviceConfig = {
      PrivateMounts = "yes";
      BindPaths = "/run/current-system/sw/bin:/bin";
    };

    boot.kernelPackages = lib.mkForce pkgs.linuxPackages_6_12;

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
        2379 # etcd clients (other k3s servers)
        2380 # etcd peers
        10250
        4240
        4244
      ];

      allowedUDPPorts = [
        8472
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
