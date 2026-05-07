{
  flake.nixosModules.networking = {config, ...}: {
    networking = {
      firewall = {
        enable = true;
        allowPing = false;
      };
      networkmanager = {
        enable = true;
      };
    };
    users.users.${config.preferences.username}.extraGroups = ["networkmanager"];
    systemd.services.NetworkManager-wait-online.enable = false;
  };
}
