# Storage prerequisites for Longhorn distributed storage
# Longhorn requires iSCSI for block storage operations
{pkgs, ...}: {
  # iSCSI initiator for Longhorn
  services.openiscsi = {
    enable = true;
    name = "iqn.2024-01.org.nixos:initiator";
  };

  systemd.services.iscsid.serviceConfig = {
    PrivateMounts = "yes";
    BindPaths = "/run/current-system/sw/bin:/bin";
  };

  # Required kernel modules for iSCSI
  boot.kernelModules = ["iscsi_tcp"];

  # NFSv4 support for potential NFS volumes
  boot.supportedFilesystems = ["nfs"];

  # Utilities for storage management
  environment.systemPackages = with pkgs; [
    nfs-utils
    openiscsi
  ];

  # Make iscsiadm available at standard Linux path for Longhorn compatibility
  # Longhorn containers expect iscsiadm in /usr/sbin, but NixOS keeps it in /run/current-system/sw/bin
  systemd.tmpfiles.rules = [
    "L+ /usr/sbin/iscsiadm - - - - /run/current-system/sw/bin/iscsiadm"
  ];
}
