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

    # Storage modules - Ceph OSD
    # TODO: Future Ceph deployment
    # ../../modules-nixos/cluster/ceph-osd.nix
    # ../../modules-nixos/cluster/ceph-mon.nix  # If also running MON daemon

    # Host-specific configuration
    ./variables.nix
    # ./hardware-configuration.nix  # Will be generated during installation
    # ./disko.nix                    # Disk configuration for OSDs
  ];

  # Ceph OSD services will be configured here
  # services.ceph = {
  #   enable = true;
  #   role = "osd";
  # };

  home-manager.users."${config.var.username}" = import ./home.nix;

  system.stateVersion = "24.05";
}
