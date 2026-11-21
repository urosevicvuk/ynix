{self, ...}: {
  flake.nixosModules.apps.imports = [self.nixosModules.calibre];

  flake.nixosModules.calibre = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      calibre
    ];
  };
}
