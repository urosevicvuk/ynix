{self, ...}: {
  # The classroom image host. Composed only from the `classroom` group -- it
  # shares no modules with the personal hosts on purpose (see classroom/base.nix).
  #
  # Build artifacts are defined in ./images.nix.
  flake.nixosModules.classroom-host = {...}: {
    imports = [self.nixosModules.classroom];

    system.stateVersion = "26.05";
  };
}
