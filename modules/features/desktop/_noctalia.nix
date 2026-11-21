{
  self,
  inputs,
  ...
}: {
  flake.nixosModules.desktop.imports = [self.nixosModules.noctalia];

  flake.nixosModules.noctalia = {pkgs, ...}: {
    home-manager.sharedModules = [self.homeModules.noctalia];
  };

  flake.homeModules.noctalia = {...}: {
    imports = [inputs.noctalia.homeModules.default];

    programs.noctalia = {
      enable = true;
    };
  };
}
