{self, ...}: {
  flake.nixosModules.apps.imports = [self.nixosModules.signal];

  flake.nixosModules.signal = {pkgs, ...}: {
    environment.systemPackages = [pkgs.signal-desktop];
  };
}
