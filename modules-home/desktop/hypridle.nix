# Hypridle is a daemon that listens for user activity and runs commands when the user is idle.
{
  pkgs,
  lib,
  ...
}: {
  services.hypridle = {
    enable = false;
    settings = {
      general = {
        ignore_dbus_inhibit = true;
        lock_cmd = "noctalia-shell ipc call lockScreen lock";
        before_sleep_cmd = "noctalia-shell ipc call lockScreen lock";
        #after_sleep_cmd = "hyprctl dispatch dpms on";
      };

      listener = [
        # Dim screen after 5 minutes
        {
          timeout = 300;
          on-timeout = "${pkgs.brightnessctl}/bin/brightnessctl -s set 10%";
          on-resume = "${pkgs.brightnessctl}/bin/brightnessctl -r";
        }

        # Turn off screen after 6 minutes
        {
          timeout = 360;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }

        # Lock and suspend after 10 minutes
        {
          timeout = 600;
          on-timeout = "noctalia-shell ipc call sessionMenu lockAndSuspend";
        }
      ];
    };
  };
  systemd.user.services.hypridle.Unit.After = lib.mkForce "graphical-session.target";
}
