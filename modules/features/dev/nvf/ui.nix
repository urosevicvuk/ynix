# UI layer: statusline, snacks suite, noice, visuals, and visual mini modules.
{self, ...}: {
  flake.nixosModules.nvf-ui = {...}: {
    home-manager.sharedModules = [self.homeModules.nvf-ui];
  };

  flake.homeModules.nvf-ui = {
    lib,
    config,
    ...
  }: let
    theme = config.theme.active;
    luaInline = expr: {
      _type = "lua-inline";
      inherit expr;
    };
  in {
    programs.nvf.settings.vim = {
      highlight = {
        # Single-color (gray) rainbow delimiters instead of multi-color.
        RainbowDelimiterGray.fg = "#928374";
        # snacks.words: underline references instead of the slow-feeling bg.
        LspReferenceText = {
          bg = "NONE";
          underline = true;
        };
        LspReferenceRead = {
          bg = "NONE";
          underline = true;
        };
        LspReferenceWrite = {
          bg = "NONE";
          underline = true;
        };
      };

      statusline.lualine = {
        enable = true;
        theme = lib.mkForce theme.nvim-lualine-theme;
      };

      ui = {
        borders.enable = true;
        noice = {
          enable = true;
          # snacks.notifier owns vim.notify toasts; noice handles the
          # cmdline/messages/LSP-progress only.
          setupOpts.notify.enabled = false;
        };
      };

      utility.snacks-nvim = {
        enable = true;
        setupOpts = {
          dashboard = {
            enabled = true;
            # Custom sections: the default set includes a "startup" section that
            # require()s lazy.nvim's stats, which nvf doesn't ship (it uses lz.n).
            sections = [
              {section = "header";}
              {
                section = "keys";
                gap = 1;
                padding = 1;
              }
              {
                section = "recent_files";
                icon = " ";
                title = "Recent Files";
                padding = 1;
              }
              {
                section = "projects";
                icon = " ";
                title = "Projects";
                padding = 1;
              }
            ];
          };
          picker.enabled = true;
          explorer.enabled = true;
          notifier.enabled = true;
          input.enabled = true;
          quickfile.enabled = true;
          statuscolumn.enabled = true;
          bufdelete.enabled = true;
          terminal.enabled = true;
          zen.enabled = true;
          image.enabled = true;
          scratch.enabled = true;
          # snacks.scroll (was cinnamon-nvim) + snacks.words (was mini.cursorword).
          # Indent guides/scope stay on indent-blankline + mini.indentscope below.
          scroll.enabled = true;
          words = {
            enabled = true;
            debounce = 100;
          };
        };
      };

      visuals = {
        rainbow-delimiters = {
          enable = true;
          setupOpts = {
            strategy."" = luaInline "require('rainbow-delimiters').strategy['global']";
            query."" = "rainbow-delimiters";
            highlight = ["RainbowDelimiterGray"];
          };
        };
        highlight-undo.enable = true;
        indent-blankline.enable = true;
        nvim-web-devicons.enable = true;
      };

      mini = {
        icons.enable = true;
        indentscope.enable = true;
        hipatterns.enable = true;
      };
    };
  };
}
