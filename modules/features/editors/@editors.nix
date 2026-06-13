# Editors group — text editors / IDEs.
{self, ...}: {
  flake.nixosModules.editors = {...}: {
    imports = [
      self.nixosModules.neovim
      self.nixosModules.jetbrains
      self.nixosModules.zed-editor
    ];
  };
}
