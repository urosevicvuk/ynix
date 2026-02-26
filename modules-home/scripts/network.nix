# - ## WiFi Toggle
#-
#- Script for toggling WiFi on/off.
#-
#- - `wifi-toggle` - Toggle WiFi on/off.
{pkgs, ...}: let
  wifi-toggle = pkgs.writeShellScriptBin "wifi-toggle" ''
    status=$(${pkgs.networkmanager}/bin/nmcli radio wifi)

    if [ "$status" = "enabled" ]; then
      ${pkgs.networkmanager}/bin/nmcli radio wifi off
    else
      ${pkgs.networkmanager}/bin/nmcli radio wifi on
    fi
  '';
in {
  home.packages = [wifi-toggle];
}
