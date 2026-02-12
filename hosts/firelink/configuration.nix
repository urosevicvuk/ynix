{config, ...}: {
  imports = [
    # System modules
    ../../modules-nixos/system/nix.nix
    ../../modules-nixos/system/boot.nix
    # ../../modules-nixos/system/secure-boot.nix  # Disabled for server
    ../../modules-nixos/system/users.nix
    ../../modules-nixos/system/utils.nix
    ../../modules-nixos/system/home-manager.nix
    ../../modules-nixos/system/locale.nix
    ../../modules-nixos/system/environment.nix
    ../../modules-nixos/system/security.nix

    # Services
    ../../modules-nixos/services/docker.nix

    # Cluster (Phase 5: Enable when migrating services to K8s)
    ../../modules-nixos/cluster/k3s.nix
    ../../modules-nixos/cluster/storage.nix
    ../../modules-nixos/cluster/firewall.nix

    # Network
    ../../modules-nixos/network/networking.nix
    ../../modules-nixos/network/tailscale.nix
    #../../modules-nixos/network/firewall.nix
    #../../modules-nixos/network/ddns.nix

    # Server
    ../../modules-nixos/server/ssh.nix
    #../../modules-nixos/server/services/cloudflared.nix
    #../../modules-nixos/server/services/nextcloud.nix
    # ../../modules-nixos/server/services/adguardhome.nix
    # ../../modules-nixos/server/services/bitwarden.nix
    # ../../modules-nixos/server/services/glance.nix
    # ../../modules-nixos/server/services/headscale.nix
    # ../../modules-nixos/server/services/hoarder.nix
    # ../../modules-nixos/server/services/mealie.nix
    # ../../modules-nixos/server/services/meilisearch.nix
    # ../../modules-nixos/server/services/search-nixos-api.nix
    # ../../modules-nixos/server/media/arr.nix
    #../../modules-nixos/server/web/nginx.nix

    # Secrets (NixOS-level)
    ../../secrets/server/nixos.nix

    # Host-specific configuration
    ./variables.nix
    ./hardware-configuration.nix
  ];

  home-manager.users."${config.var.username}" = import ./home.nix;

  # Don't touch this
  system.stateVersion = "24.05";
}
