# Language support. nvf wires LSP + treesitter + formatters per language.
# enableFormat installs the formatters for manual use (<leader>cf); auto-format
# on save stays off (vim.lsp.formatOnSave = false in lsp.nix).
# Protobuf has no nvf module - it's handled in lsp.nix (protols + grammar).
{self, ...}: {
  flake.nixosModules.nvf-languages = {...}: {
    home-manager.sharedModules = [self.homeModules.nvf-languages];
  };

  flake.homeModules.nvf-languages = {...}: {
    programs.nvf.settings.vim.languages = {
      enableFormat = true;
      enableTreesitter = true;

      # Compiled / systems (DAP-enabled).
      go = {
        enable = true;
        dap.enable = true;
      };
      rust = {
        enable = true;
        dap.enable = true;
      };
      clang = {
        enable = true;
        dap.enable = true;
      };
      python = {
        enable = true;
        dap.enable = true;
      };
      haskell.enable = true;

      # Scripting.
      lua.enable = true;
      bash.enable = true;
      sql.enable = true;

      # Config / markup.
      nix.enable = true;
      yaml.enable = true;
      json.enable = true;
      toml.enable = true;
      markdown = {
        enable = true;
        extensions.render-markdown-nvim.enable = true;
      };

      # Web.
      typescript.enable = true;
      html.enable = true;
      css.enable = true;

      # DevOps / infra.
      docker.enable = true;
      terraform.enable = true;
      hcl.enable = true;
      helm.enable = true;

      # CS / tooling.
      tex.enable = true;
      cmake.enable = true;
      make.enable = true;
    };
  };
}
