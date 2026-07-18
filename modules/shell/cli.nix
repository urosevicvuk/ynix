{self, ...}: {
  # Self-registers into the `shell` group (merged with the other shell modules).
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
