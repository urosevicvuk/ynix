{self, ...}: {
  flake.homeModules.neovim = {
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
        RainbowDelimiterGray.fg = "#928374";
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
          setupOpts.notify.enabled = false;
        };
      };

      utility.snacks-nvim = {
        enable = true;
        setupOpts = {
          dashboard = {
            enabled = true;
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
          image = {
            enabled = true;
            math.enabled = false;
          };
          scratch.enabled = true;
          #scroll.enabled = true;
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
        hipatterns = {
          enable = true;
          setupOpts.highlighters.hex_color = luaInline "require('mini.hipatterns').gen_highlighter.hex_color()";
        };
      };
    };
  };
}
