{self, ...}: {
  # Self-registers into the `desktop` group (merged with the other desktop modules).
  flake.nixosModules.desktop.imports = [self.nixosModules.xdg];

  flake.nixosModules.xdg = {pkgs, ...}: {
    xdg.portal = {
      enable = true;
      xdgOpenUsePortal = true;
      config = {
        common.default = ["gtk"];
        niri = {
          default = ["gnome" "gtk"];
          "org.freedesktop.impl.portal.ScreenCast" = ["gnome"];
          "org.freedesktop.impl.portal.RemoteDesktop" = ["gnome"];
          "org.freedesktop.impl.portal.Access" = ["gnome"];
          "org.freedesktop.impl.portal.FileChooser" = ["gtk"];
        };
      };

      extraPortals = [
        pkgs.xdg-desktop-portal-gtk
        pkgs.xdg-desktop-portal-gnome
      ];
    };
  };
}
