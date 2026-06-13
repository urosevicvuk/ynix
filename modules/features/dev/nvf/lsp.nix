# LSP, treesitter, completion, diagnostics UI, debugging, and testing.
{self, ...}: {
  flake.nixosModules.nvf-lsp = {...}: {
    home-manager.sharedModules = [self.homeModules.nvf-lsp];
  };

  flake.homeModules.nvf-lsp = {pkgs, ...}: {
    programs.nvf.settings.vim = {
      lsp = {
        enable = true;
        lspconfig.enable = true;
        formatOnSave = false; # manual only, via <leader>cf
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
            breadcrumbs.enable = false; # using vim.ui.breadcrumbs (navic) instead
          };
        };

        otter-nvim = {
          enable = true;
          setupOpts = {
            buffers.set_filetype = true;
            lsp.diagnostic_update_event = ["BufWritePost" "InsertLeave"];
          };
        };

        # Protobuf has no nvf language module: wire its LSP by hand.
        lspconfig.sources.protols = ''
          lspconfig.protols.setup({
            cmd = { "${pkgs.protols}/bin/protols" },
          })
        '';
      };

      # Winbar breadcrumbs via nvim-navic.
      ui.breadcrumbs = {
        enable = true;
        source = "nvim-navic";
      };

      treesitter = {
        enable = true;
        fold = true;
        highlight.enable = true;
        indent.enable = false;
        # Protobuf grammar (paired with the protols LSP above).
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

      # Debugging (nvim-dap + UI); per-language adapters enabled in languages.nix.
      debugger.nvim-dap = {
        enable = true;
        ui.enable = true;
      };

      # neotest is not an nvf module; install it + adapters here and configure
      # it in lua/neotest.lua (escape hatch).
      startPlugins = with pkgs.vimPlugins; [
        neotest
        neotest-go
        neotest-python
        neotest-rust
        nvim-nio
      ];
    };
  };
}
