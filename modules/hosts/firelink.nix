{
  self,
  inputs,
  ...
}: {
  flake.nixosConfigurations.firelink = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.firelink
    ];
  };

  flake.nixosModules.firelink = { pkgs, ... }: {
    imports = [
      self.nixosModules.core
      self.nixosModules.cluster

      inputs.sops-nix.nixosModules.sops
      ./_hardware/firelink.nix
    ];

    networking.hostName = "firelink";
    system.stateVersion = "24.05";

    # Inline docker (not using services group on server)
    virtualisation.docker.enable = true;
    users.users.vyke.extraGroups = [ "docker" ];
    environment.systemPackages = with pkgs; [
      lazydocker
      docker-compose
    ];

    # System-level sops secrets
    sops = {
      age.sshKeyPaths = [ "/home/vyke/.ssh/id_ed25519" ];
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

    # Explicitly add nvim to firelink (server has core + cluster, no programs group)
    home-manager.users.vyke = {
      imports = [ self.homeManagerModules.nvim ];
      home.stateVersion = "24.05";

      home.packages = with pkgs; [
        jq
        just
        wireguard-tools
        nh
        zip
        unzip
        optipng
        fastfetch
        btop
        tailscale
        claude-code
      ];
    };
  };
}
