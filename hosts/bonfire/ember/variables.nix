{ config, lib, ... }:
{
  imports = [
    ../../themes/gruvbox.nix
  ];

  config.var = {
    # Host identification
    hostname = "bonfire-ember";
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

    # Cluster configuration (storage node)
    cluster = {
      enabled = true;
      role = "storage"; # Runs Ceph OSD daemons, provides storage

      # Future: Will reference control plane and workers
      nodes = {
        # Control plane (reference)
        bonfire-keeper = "100.64.0.20";

        # Worker nodes (reference)
        # bonfire-ash-01 = "100.64.0.30";

        # Storage nodes
        bonfire-ember = "100.64.0.40";
      };

      storage = {
        backend = "ceph"; # This node IS the Ceph cluster
        # Ceph OSD configuration will go here
        osd = {
          # devices = [ "/dev/sdb" "/dev/sdc" "/dev/sdd" ];
          # Will be configured during deployment
        };
      };

      k3s = {
        # Storage nodes typically don't run K8s, just Ceph
        enabled = false;
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
