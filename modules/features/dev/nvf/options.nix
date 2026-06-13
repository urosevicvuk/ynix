# Editor options, globals, and clipboard.
{self, ...}: {
  flake.nixosModules.nvf-options = {...}: {
    home-manager.sharedModules = [self.homeModules.nvf-options];
  };

  flake.homeModules.nvf-options = {...}: {
    programs.nvf.settings.vim = {
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
        navic_silence = true;
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
