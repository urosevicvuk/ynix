{lib, ...}: {
  options.flake.homeManagerModules = lib.mkOption {
    type = lib.types.attrsOf lib.types.deferredModule;
    default = {};
    description = "Home Manager module groups composed by feature modules";
  };
}
