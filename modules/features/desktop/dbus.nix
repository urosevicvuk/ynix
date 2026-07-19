{self, ...}: {
  # Self-registers into the `desktop` group (merged with the other desktop modules).
  flake.nixosModules.desktop.imports = [self.nixosModules.dbus];

  flake.nixosModules.dbus = {pkgs, ...}: {
    services = {
      dbus = {
        enable = true;
        implementation = "broker";
        packages = with pkgs; [gcr];
      };

      upower.enable = true;
      libinput.enable = true;
      gnome.gnome-keyring.enable = true;
    };

    security.pam.services.login.enableGnomeKeyring = true;
  };

}
