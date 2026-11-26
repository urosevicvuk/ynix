# RKE2 server (the active Kubernetes; _k3s.nix is the parked alternative).
# Every node is a server: control plane + etcd + workloads. CIS profile, no
# bundled CNI / kube-proxy / ingress: ykube installs Cilium and Envoy Gateway.
#
# First server (firelink1): nothing extra, it creates the cluster.
# Others join with, in their host config:
#   services.rke2.serverAddr = "https://firelink1:9345";
#   services.rke2.tokenFile = "/var/lib/rancher/rke2/token";  # copy of firelink1:/var/lib/rancher/rke2/server/token
#
# On a node: sudo -i, then kubectl / crictl / etcdctl work as is (env below).
{self, ...}: {
  flake.nixosModules.server.imports = [self.nixosModules.rke2];

  flake.nixosModules.rke2 = {
    config,
    lib,
    pkgs,
    ...
  }: let
    yaml = pkgs.formats.yaml {};

    # Pod Security: RKE2's CIS profile would enforce `restricted` on every
    # namespace. Enforce `baseline` instead (warn/audit at restricted);
    # namespaces that need more label themselves `privileged` in ykube.
    psaConfig = yaml.generate "rke2-pod-security.yaml" {
      apiVersion = "apiserver.config.k8s.io/v1";
      kind = "AdmissionConfiguration";
      plugins = [
        {
          name = "PodSecurity";
          configuration = {
            apiVersion = "pod-security.admission.config.k8s.io/v1";
            kind = "PodSecurityConfiguration";
            defaults = {
              enforce = "baseline";
              enforce-version = "latest";
              audit = "restricted";
              audit-version = "latest";
              warn = "restricted";
              warn-version = "latest";
            };
            exemptions = {
              usernames = [];
              runtimeClasses = [];
              namespaces = ["kube-system"];
            };
          };
        }
      ];
    };

    rke2Config = yaml.generate "rke2-config.yaml" {
      # Same networks as _k3s.nix and ykube's Cilium values.
      cluster-cidr = "10.244.0.0/16";
      service-cidr = "10.96.0.0/16";
      cluster-dns = "10.96.0.10";
      tls-san = [config.networking.hostName "${config.networking.hostName}.lan" "127.0.0.1" "localhost"];

      disable-kube-proxy = true; # Cilium replaces it
      pod-security-admission-config-file = "/etc/rancher/rke2/pod-security.yaml";
      write-kubeconfig-mode = "0644"; # like k3s on the old firelink

      # Metrics for kube-prometheus-stack (RKE2 binds these to 127.0.0.1).
      etcd-expose-metrics = true;
      kube-controller-manager-arg = ["bind-address=0.0.0.0"];
      kube-scheduler-arg = ["bind-address=0.0.0.0"];

      kubelet-arg = ["max-pods=250"];

      # etcd snapshots every 6 h, a week kept (`rke2 etcd-snapshot ls`).
      etcd-snapshot-schedule-cron = "0 */6 * * *";
      etcd-snapshot-retention = 28;
    };
  in {
    environment.etc."rancher/rke2/pod-security.yaml".source = psaConfig;

    services.rke2 = {
      enable = true;
      # Pinned minor; upgrade one minor at a time, after checking Cilium/Rook.
      package = pkgs.rke2_1_36;
      role = "server";
      configPath = rke2Config;
      cni = "none";
      cisHardening = true;
      disable = ["rke2-ingress-nginx"];
      gracefulNodeShutdown.enable = true;
    };

    # Same kernel line as the old k3s firelink.
    boot.kernelPackages = lib.mkForce pkgs.linuxPackages_6_12;

    # Ceph CSI maps RBD volumes in the kernel; its pods can't modprobe on
    # NixOS, so load the modules up front and give them a /lib/modules.
    boot.kernelModules = ["overlay" "br_netfilter" "rbd" "ceph"];
    systemd.tmpfiles.rules = [
      "d /opt/cni/bin 0755 root root -"
      "d /etc/cni/net.d 0755 root root -"
      "L+ /lib/modules - - - - /run/booted-system/kernel-modules/lib/modules"
    ];

    boot.kernel.sysctl = {
      "net.ipv4.ip_forward" = 1;
      "fs.inotify.max_user_instances" = 8192;
      "fs.inotify.max_user_watches" = 1048576;
      "vm.max_map_count" = 262144;
    };

    # The kubelet refuses to run with swap.
    swapDevices = lib.mkForce [];
    zramSwap.enable = lib.mkForce false;

    networking.firewall = {
      enable = true;
      allowedTCPPorts = [
        80
        443
        6443 # Kubernetes API
        9345 # RKE2 supervisor (joins)
        2379 # etcd clients
        2380 # etcd peers
        2381 # etcd metrics
        10250 # kubelet
        10257 # controller-manager metrics
        10259 # scheduler metrics
        4240 # Cilium health
        4244 # Hubble
      ];
      allowedUDPPorts = [8472]; # Cilium VXLAN, if used
      # Pod traffic reaches the host through Cilium's lxc devices.
      trustedInterfaces = ["cilium_host" "cilium_net" "lxc+"];
      checkReversePath = lib.mkDefault "loose";
      allowPing = lib.mkForce true;
      logRefusedConnections = false;
    };

    environment.systemPackages = with pkgs; [
      kubectl
      kubernetes-helm
      stern
      kubectx
      cilium-cli
      hubble
      cri-tools
      etcd
    ];

    environment.variables = {
      KUBECONFIG = "/etc/rancher/rke2/rke2.yaml";
      CRI_CONFIG_FILE = "/var/lib/rancher/rke2/agent/etc/crictl.yaml";
      ETCDCTL_ENDPOINTS = "https://127.0.0.1:2379";
      ETCDCTL_CACERT = "/var/lib/rancher/rke2/server/tls/etcd/server-ca.crt";
      ETCDCTL_CERT = "/var/lib/rancher/rke2/server/tls/etcd/server-client.crt";
      ETCDCTL_KEY = "/var/lib/rancher/rke2/server/tls/etcd/server-client.key";
    };
  };
}
