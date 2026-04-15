{
  flake.nixosModules.base = { config, ... }: {
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
        users.users.${config.preferences.username}.extraGroups = [ "networkmanager" ];
        systemd.services.NetworkManager-wait-online.enable = false;
  };
}
