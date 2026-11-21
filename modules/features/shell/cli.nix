{self, ...}: {
  flake.nixosModules.shell.imports = [self.nixosModules.cli];

  flake.nixosModules.cli = {...}: {
    home-manager.sharedModules = [self.homeModules.cli];
  };

  flake.homeModules.cli = {...}: {
    programs.ripgrep.enable = true;
    programs.fd.enable = true;
    programs.bat.enable = true;
  };
}
