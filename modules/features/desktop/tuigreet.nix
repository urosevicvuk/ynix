{self, ...}: {
  # --- tuigreet (off) --- dms-shell.nix runs dms-greeter; to switch back,
  # uncomment this line and comment the dms-greeter block in dms-shell.nix
  # flake.nixosModules.desktop.imports = [self.nixosModules.tuigreet];

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
