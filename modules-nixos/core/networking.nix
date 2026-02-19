{config, ...}: let
  inherit (config.var) hostname;
in {
  networking = {
    wireless.iwd = {
      enable = true;
      settings = {
        Network.EnableIPv6 = true;
        Settings.AutoConnect = true;
      };
    };

    firewall = {
      enable = true;
      allowPing = false;
    };

    hostName = hostname;

    networkmanager = {
      enable = true;
      wifi = {
        backend = "iwd";
        powersave = false;
        scanRandMacAddress = false;
        macAddress = "preserve";
      };
    };
  };
}
