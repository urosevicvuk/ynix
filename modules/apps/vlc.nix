{self, ...}: {
  # Self-registers into the `apps` group (merged with the other apps modules).
  flake.nixosModules.apps.imports = [self.nixosModules.vlc];

  flake.nixosModules.vlc = {pkgs, ...}: {
    environment.systemPackages = [pkgs.vlc];
  };
}
