# Binary cache — CLIENT half. Every host substitutes prebuilt paths from firelink
# first (priority 5, ahead of cache.nixos.org's 10), falling back to the public
# caches if firelink is down. firelink's serving half is server/cache-server.nix.
#
# Reached over the tailnet: firelink resolves to its tailscale IP (networking.hosts)
# and tailscale0 is a trusted firewall interface, so nothing extra is opened.
# (firelink imports this too and ends up pointing at its own harmonia — harmless.)
{self, ...}: {
  # Self-registers into the `system` group (merged with the other system modules).
  flake.nixosModules.system.imports = [self.nixosModules.binaryCache];

  flake.nixosModules.binaryCache = {...}: {
    nix.settings = {
      substituters = ["http://firelink:5000?priority=5"];
      trusted-public-keys = ["firelink-1:sE3HudW/ms0O9N2zxus6znHG1xWekq2Me7gT5uWAyQ0="];
    };
  };
}
