{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (config.var) username;
  inherit (config.var) device;
  isLaptop = device == "laptop";
in {
  services.fprintd.enable = isLaptop;

  security = {
    pam.services = {
      sudo.fprintAuth = lib.mkIf isLaptop true;
      login.fprintAuth = lib.mkIf isLaptop true;
      noctalia-shell.fprintAuth = lib.mkIf isLaptop true;
      polkit-1.fprintAuth = lib.mkIf isLaptop true;
    };

    # Sudo configuration
    sudo = {
      # Require authentication (fingerprint or password) for wheel group
      wheelNeedsPassword = true;

      # Sudo rules for specific commands
      extraRules = [
        # Allow nixos-rebuild without password
        {
          users = [username];
          commands = [
            {
              command = "/run/current-system/sw/bin/nixos-rebuild";
              options = ["NOPASSWD"];
            }
          ];
        }
        # Allow tailscale without password
        {
          users = [username];
          commands = [
            {
              command = "/etc/profiles/per-user/${username}/bin/tailscale";
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
