{ config, pkgs, ... }:
let
  # Wrapper script that reads the token and runs cloudflared
  cloudflaredScript = pkgs.writeShellScript "cloudflared-tunnel-start" ''
    TOKEN=$(cat ${config.sops.secrets.cloudflare-tunnel-token.path})
    exec ${pkgs.cloudflared}/bin/cloudflared tunnel --no-autoupdate run --token "$TOKEN"
  '';
in
{
  # Cloudflare Tunnel (cloudflared)
  # Creates a secure tunnel from this server to Cloudflare
  # No public IP or port forwarding needed!

  systemd.services.cloudflared-tunnel = {
    description = "Cloudflare Tunnel";
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      Type = "simple";
      Restart = "always";
      RestartSec = "5s";
      # Call the wrapper script directly
      ExecStart = "${cloudflaredScript}";
      # Run as root to access SOPS secrets
      User = "root";
      Group = "root";
    };
  };

  environment.systemPackages = [ pkgs.cloudflared ];
}
