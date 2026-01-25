{pkgs, ...}: {
  # XDG Desktop Portal configuration
  # Handles file pickers, screen sharing, etc. for Wayland/Hyprland
  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    config = {
      common.default = ["gtk"];
      hyprland.default = [
        "gtk"
        "hyprland"
      ];
    };

    extraPortals = [pkgs.xdg-desktop-portal-gtk];
  };
}
