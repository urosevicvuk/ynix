{config, ...}: {
  services.ddns-updater = {
    enable = true;
    environment = {
      SERVER_ENABLED = "no";
      CONFIG_FILEPATH = "/etc/ddns-updater/config.json";
      PERIOD = "5m";
    };
  };

  environment.etc."ddns-updater/config.json" = {
    text = builtins.toJSON {
      settings = [
        {
          provider = "cloudflare";
          zone_identifier = config.sops.secrets.cloudflare-zone-id.path;
          domain = "game.urosevicvuk.dev";
          ttl = 1;
          token_file = config.sops.secrets.cloudflare-ddns-token.path;
          proxied = false;
          ip_version = "ipv4";
        }
      ];
    };
    mode = "0640";
    group = "ddns-updater";
  };

  # Open firewall ports for game servers
  networking.firewall = {
    allowedTCPPorts = [25565 25566 7777 7778];
    allowedUDPPorts = [7777 7778];
  };

  # Create data directory
  systemd.tmpfiles.rules = [
    "d /var/lib/game-servers 0755 root root -"
  ];
}
