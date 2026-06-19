# Storage prerequisites for Longhorn distributed storage
{...}: {
  flake.nixosModules.clusterStorage = {pkgs, ...}: {
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

    environment.systemPackages = with pkgs; [
      nfs-utils
      openiscsi
    ];

    systemd.tmpfiles.rules = [
      "L+ /usr/sbin/iscsiadm - - - - /run/current-system/sw/bin/iscsiadm"
    ];
  };
}
