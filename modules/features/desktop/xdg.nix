{...}: {
  flake.nixosModules.xdg = {pkgs, ...}: {
    xdg.portal = {
      enable = true;
      xdgOpenUsePortal = true;
      config = {
        common.default = ["kde"];
        hyprland.default = [
          "kde"
          "hyprland"
        ];
        niri.default = [
          "gnome"
          "kde"
        ];
      };

      extraPortals = [
        pkgs.kdePackages.xdg-desktop-portal-kde
        pkgs.xdg-desktop-portal-gnome
        pkgs.xdg-desktop-portal-gtk
      ];
    };
  };
}
