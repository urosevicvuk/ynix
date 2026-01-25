{ config, lib, ... }:
{
  imports = [
    ../../themes/gruvbox.nix
  ];

  config.var = {
    # Host identification
    hostname = "bonfire-keeper";
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

    # Cluster configuration (control plane only)
    cluster = {
      enabled = true;
      role = "control-plane"; # Only runs K8s control plane, no workloads

      # Future: Will be populated with separated architecture
      nodes = {
        # Control plane nodes
        bonfire-keeper = "100.64.0.20";

        # Worker nodes (reference)
        # bonfire-ash-01 = "100.64.0.30";
        # bonfire-ash-02 = "100.64.0.31";

        # Storage nodes (reference)
        # bonfire-ember-01 = "100.64.0.40";
        # bonfire-ember-02 = "100.64.0.41";
      };

      storage = {
        backend = "external-ceph"; # Points to separate Ceph cluster
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
