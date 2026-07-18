# Language support. nvf wires LSP + treesitter + formatters per language.
# format.enable turns on conform with each language's dedicated formatter
# (stylua, black, prettier, alejandra, gofmt, ...) for manual <leader>cf;
# auto-format on save stays off (vim.lsp.formatOnSave = false in lsp.nix).
# yaml/helm have no nvf formatter, so they're enable-only.
# Protobuf has no nvf module - it's handled in lsp.nix (protols + grammar).
{self, ...}: {
  flake.homeModules.neovim = {...}: {
    programs.nvf.settings.vim.languages = {
      enableFormat = true;
      enableTreesitter = true;

      # Compiled / systems (DAP-enabled).
      go = {
        enable = true;
        format.enable = true;
        dap.enable = true;
      };
      rust = {
        enable = true;
        format.enable = true;
        dap.enable = true;
      };
      clang = {
        enable = true;
        format.enable = true;
        dap.enable = true;
      };
      python = {
        enable = true;
        format.enable = true;
        dap.enable = true;
      };
      haskell = {
        enable = true;
        format.enable = true;
      };

      # Scripting.
      lua = {
        enable = true;
        format.enable = true;
      };
      bash = {
        enable = true;
        format.enable = true;
      };
      sql = {
        enable = true;
        format.enable = true;
      };

      # Config / markup.
      nix = {
        enable = true;
        format.enable = true;
      };
      yaml.enable = true; # no nvf formatter
      json = {
        enable = true;
        format.enable = true;
      };
      toml = {
        enable = true;
        format.enable = true;
      };
      markdown = {
        enable = true;
        format.enable = true;
        extensions.render-markdown-nvim.enable = true;
      };

      # Web.
      typescript = {
        enable = true;
        format.enable = true;
      };
      html = {
        enable = true;
        format.enable = true;
      };
      css = {
        enable = true;
        format.enable = true;
      };

      # DevOps / infra.
      docker = {
        enable = true;
        format.enable = true;
      };
      terraform = {
        enable = true;
        format.enable = true;
      };
      hcl = {
        enable = true;
        format.enable = true;
      };
      helm.enable = true; # no nvf formatter

      # CS / tooling.
      tex = {
        enable = true;
        format.enable = true;
      };
      cmake = {
        enable = true;
        format.enable = true;
      };
      make = {
        enable = true;
        format.enable = true;
      };
    };
  };
}
