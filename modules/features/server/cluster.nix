{self, ...}: {
  flake.nixosModules.server.imports = [self.nixosModules.cluster];

  flake.nixosModules.cluster = {
    config,
    lib,
    pkgs,
    ...
  }: {
    services.k3s = {
      enable = true;
      role = "server";
      extraFlags =
        toString [
          "--disable=traefik"
          "--disable=servicelb"
          "--disable=local-storage"
          "--flannel-backend=none"
          "--disable-network-policy"
          "--disable-kube-proxy"
          "--write-kubeconfig-mode=644"
          "--kubelet-arg=max-pods=250"
        ]
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
