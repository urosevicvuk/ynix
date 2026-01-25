# NixOS-level secrets for firelink (server)
# These are system-level secrets used by system services (acme, nextcloud, cloudflared, etc.)
# They must be defined at the NixOS level to support the 'owner' option for system users
{ config, ... }:

{
  sops = {
    age.sshKeyPaths = [ "/home/${config.var.username}/.ssh/id_ed25519" ];
    defaultSopsFormat = "yaml";

    secrets = {
      # Cloudflare tokens
      "cloudflare-dns-token" = {
        sopsFile = ./cloudflare.yaml;
        key = "dns_token_env"; # For ACME (needs CLOUDFLARE_DNS_API_TOKEN=xxx format)
        owner = "acme";
        mode = "0400";
      };

      "cloudflare-tunnel-token" = {
        sopsFile = ./cloudflare.yaml;
        key = "tunnel_token";
        mode = "0400";
      };

      "cloudflare-ddns-token" = {
        sopsFile = ./cloudflare.yaml;
        key = "dns_token";
        mode = "0400";
      };

      "cloudflare-zone-id" = {
        sopsFile = ./cloudflare.yaml;
        key = "zone_id";
        mode = "0400";
      };

      # Nextcloud
      "nextcloud-admin-password" = {
        sopsFile = ./nextcloud.yaml;
        key = "admin_password";
        owner = "nextcloud";
        mode = "0400";
      };

      # Disabled - placeholders only, uncomment when you add real values:
      # "hoarder-env" = {
      #   sopsFile = ./hoarder.yaml;
      #   key = "env_file";
      #   mode = "0400";
      # };
      #
      # "wireguard-pia" = {
      #   sopsFile = ./media.yaml;
      #   key = "wireguard_config";
      #   mode = "0400";
      # };
      #
      # "recyclarr-config" = {
      #   sopsFile = ./media.yaml;
      #   key = "recyclarr_config";
      #   mode = "0400";
      # };
    };
  };
}
