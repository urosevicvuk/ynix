{
  flake.nixosModules.network= {config, ...}: {
    # MediaTek MT7925 (mt7925e) firmware locks up under sustained throughput
    # (e.g. large Steam downloads) when PCIe ASPM L1 power states kick in,
    # dropping the link and causing 4-way-handshake timeouts on reconnect.
    # Disabling ASPM for just this driver is the targeted fix.
    boot.extraModprobeConfig = "options mt7925e disable_aspm=1";

    networking = {
      #wireless.iwd = {
      #  enable = true;
      #  settings = {
      #    Network = {
      #      EnableIPv6 = true;
      #    };
      #    Settings = {
      #      AutoConnect = true;
      #    };
      #  };
      #};
      firewall = {
        enable = true;
        allowPing = false;
      };
      networkmanager = {
        enable = true;
        wifi = {
          powersave = false;
        };
      };
    };

    users.users.${config.preferences.username}.extraGroups = ["networkmanager"];
    systemd.services.NetworkManager-wait-online.enable = false;
  };
}
