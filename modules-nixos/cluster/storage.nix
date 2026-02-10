# Storage prerequisites for Longhorn distributed storage
# Longhorn requires iSCSI for block storage operations
{ pkgs, ... }:
{
  # iSCSI initiator for Longhorn
  services.openiscsi = {
    enable = true;
    name = "iqn.2024-01.org.nixos:initiator";
  };

  # Required kernel modules for iSCSI
  boot.kernelModules = [ "iscsi_tcp" ];

  # NFSv4 support for potential NFS volumes
  boot.supportedFilesystems = [ "nfs" ];

  # Utilities for storage management
  environment.systemPackages = with pkgs; [
    nfs-utils
    openiscsi
  ];
}
