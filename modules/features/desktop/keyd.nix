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
              capslock = "overload(control, esc)";

              enter = "overload(control, enter)";

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
