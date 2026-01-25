{ config, ... }:
{
  imports = [
    # Core system modules
    ../../modules-nixos/system/nix.nix
    ../../modules-nixos/system/systemd.nix
    ../../modules-nixos/system/users.nix
    ../../modules-nixos/system/utils.nix
    ../../modules-nixos/system/home-manager.nix
    ../../modules-nixos/system/locale.nix
    ../../modules-nixos/system/environment.nix
    ../../modules-nixos/system/security.nix

    # Network modules
    ../../modules-nixos/network/networking.nix
    ../../modules-nixos/network/tailscale.nix
    ../../modules-nixos/network/firewall.nix

    # Server modules
    ../../modules-nixos/server/ssh.nix

    # Cluster modules - Worker Only
    # TODO: Future separated architecture
    # ../../modules-nixos/cluster/k3s-worker.nix
    # ../../modules-nixos/cluster/ceph-client.nix  # Mount Ceph volumes

    # Host-specific configuration
    ./variables.nix
    # ./hardware-configuration.nix  # Will be generated during installation
  ];

  # Docker/containerd for running pods
  # virtualisation.docker.enable = true;

  home-manager.users."${config.var.username}" = import ./home.nix;

  system.stateVersion = "24.05";
}
