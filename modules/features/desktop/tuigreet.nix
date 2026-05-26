{...}: {
  flake.nixosModules.tuigreet = {pkgs, ...}: let
    sessions = pkgs.symlinkJoin {
      name = "wayland-sessions";
      paths = [
        "${pkgs.hyprland}/share/wayland-sessions"
        "${pkgs.niri}/share/wayland-sessions"
      ];
    };
  in {
    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --remember-session --asterisks --sessions ${sessions}";
          user = "greeter";
        };
      };
    };

    security.pam.services.greetd.fprintAuth = false;
  };
}
