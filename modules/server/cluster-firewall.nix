# Server firewall configuration
{self, ...}: {
  # Self-registers into the `server` group (merged with the other server modules).
  flake.nixosModules.server.imports = [self.nixosModules.clusterFirewall];

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
