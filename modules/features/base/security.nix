{
  flake.nixosModules.security = {config, ...}: {
    security.sudo = {
      wheelNeedsPassword = true;
      extraRules = [
        {
          users = [config.preferences.username];
          commands = [
            {
              command = "/run/current-system/sw/bin/nixos-rebuild";
              options = ["NOPASSWD"];
            }
          ];
        }
        {
          users = [config.preferences.username];
          commands = [
            {
              command = "/etc/profiles/per-user/${config.preferences.username}/bin/tailscale";
              options = ["NOPASSWD"];
            }
            {
              command = "/run/current-system/sw/bin/tailscale";
              options = ["NOPASSWD"];
            }
          ];
        }
      ];
    };
  };
}
