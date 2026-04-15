{
  flake.nixosModules.base = { ... }: {
        services.tailscale = {
          enable = true;
          openFirewall = true;
        };
        networking = {
          firewall = {
            trustedInterfaces = [ "tailscale0" ];
            checkReversePath = "loose";
          };
          hosts = {
            "100.114.242.127" = [ "anorlondo" ];
            "100.98.108.115" = [ "ariandel" ];
            "100.65.95.49" = [ "estus" ];
            "100.65.172.104" = [ "firelink" ];
          };
        };
  };
}
