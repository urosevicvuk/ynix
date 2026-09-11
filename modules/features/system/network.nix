{self, ...}: {
  flake.nixosModules.system.imports = [self.nixosModules.network];

  flake.nixosModules.network = {config, ...}: {

    networking = {
      #wireless.iwd = {
      #  enable = true;
      #};
      firewall = {
        enable = true;
        allowPing = false;
      };
      networkmanager = {
        enable = true;
        wifi = {
          #backend = "iwd";
          powersave = false;
        };
      };
    };

    users.users.${config.preferences.username}.extraGroups = ["networkmanager"];

    systemd.services.NetworkManager-wait-online.enable = false;
  };
}
