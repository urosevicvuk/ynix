{
  self,
  inputs,
  ...
}: {
  flake.nixosModules.shell.imports = [self.nixosModules.rex];

  flake.nixosModules.rex = {...}: {
    home-manager.sharedModules = [self.homeModules.rex];
  };

  flake.homeModules.rex = {...}: {
    imports = [inputs.rex.homeModules.default];

    programs.rex.enable = true;

    services.rex.enable = true;
  };
}
