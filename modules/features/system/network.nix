# Network: networkmanager/firewall + ssh, as one module.
# Owns the home bridge; ssh.nix contributes the openssh + home facets.
# tailscale is a separate module (toggle the tailnet per-host).
{self, ...}: {
  # Self-registers into the `system` group (merged with the other system modules).
  flake.nixosModules.system.imports = [self.nixosModules.network];

  flake.nixosModules.network = {config, ...}: {
    # MediaTek MT7925 (mt7925e) firmware locks up under sustained throughput
    # (e.g. large Steam downloads) when PCIe ASPM L1 power states kick in,
    # dropping the link and causing 4-way-handshake timeouts on reconnect.
    # Disabling ASPM for just this driver is the targeted fix.
    boot.extraModprobeConfig = "options mt7925e disable_aspm=1";

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
