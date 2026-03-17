# Core vim settings - options, globals, and general keymaps
{...}: {
  programs.nvf.settings.vim = {
    # Aliases and basic settings
    viAlias = false;
    vimAlias = true;
    withNodeJs = true;
    syntaxHighlighting = true;

    # Vim options
    options = {
      autoindent = true;
      smartindent = true;
      foldlevel = 99;
      foldcolumn = "auto:1";
      mousescroll = "ver:1,hor:1";
      mousemoveevent = true;
      fillchars = "eob:‿,fold: ,foldopen:▼,foldsep:⸽,foldclose:⏵";
      signcolumn = "yes";
      wrap = false;
      scrolloff = 9;
    };

    # Clipboard
    clipboard = {
      enable = true;
      registers = "unnamedplus";
      providers.wl-copy.enable = true;
    };

    # Global variables
    globals = {
      mapleader = " ";
      navic_silence = true;
      suda_smart_edit = 1;
      neovide_scale_factor = 0.7;
      neovide_cursor_animation_length = 0.1;
      neovide_cursor_short_animation_length = 0;
    };

    # Which-key groups
    binds.whichKey = {
      enable = true;
      register = {
        "<leader>b" = "+buffer";
        "<leader>c" = "+code";
        "<leader>d" = "+debug";
        "<leader>f" = "+find/file";
        "<leader>g" = "+git";
        "<leader>m" = "+marks";
        "<leader>o" = "+opencode";
        "<leader>q" = "+quit";
        "<leader>r" = "+refactor";
        "<leader>s" = "+session";
        "<leader>t" = "+test";
        "<leader>u" = "+ui/toggle";
        "<leader>w" = "+window";
        "<leader>x" = "+trouble/diagnostics";
        "<leader>9" = "+99 AI";
      };
    };

    # General keymaps
    keymaps = [
      # Basic operations
      {
        key = "<leader>w";
        mode = "n";
        silent = true;
        action = ":w<CR>";
        desc = "Save";
      }
      {
        key = "<leader>q";
        mode = "n";
        silent = true;
        action = ":q<CR>";
        desc = "Quit";
      }
      {
        key = "<leader>r";
        mode = "n";
        silent = true;
        action = ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>";
        desc = "Refactor word under cursor";
      }
      {
        key = "Q";
        mode = "n";
        silent = true;
        action = "<nop>";
        desc = "Disable Q";
      }
      {
        key = "p";
        mode = "x";
        silent = true;
        action = "\"_dP";
        desc = "Paste and keep selection";
      }

      # Navigation improvements
      {
        key = "N";
        mode = "n";
        silent = true;
        action = "Nzzzv";
        desc = "Previous search result";
      }
      {
        key = "n";
        mode = "n";
        silent = true;
        action = "nzzzv";
        desc = "Next search result";
      }
      {
        key = "<C-u>";
        mode = "n";
        silent = true;
        action = "<C-u>zz";
        desc = "Scroll up";
      }
      {
        key = "<C-d>";
        mode = "n";
        silent = true;
        action = "<C-d>zz";
        desc = "Scroll down";
      }
      {
        key = "J";
        mode = "n";
        silent = true;
        action = "mzJ`z";
        desc = "Join lines";
      }

      # Visual mode line movement
      {
        key = "J";
        mode = "v";
        silent = true;
        action = ":m '>+1<cr>gv=gv";
        desc = "Move selected lines down";
      }
      {
        key = "K";
        mode = "v";
        silent = true;
        action = ":m '<-2<cr>gv=gv";
        desc = "Move selected lines up";
      }

      # Quick navigation to line edges
      {
        key = "L";
        mode = "v";
        silent = true;
        action = "$";
        desc = "Go all the way right";
      }
      {
        key = "H";
        mode = "v";
        silent = true;
        action = "^";
        desc = "Go all the way left";
      }
      {
        key = "L";
        mode = "n";
        silent = true;
        action = "$";
        desc = "Go all the way right";
      }
      {
        key = "H";
        mode = "n";
        silent = true;
        action = "^";
        desc = "Go all the way left";
      }

      # Buffer navigation
      {
        key = "<C-tab>";
        mode = "n";
        silent = true;
        action = "<cmd>bnext<cr>";
        desc = "Next Buffer";
      }
      {
        key = "<C-S-tab>";
        mode = "n";
        silent = true;
        action = "<cmd>bprev<cr>";
        desc = "Previous Buffer";
      }

      # Disable arrow keys
      {
        key = "<Up>";
        mode = "n";
        silent = true;
        action = "<Nop>";
        desc = "Disable Up Arrow";
      }
      {
        key = "<Down>";
        mode = "n";
        silent = true;
        action = "<Nop>";
        desc = "Disable Down Arrow";
      }
      {
        key = "<Left>";
        mode = "n";
        silent = true;
        action = "<Nop>";
        desc = "Disable Left Arrow";
      }
      {
        key = "<Right>";
        mode = "n";
        silent = true;
        action = "<Nop>";
        desc = "Disable Right Arrow";
      }

      # UI toggles
      {
        key = "<leader><BS>";
        mode = "n";
        silent = true;
        action = "<cmd>nohlsearch<cr>";
        desc = "Reset search";
      }
      {
        key = "<leader>uw";
        mode = "n";
        silent = true;
        action = "<cmd>set wrap!<cr>";
        desc = "Toggle word wrapping";
      }
      {
        key = "<leader>ul";
        mode = "n";
        silent = true;
        action = "<cmd>set linebreak!<cr>";
        desc = "Toggle linebreak";
      }
      {
        key = "<leader>us";
        mode = "n";
        silent = true;
        action = "<cmd>set spell!<cr>";
        desc = "Toggle spellcheck";
      }
      {
        key = "<leader>uc";
        mode = "n";
        silent = true;
        action = "<cmd>set cursorline!<cr>";
        desc = "Toggle cursorline";
      }
      {
        key = "<leader>un";
        mode = "n";
        silent = true;
        action = "<cmd>set number!<cr>";
        desc = "Toggle line numbers";
      }
      {
        key = "<leader>ur";
        mode = "n";
        silent = true;
        action = "<cmd>set relativenumber!<cr>";
        desc = "Toggle relative line numbers";
      }
      {
        key = "<leader>ut";
        mode = "n";
        silent = true;
        action = "<cmd>set showtabline=2<cr>";
        desc = "Show tabline";
      }
      {
        key = "<leader>uT";
        mode = "n";
        silent = true;
        action = "<cmd>set showtabline=0<cr>";
        desc = "Hide tabline";
      }

      # Window management
      {
        key = "<leader>ws";
        mode = "n";
        silent = true;
        action = "<cmd>split<cr>";
        desc = "Split";
      }
      {
        key = "<leader>wv";
        mode = "n";
        silent = true;
        action = "<cmd>vsplit<cr>";
        desc = "VSplit";
      }
      {
        key = "<leader>wd";
        mode = "n";
        silent = true;
        action = "<cmd>close<cr>";
        desc = "Close";
      }
    ];
  };
}
