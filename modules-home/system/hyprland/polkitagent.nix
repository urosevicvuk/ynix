# HyprPolkitAgent is a simple polkit agent for wayland compositors
{pkgs, ...}: {
  home.packages = with pkgs; [hyprpolkitagent];

  # exec-once moved to main hyprland config to avoid conflicts
}
