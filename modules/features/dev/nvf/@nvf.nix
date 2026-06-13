# nvf - Neovim configuration (aggregator)
# Each concern below is its own flake module contributing a slice of
# `programs.nvf.settings.vim`; home-manager merges them into one config.
{self, ...}: {
  flake.nixosModules.neovim = {...}: {
    imports = [
      self.nixosModules.nvf-core
      self.nixosModules.nvf-options
      self.nixosModules.nvf-keymaps
      self.nixosModules.nvf-ui
      self.nixosModules.nvf-editor
      self.nixosModules.nvf-lsp
      self.nixosModules.nvf-git
      self.nixosModules.nvf-ai
      self.nixosModules.nvf-languages
    ];
  };
}
