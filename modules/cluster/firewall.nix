# Server firewall configuration
{ ... }:
{
  flake.modules.nixos.cluster = [
    (
      { lib, ... }:
      {
        networking.firewall = {
          enable = true;

          allowedTCPPorts = [
            80
            443
          ];

          allowPing = lib.mkForce true;
          logRefusedConnections = false;
        };
      }
    )
  ];
}
