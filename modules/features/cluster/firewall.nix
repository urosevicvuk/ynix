# Server firewall configuration
{...}: {
  flake.nixosModules.cluster = {lib, ...}: {
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
