# Server firewall configuration
{...}: {
  flake.nixosModules.clusterFirewall = {lib, ...}: {
    networking.firewall = {
      enable = true;

      allowedTCPPorts = [
        80
        443
      ];

      allowPing = lib.mkForce true;
      logRefusedConnections = false;
    };
  };
}
