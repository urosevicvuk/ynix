# Server firewall configuration
# Base firewall rules for server hosts
{lib, ...}: {
  networking.firewall = {
    enable = true;

    # HTTP/HTTPS for web services
    allowedTCPPorts = [
      80 # HTTP
      443 # HTTPS
    ];

    # Allow ICMP ping
    allowPing = lib.mkForce true;

    # Log dropped packets for debugging (optional)
    logRefusedConnections = false;
  };
}
