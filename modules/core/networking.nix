{
  flake.nixosModules.core = { ... }: {
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
        users.users.vyke.extraGroups = [ "networkmanager" ];
        systemd.services.NetworkManager-wait-online.enable = false;
  };
}
