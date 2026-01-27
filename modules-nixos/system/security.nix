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

  # Fix fingerprint reader after suspend/resume
  # The AMD xHCI USB controller (c1:00.4) crashes on resume and never recovers
  # This is a hardware/firmware bug that kernel parameters can't fix
  # Solution: Stop fprintd before suspend, then reset the USB controller after resume

  #powerManagement.powerDownCommands = lib.mkIf isLaptop ''
  #  ${pkgs.systemd}/bin/systemctl stop fprintd.service 2>/dev/null || true
  #'';

  ## Reset xHCI controller after resume to recover fingerprint reader
  #powerManagement.resumeCommands = lib.mkIf isLaptop ''
  #  # Unbind the dead xHCI controller
  #  echo '0000:c1:00.4' > /sys/bus/pci/drivers/xhci_hcd/unbind 2>/dev/null || true

  #  # Rebind to reset it
  #  echo '0000:c1:00.4' > /sys/bus/pci/drivers/xhci_hcd/bind 2>/dev/null || true

  #  # fprintd will auto-start when needed
  #'';

  security = {
    pam.services = {
      sudo.fprintAuth = lib.mkIf isLaptop true;
      hyprlock = {
        fprintAuth = lib.mkIf isLaptop true;
      };
      login = {
        fprintAuth = lib.mkIf isLaptop true;
        enableGnomeKeyring = true;
      };
      greetd = {
        fprintAuth = lib.mkIf isLaptop true;
        enableGnomeKeyring = true;
      };
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
