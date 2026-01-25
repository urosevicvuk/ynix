{ config, lib, ... }:
{
  imports = [
    ../../themes/gruvbox.nix
  ];

  config.var = {
    # Host identification
    hostname = "bonfire-ash";
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

    # Display settings
    monitorScale = "1";
    inputSensitivity = "-0.5";

    # Theme
    theme = import ../../themes/var/gruvbox.nix;

    # Cluster configuration (worker node)
    cluster = {
      enabled = true;
      role = "worker"; # Only runs application workloads

      # Future: Will reference control plane and storage nodes
      nodes = {
        # Control plane (reference)
        bonfire-keeper = "100.64.0.20";

        # Worker nodes
        bonfire-ash = "100.64.0.30";

        # Storage nodes (reference)
        # bonfire-ember-01 = "100.64.0.40";
      };

      storage = {
        backend = "external-ceph"; # Mounts from separate Ceph cluster
      };

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
