# Tailscale is a VPN service that makes it easy to connect your devices between each other.
{...}: {
  services.tailscale = {
    enable = true;
    openFirewall = true;
  };

  networking.firewall = {
    trustedInterfaces = ["tailscale0"];
    # required to connect to Tailscale exit nodes
    checkReversePath = "loose";
  };
}
