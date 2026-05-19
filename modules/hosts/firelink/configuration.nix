{
  self,
  inputs,
  ...
}: {
  flake.nixosConfigurations.firelink = inputs.nixpkgs.lib.nixosSystem {
    modules = [self.nixosModules.firelink];
  };

  flake.nixosModules.firelink = {
    config,
    pkgs,
    ...
  }: {
    imports = [
      self.nixosModules.base
      self.nixosModules.nvim
      self.nixosModules.cluster

      self.nixosModules.sops
    ];

    networking.hostName = "firelink";
    system.stateVersion = "24.05";

    home-manager.users.${config.preferences.username} = {
      home.packages = with pkgs; [
      ];
    };

    sops = {
      age.sshKeyPaths = ["/home/vyke/.ssh/id_ed25519"];
      defaultSopsFormat = "yaml";

      secrets = {
        #"cloudflare-tunnel-token" = {
        #  sopsFile = ../../secrets/server/cloudflare.yaml;
        #  key = "tunnel_token";
        #  mode = "0400";
        #};

        #"cloudflare-ddns-token" = {
        #  sopsFile = ../../secrets/server/cloudflare.yaml;
        #  key = "dns_token";
        #  mode = "0400";
        #};

        #"cloudflare-zone-id" = {
        #  sopsFile = ../../secrets/server/cloudflare.yaml;
        #  key = "zone_id";
        #  mode = "0400";
        #};
      };
    };
  };
}
