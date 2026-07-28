{self, ...}: {
  # Self-registers into the `desktop` group (merged with the other desktop modules).
  flake.nixosModules.desktop.imports = [self.nixosModules.tuigreet];

  flake.nixosModules.tuigreet = {
    pkgs,
    config,
    ...
  }: let
    desktops = config.services.displayManager.sessionData.desktops;
  in {
    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --remember-session --asterisks --sessions ${desktops}/share/wayland-sessions:${desktops}/share/xsessions";
          user = "greeter";
        };
      };
    };
  };
}
