# Theme selector - wires preferences.theme into config.theme.active
# and propagates it to home-manager configs.
{self, ...}: {
  flake.homeModules.theme = {lib, ...}: {
    options.theme.active = lib.mkOption {
      type = lib.types.attrs;
      description = "Active theme attrset (set by nixos module)";
    };
  };

  flake.nixosModules.theme = {config, lib, ...}: let
    themeName = config.preferences.theme;
    activeTheme =
      self.theme.${themeName}
      or (throw "Unknown theme '${themeName}' - add it to modules/tools/themes/");
  in {
    options.theme.active = lib.mkOption {
      type = lib.types.attrs;
      description = "Active theme attrset resolved from preferences.theme";
    };

    config = {
      theme.active = activeTheme;
      home-manager.sharedModules = [self.homeModules.theme];
      home-manager.users.${config.preferences.username}.theme.active = activeTheme;
    };
  };
}
