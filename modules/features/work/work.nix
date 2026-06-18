{self, ...}: {
  flake.nixosModules.work = {...}: {
    imports = [
      self.nixosModules.office
    ];
  };
}
