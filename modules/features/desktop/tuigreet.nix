# greetd + tuigreet display manager
{...}: {
  flake.nixosModules.tuigreet = {pkgs, ...}: let
    sessionDir = "${pkgs.hyprland}/share/wayland-sessions";
  in {
    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --remember-session --asterisks --sessions ${sessionDir}";
          user = "greeter";
        };
      };
    };

    security.pam.services.greetd.fprintAuth = false;
  };
}
