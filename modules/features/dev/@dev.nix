{self, ...}: {
  flake.nixosModules.dev = {...}: {
    imports = [
      self.nixosModules.claude-code
      self.nixosModules.dev-utils
      self.nixosModules.docker
      self.nixosModules.editorconfig
      self.nixosModules.jetbrains
      self.nixosModules.nvim
      self.nixosModules.opencode
      self.nixosModules.zed-editor
    ];
  };
}
