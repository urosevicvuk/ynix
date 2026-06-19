{self, ...}: {
  flake.nixosModules.creative = {...}: {
    imports = [
      # Editing
      self.nixosModules.davinciResolve
      self.nixosModules.obsStudio

      # Design
      self.nixosModules.affinity
      self.nixosModules.figma
    ];
  };
}
