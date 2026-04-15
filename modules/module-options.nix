{lib, ...}: {
  options.flake.homeModules = lib.mkOption {
    type = lib.types.attrsOf lib.types.deferredModule;
    default = {};
    description = "Internal Home Manager module groups (base, desktop, dev) wired into nixosModules";
  };
}
