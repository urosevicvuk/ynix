{ lib, ... }:
{
  options.flake.modules = {
    nixos = lib.mkOption {
      type = lib.types.attrsOf (lib.types.listOf lib.types.deferredModule);
      default = { };
      description = "NixOS module groups composed by feature modules";
    };
    homeManager = lib.mkOption {
      type = lib.types.attrsOf (lib.types.listOf lib.types.deferredModule);
      default = { };
      description = "Home Manager module groups composed by feature modules";
    };
  };
}
