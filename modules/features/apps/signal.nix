{self, ...}: {
  # Self-registers into the `apps` group (merged with the other apps modules).
  flake.nixosModules.apps.imports = [self.nixosModules.signal];

  flake.nixosModules.signal = {pkgs, ...}: {
    environment.systemPackages = [pkgs.signal-desktop];
  };
}
