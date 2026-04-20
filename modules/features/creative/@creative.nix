{self, ...}: {
  flake.nixosModules.creative = {...}: {
    imports = [
      self.nixosModules.affinity
      self.nixosModules.davinciResolve
      self.nixosModules.figma
      self.nixosModules.obsStudio
    ];
  };
}
