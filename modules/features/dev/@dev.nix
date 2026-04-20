{self, ...}: {
  flake.nixosModules.dev = {...}: {
    imports = [
      self.nixosModules.dev-utils
      self.nixosModules.ai
      self.nixosModules.jetbrains
      self.nixosModules.docker
      self.nixosModules.editorconfig
    ];
  };
}
