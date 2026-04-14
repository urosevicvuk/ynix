# greetd + tuigreet display manager
{ ... }:
{
  flake.modules.nixos.desktop = [
    (
      { pkgs, ... }:
      let
        sessionDir = "${pkgs.hyprland}/share/wayland-sessions";
      in
      {
        services.greetd = {
          enable = true;
          settings = {
            default_session = {
              command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --remember --remember-session --asterisks --sessions ${sessionDir}";
              user = "greeter";
            };
          };
        };

        security.pam.services.greetd.fprintAuth = false;
      }
    )
  ];
}
