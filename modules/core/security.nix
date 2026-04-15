{
  flake.nixosModules.core = { ... }: {
        security.sudo = {
          wheelNeedsPassword = true;
          extraRules = [
            {
              users = [ "vyke" ];
              commands = [
                {
                  command = "/run/current-system/sw/bin/nixos-rebuild";
                  options = [ "NOPASSWD" ];
                }
              ];
            }
            {
              users = [ "vyke" ];
              commands = [
                {
                  command = "/etc/profiles/per-user/vyke/bin/tailscale";
                  options = [ "NOPASSWD" ];
                }
                {
                  command = "/run/current-system/sw/bin/tailscale";
                  options = [ "NOPASSWD" ];
                }
              ];
            }
          ];
        };
  };
}
