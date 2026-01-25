# Clipman allows you to save and retrieve clipboard history.
{pkgs, ...}: let
  clipboard-clear = pkgs.writeShellScriptBin "clipboard-clear" ''
    clipman clear --all
  '';

  clipboard = pkgs.writeShellScriptBin "clipboard" ''
    clipman pick --tool=wofi
  '';
in {
  # exec-once moved to main hyprland config to avoid conflicts
  home.packages = with pkgs; [clipman clipboard clipboard-clear];
  services.clipman.enable = true;
}
