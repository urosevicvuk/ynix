{self, ...}: {
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
