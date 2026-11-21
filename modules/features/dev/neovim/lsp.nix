{self, ...}: {
  flake.homeModules.neovim = {
    pkgs,
    lib,
    ...
  }: let
    lspFromDevShell = {
      "haskell-language-server" = ["haskell-language-server-wrapper" "--lsp"];
    };
  in {
    programs.nvf.settings.vim = {
      diagnostics = {
        enable = true;
        config = {
          severity_sort = true;
          underline = true;
          update_in_insert = false;
          virtual_text = {
            spacing = 2;
            source = "if_many";
          };
        };
      };

      lsp = {
        enable = true;
        lspconfig.enable = true;
        formatOnSave = false;
        inlayHints.enable = true;
        trouble.enable = true;

        lspsaga = {
          enable = true;
          setupOpts = {
            ui.code_action = "";
            lightbulb = {
              sign = false;
              virtual_text = true;
            };
            symbol_in_winbar.enable = true;
          };
        };

        otter-nvim = {
          enable = true;
          setupOpts = {
            buffers.set_filetype = true;
            lsp.diagnostic_update_event = ["BufWritePost" "InsertLeave"];
          };
        };

        servers =
          lib.mapAttrs (_: cmd: {cmd = lib.mkForce cmd;}) lspFromDevShell
          // {
            clangd.filetypes = lib.mkForce ["c" "cpp" "objc" "objcpp" "cuda"];

            protols = {
              enable = true;
              cmd = ["${pkgs.protols}/bin/protols"];
              filetypes = ["proto"];
              root_markers = ["protols.toml" ".git"];
            };
          };
      };

      treesitter = {
        enable = true;
        fold = true;
        highlight.enable = true;
        indent.enable = false;
        grammars = [pkgs.vimPlugins.nvim-treesitter.builtGrammars.proto];
        context = {
          enable = true;
          setupOpts = {
            line_numbers = true;
            max_lines = 3;
            min_window_height = 20;
            multiline_threshold = 1;
            trim_scope = "outer";
            mode = "cursor";
          };
        };
      };

      autocomplete.blink-cmp = {
        enable = true;
        friendly-snippets.enable = true;
        mappings = {
          next = "<C-n>";
          previous = "<C-p>";
          confirm = "<C-y>";
        };
        setupOpts = {
          signature.enabled = true;
          completion = {
            menu = {
              border = "rounded";
              draw.columns = [
                ["kind_icon"]
                ["label" "label_description"]
                ["source_name"]
              ];
            };
            documentation.window.border = "rounded";
          };
        };
      };

      snippets.luasnip.enable = true;

      debugger.nvim-dap = {
        enable = true;
        ui.enable = true;
      };
    };
  };
}
