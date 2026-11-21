{self, ...}: {
  flake.nixosModules.apps.imports = [self.nixosModules.vlc];

  flake.nixosModules.vlc = {pkgs, ...}: {
    environment.systemPackages = [pkgs.vlc];
  };
}
