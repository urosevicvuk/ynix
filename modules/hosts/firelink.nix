{ self, inputs, ... }:
{
  flake.nixosConfigurations.firelink = inputs.nixpkgs.lib.nixosSystem {
    modules = [ self.nixosModules.firelink ];
  };

  flake.nixosModules.firelink =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    {
      imports = [
        self.nixosModules.base
        self.nixosModules.cluster

        inputs.home-manager.nixosModules.default
        inputs.sops-nix.nixosModules.sops
        ./_hardware/firelink.nix
      ];

      networking.hostName = "firelink";
      system.stateVersion = "24.05";

      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        backupFileExtension = "hm-backup";
        users.${config.preferences.username} = {
          imports = [
            self.homeModules.base
            self.homeModules.nvim
          ];
          home.stateVersion = "24.05";
          home.username = config.preferences.username;
          home.homeDirectory = "/home/${config.preferences.username}";
          programs.home-manager.enable = true;

          home.packages = with pkgs; [
            jq
            just
            fastfetch
            tailscale
          ];
        };
      };

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
    };
}
