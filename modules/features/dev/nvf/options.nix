# Editor options, globals, and clipboard.
{self, ...}: {
  flake.nixosModules.nvf-options = {...}: {
    home-manager.sharedModules = [self.homeModules.nvf-options];
  };

  flake.homeModules.nvf-options = {...}: let
    luaInline = expr: {
      _type = "lua-inline";
      inherit expr;
    };
  in {
    programs.nvf.settings.vim = {
      augroups = [
        {
          enable = true;
          name = "highlight_yank";
          clear = true;
        }
        {
          enable = true;
          name = "last_loc";
          clear = true;
        }
      ];

      autocmds = [
        {
          enable = true;
          event = ["TextYankPost"];
          group = "highlight_yank";
          desc = "Highlight yanked text";
          callback = luaInline ''
            function()
              (vim.hl or vim.highlight).on_yank({ timeout = 200 })
            end
          '';
        }
        {
          enable = true;
          event = ["BufReadPost"];
          group = "last_loc";
          desc = "Restore last cursor position";
          callback = luaInline ''
            function(args)
              local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
              local lcount = vim.api.nvim_buf_line_count(args.buf)
              if mark[1] > 0 and mark[1] <= lcount then
                pcall(vim.api.nvim_win_set_cursor, 0, mark)
              end
            end
          '';
        }
      ];

      options = {
        # Line numbers (hybrid: absolute current line, relative elsewhere).
        number = true;
        relativenumber = true;

        # Indentation: Neovim reads .editorconfig automatically; these are the
        # 2-space fallback for files/languages that don't specify their own.
        expandtab = true;
        shiftwidth = 2;
        tabstop = 2;
        softtabstop = 2;
        autoindent = true;
        smartindent = true;

        # Search.
        ignorecase = true;
        smartcase = true;

        # Splits open to the right / below.
        splitright = true;
        splitbelow = true;

        # Persistent undo (pairs with undotree).
        undofile = true;

        # Mouse disabled (keyboard-only).
        mouse = "";

        signcolumn = "yes";
        wrap = false;
        scrolloff = 9;

        # Folding: treesitter folds, everything open on load, fancy fold column.
        foldlevel = 99;
        foldcolumn = "auto:1";
        fillchars = "eob:‿,fold: ,foldopen:▼,foldsep:⸽,foldclose:⏵";
      };

      globals = {
        mapleader = " ";
        maplocalleader = " ";
        suda_smart_edit = 1;
      };

      clipboard = {
        enable = true;
        registers = "unnamedplus";
        providers.wl-copy.enable = true;
      };
    };
  };
}
