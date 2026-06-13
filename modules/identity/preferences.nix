# Preferences - shared option definitions for all hosts
{
  flake.nixosModules.system = {lib, ...}: {
    options.preferences = {
      username = lib.mkOption {
        type = lib.types.str;
        default = "vyke";
        description = "Primary user account name";
      };
      configDirectory = lib.mkOption {
        type = lib.types.str;
        default = "/home/vyke/Projects/personal/ynix";
        description = "Path to the NixOS configuration flake";
      };
      terminal = lib.mkOption {
        type = lib.types.str;
        default = "kitty";
        description = "Default terminal emulator";
      };
      theme = lib.mkOption {
        type = lib.types.str;
        default = "gruvbox";
        description = "Active color theme (name of theme in modules/tools/themes/)";
      };
      timeZone = lib.mkOption {
        type = lib.types.str;
        default = "Europe/Belgrade";
        description = "System timezone";
      };
      autostart = lib.mkOption {
        type = lib.types.listOf (lib.types.either lib.types.str lib.types.package);
        default = [];
      };
      keymap = lib.mkOption {
        type = lib.types.lazyAttrsOf (lib.types.either lib.types.attrs lib.types.package);
        default = {};
      };
    };
  };
}
