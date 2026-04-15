{
  self,
  config,
  inputs,
  ...
}:
let
  hm = config.flake.homeModules;
in
{
  flake.nixosConfigurations.firelink = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.firelink
    ];
  };

  flake.nixosModules.firelink = {config, pkgs, lib, ...}: {
    imports = [
      self.nixosModules.base
      self.nixosModules.cluster
      self.nixosModules.docker

      inputs.sops-nix.nixosModules.sops
      ./_hardware/firelink.nix
    ];

    networking.hostName = "firelink";
    system.stateVersion = "24.05";

    # System-level sops secrets
    sops = {
      age.sshKeyPaths = ["/home/vyke/.ssh/id_ed25519"];
      defaultSopsFormat = "yaml";

      secrets = {
        "cloudflare-tunnel-token" = {
          sopsFile = ../../secrets/server/cloudflare.yaml;
          key = "tunnel_token";
          mode = "0400";
        };

        "cloudflare-ddns-token" = {
          sopsFile = ../../secrets/server/cloudflare.yaml;
          key = "dns_token";
          mode = "0400";
        };

        "cloudflare-zone-id" = {
          sopsFile = ../../secrets/server/cloudflare.yaml;
          key = "zone_id";
          mode = "0400";
        };
      };
    };

    # Explicitly add dev HM modules to firelink (server has base + cluster, no desktop/dev nixos groups)
    home-manager.users.${config.preferences.username} = {
      imports = [hm.dev];
      home.stateVersion = "24.05";

      home.packages = with pkgs; [
        jq
        just
        fastfetch
        tailscale
      ];
    };
  };
}
