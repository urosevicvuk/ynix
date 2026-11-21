{self, ...}: {
  flake.nixosModules.desktop.imports = [self.nixosModules.filesharing];

  flake.nixosModules.filesharing = {...}: {
    programs = {
      kdeconnect.enable = true;
      localsend.enable = true;
    };
  };
}
