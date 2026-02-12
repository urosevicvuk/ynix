# K3s Kubernetes distribution - single-node learning/production setup
# Manages minimal K8s infrastructure, everything else runs inside the cluster
{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (config.var) hostname;
  # Extra TLS SANs for remote access (e.g., Tailscale IP)
  # Add your Tailscale IP here when deploying to firelink
  extraSans = [
    # "100.x.x.x"  # Tailscale IP for remote kubectl access
  ];
  allSans = [hostname] ++ extraSans;
  sanFlags = lib.concatMapStrings (san: " --tls-san=${san}") allSans;
in {
  services.k3s = {
    enable = true;
    role = "server";
    extraFlags =
      toString [
        "--disable=traefik" # Install ourselves via Helm to learn
        "--write-kubeconfig-mode=644" # Allow non-root kubeconfig access
      ]
      + sanFlags;
  };

  # K3s API and kubelet ports
  networking.firewall.allowedTCPPorts = [
    6443 # K8s API server
    10250 # Kubelet API
  ];

  # K8s CLI tools for cluster management
  environment.systemPackages = with pkgs; [
    kubectl # K8s CLI
    kubernetes-helm # Package manager for K8s
    k9s # Terminal UI for K8s
    stern # Multi-pod log tailing
    kubectx # Context/namespace switcher
    k3s # K3s CLI (includes crictl)
    kubeseal # Sealed secrets CLI
  ];

  # Point kubectl to K3s kubeconfig automatically
  environment.sessionVariables.KUBECONFIG = "/etc/rancher/k3s/k3s.yaml";
}
