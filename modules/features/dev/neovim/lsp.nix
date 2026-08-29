# LSP, treesitter, completion, diagnostics UI, debugging, and testing.
{self, ...}: {
  flake.homeModules.neovim = {
    pkgs,
    lib,
    ...
  }: let
    # Servers whose binary should come from the project's dev shell rather than
    # the store path nvf pins at build time. A bare command (no store path) makes
    # Neovim resolve it from PATH, which direnv has already populated from the
    # project flake. This is nvf's documented pattern - see "Configuring LSP
    # presets" in the manual, which uses mkForce for exactly this reason.
    #
    # mkForce is required, not incidental: none of nvf's 92 LSP presets set `cmd`
    # with mkDefault, and there is no global "don't pull LSP packages" switch.
    #
    # haskell-language-server: the nixpkgs HLS wrapper insists the ghc on PATH be
    # the exact store path it was built against - a matching version is not
    # enough - so nvf's pinned HLS can never match a project devshell's GHC. Its
    # complaint is emitted with a wrong Content-Length (203 declared, 281 actual),
    # so Neovim surfaces it as INVALID_SERVER_JSON rather than a readable message.
    lspFromDevShell = {
      "haskell-language-server" = ["haskell-language-server-wrapper" "--lsp"];
    };
  in {
    programs.nvf.settings.vim = {
      # Diagnostics: custom gutter icons + inline virtual text, no insert-update.
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
          # Resolve these from PATH (dev shell) instead of nvf's pinned packages.
          # Trade-off: a project with no dev shell gets no server at all, rather
          # than a pinned one that cannot start against the project's toolchain.
          lib.mapAttrs (_: cmd: {cmd = lib.mkForce cmd;}) lspFromDevShell
          // {
            # nvf's clang module registers clangd for proto too, but open-source
            # clangd can't parse protobuf ("invalid AST"); upstream lspconfig
            # reverted the proto filetype in 2025 (nvim-lspconfig#3959).
            clangd.filetypes = lib.mkForce ["c" "cpp" "objc" "objcpp" "cuda"];

            # Protobuf has no nvf language module: wire its LSP by hand.
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
    };
  };
}
