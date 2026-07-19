{self, ...}: {
  # Self-registers into the `apps` group (merged with the other apps modules).
  flake.nixosModules.apps.imports = [self.nixosModules.calibre];

  flake.nixosModules.calibre = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      calibre
    ];
  };
}
