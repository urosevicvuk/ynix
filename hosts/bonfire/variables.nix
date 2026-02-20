{ config, lib, ... }:
{
  imports = [
    ../../themes/gruvbox.nix
  ];

  config.var = {
    # Host identification
    hostname = "bonfire"; # Will be bonfire01, bonfire02, bonfire03
    username = "vyke";
    configDirectory = "/home/vyke/code/ynix";
    device = "server";
    terminal = "kitty";

    # Locale & keyboard
    keyboardLayout = "us,rs,rs";
    keyboardVariant = ",latin,";
    location = "Belgrade";
    timeZone = "Europe/Belgrade";
    defaultLocale = "en_US.UTF-8";
    extraLocale = "en_US.UTF-8";

    # Git config
    git = {
      username = "urosevicvuk";
      email = "vuk23urosevic@gmail.com";
    };

    # System settings
    autoUpgrade = false;
    autoGarbageCollector = true;

    # Display settings (server defaults)
    monitorScale = "1";
    inputSensitivity = "-0.5";

    # Cluster configuration (all-in-one node)
    cluster = {
      enabled = true;
      role = "all-in-one"; # Control plane + Worker + Storage

      # Cluster topology - will be populated when nodes are deployed
      nodes = {
        bonfire01 = "100.64.0.10"; # Placeholder Tailscale IPs
        bonfire02 = "100.64.0.11";
        bonfire03 = "100.64.0.12";
      };

      # Storage configuration
      storage = {
        backend = "longhorn"; # Distributed storage
        replicas = 3;
      };

      # K3s configuration
      k3s = {
        clusterDomain = "cluster.local";
        serviceCIDR = "10.43.0.0/16";
        podCIDR = "10.42.0.0/16";
      };
    };
  };

  options = {
    var = lib.mkOption {
      type = lib.types.attrs;
      default = { };
    };
  };
}
