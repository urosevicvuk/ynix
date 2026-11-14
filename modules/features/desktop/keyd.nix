{self, ...}: {
  # Self-registers into the `desktop` group (merged with the other desktop modules).
  flake.nixosModules.desktop.imports = [self.nixosModules.keyd];

  flake.nixosModules.keyd = {...}: {
    services.keyd = {
      enable = true;
      keyboards = {
        default = {
          ids = ["*"];
          settings = {
            main = {
              # Tap/hold keys use overloadt2 instead of overload: plain overload
              # presses Control the instant the key goes down (so a tap sends
              # Ctrl+Enter / Ctrl+Esc to apps, which breaks games). overloadt2
              # only becomes Control if held >200ms or another key is tapped
              # while held; a quick tap sends just the key.

              # Caps Lock acts as Escape when tapped, Control when held
              capslock = "overloadt2(control, esc, 200)";

              # Enter acts as Control when held, Enter when tapped
              enter = "overloadt2(control, enter, 200)";

              leftalt = "leftmeta";
              leftmeta = "leftalt";
            };

            # Tapping both shift keys together activates capslock
            shift = {
              leftshift = "capslock";
              rightshift = "capslock";
            };
          };
        };
      };
    };
  };
}
