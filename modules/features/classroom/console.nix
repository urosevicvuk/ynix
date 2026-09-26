{self, ...}: {
  # Self-registers into the `classroom` group (merged with the other classroom modules).
  flake.nixosModules.classroom.imports = [self.nixosModules.classroom-console];

  flake.nixosModules.classroom-console = {pkgs, ...}: {
    # No graphical stack is imported anywhere in this host, so boot lands on
    # tty1 and stays there. That is the whole point of the image.

    services.getty = {
      autologinUser = "student";
      greetingLine = ""; # drop the "<<< Welcome to NixOS >>>" banner
      helpLine = ""; # drop the docs/manual hint
    };

    # Black screen: no bootloader menu, no kernel spew, no systemd unit list.
    boot = {
      loader.timeout = 0;
      consoleLogLevel = 0;
      initrd.verbose = false;
      kernelParams = [
        "quiet"
        "loglevel=3"
        "udev.log_level=3"
        "systemd.show_status=false"
        "rd.systemd.show_status=false"
      ];
    };

    console = {
      earlySetup = true;
      # The default 8x16 console font is unreadable past the third row of a
      # lecture hall. Terminus at 24px is the difference between students
      # following along and students asking what is on screen.
      packages = [pkgs.terminus_font];
      font = "ter-v24n";
      keyMap = "us";
    };
  };
}
