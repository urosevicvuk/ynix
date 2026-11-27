{
  self,
  ...
}: {
  flake.nixosModules.apps.imports = [self.nixosModules.ladybird];

  flake.nixosModules.ladybird = {...}: {
    programs.ladybird.enable = true;
  };
}
