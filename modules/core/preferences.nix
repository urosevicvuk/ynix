# Preferences - shared option definitions for all hosts
{ lib, ... }:
{
  flake.nixosModules.base = { lib, ... }: {
    options.preferences = {
      username = lib.mkOption {
        type = lib.types.str;
        default = "vyke";
        description = "Primary user account name";
      };
      configDirectory = lib.mkOption {
        type = lib.types.str;
        default = "/home/vyke/code/ynix";
        description = "Path to the NixOS configuration flake";
      };
      terminal = lib.mkOption {
        type = lib.types.str;
        default = "kitty";
        description = "Default terminal emulator";
      };
      timeZone = lib.mkOption {
        type = lib.types.str;
        default = "Europe/Belgrade";
        description = "System timezone";
      };
    };
  };
}
