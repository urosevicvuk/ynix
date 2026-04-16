# Navigation - file explorer, fuzzy finder, marks, buffers
{...}: {
  flake.homeModules.nvim = {pkgs, ...}: {
    programs.nvf.settings.vim = {
      utility.yazi-nvim = {
        enable = true;
        mappings = {
          openYazi = "<leader>-";
          openYaziDir = "<leader>=";
        };
      };
      utility.oil-nvim.enable = true;

      navigation.harpoon = {
        enable = true;
        mappings = {
          markFile = "<leader>m";
          listMarks = "<leader>\`";
          file1 = "<leader>1";
          file2 = "<leader>2";
          file3 = "<leader>3";
          file4 = "<leader>4";
        };
      };

      utility.outline.aerial-nvim.enable = true;

      startPlugins = [pkgs.vimPlugins.vim-tmux-navigator];

      keymaps = [
        {
          key = "<leader><space>";
          mode = "n";
          silent = true;
          action = "<cmd>lua Snacks.picker.files()<cr>";
          desc = "Find files (quick)";
        }
        {
          key = "<leader>/";
          mode = "n";
          silent = true;
          action = "<cmd>lua Snacks.picker.grep()<cr>";
          desc = "Grep (quick)";
        }
        {
          key = "<leader>,";
          mode = "n";
          silent = true;
          action = "<cmd>lua Snacks.picker.buffers()<cr>";
          desc = "Buffers (quick)";
        }
        {
          key = "<leader>:";
          mode = "n";
          silent = true;
          action = "<cmd>lua Snacks.picker.command_history()<cr>";
          desc = "Command history";
        }
        {
          key = "<leader>e";
          mode = "n";
          silent = true;
          action = "<cmd>lua Snacks.explorer()<cr>";
          desc = "Explorer (quick)";
        }

        {
          key = "<leader>ff";
          mode = "n";
          silent = true;
          action = "<cmd>lua Snacks.picker.files()<cr>";
          desc = "Find files";
        }
        {
          key = "<leader>fa";
          mode = "n";
          silent = true;
          action = "<cmd>lua Snacks.picker.files({ hidden = true })<cr>";
          desc = "Find all files (including hidden)";
        }
        {
          key = "<leader>fb";
          mode = "n";
          silent = true;
          action = "<cmd>lua Snacks.picker.buffers()<cr>";
          desc = "Find buffers";
        }
        {
          key = "<leader>fo";
          mode = "n";
          silent = true;
          action = "<cmd>lua Snacks.picker.recent()<cr>";
          desc = "Recent files";
        }
        {
          key = "<leader>fe";
          mode = "n";
          silent = true;
          action = "<cmd>lua Snacks.explorer()<cr>";
          desc = "Snacks explorer";
        }
        {
          key = "<leader>fO";
          mode = "n";
          silent = true;
          action = "<cmd>lua require('oil').open_float()<cr>";
          desc = "Oil (buffer-based)";
        }
        {
          key = "-";
          mode = "n";
          silent = true;
          action = "<cmd>lua require('oil').open()<cr>";
          desc = "Open Oil in current window";
        }

        {
          key = "<leader>fw";
          mode = "n";
          silent = true;
          action = "<cmd>lua Snacks.picker.grep()<cr>";
          desc = "Grep word";
        }
        {
          key = "<leader>fW";
          mode = "n";
          silent = true;
          action = "<cmd>lua Snacks.picker.grep_word()<cr>";
          desc = "Grep word under cursor";
        }
        {
          key = "<leader>fl";
          mode = "n";
          silent = true;
          action = "<cmd>lua Snacks.picker.lines()<cr>";
          desc = "Search lines in current buffer";
        }
        {
          key = "<leader>ft";
          mode = "n";
          silent = true;
          action = "<cmd>lua Snacks.picker.todo_comments()<cr>";
          desc = "Find todos";
        }
        {
          key = "<leader>fc";
          mode = "n";
          silent = true;
          action = "<cmd>lua Snacks.picker.files({ cwd = vim.fn.stdpath('config') })<cr>";
          desc = "Find config files";
        }
        {
          key = "<leader>fp";
          mode = "n";
          silent = true;
          action = "<cmd>lua Snacks.picker.projects()<cr>";
          desc = "Find projects";
        }
        {
          key = "<leader>fn";
          mode = "n";
          silent = true;
          action = "<cmd>lua Snacks.picker.notifications()<cr>";
          desc = "Notification history";
        }
        {
          key = "<leader>fB";
          mode = "n";
          silent = true;
          action = "<cmd>lua Snacks.picker.grep_buffers()<cr>";
          desc = "Grep in open buffers";
        }
        {
          key = "<leader>fu";
          mode = "n";
          silent = true;
          action = "<cmd>lua Snacks.picker.undo()<cr>";
          desc = "Undo history";
        }
        {
          key = "<leader>fs";
          mode = "n";
          silent = true;
          action = "<cmd>lua Snacks.picker.lsp_symbols()<cr>";
          desc = "LSP symbols (file)";
        }
        {
          key = "<leader>fS";
          mode = "n";
          silent = true;
          action = "<cmd>lua Snacks.picker.lsp_workspace_symbols()<cr>";
          desc = "LSP symbols (workspace)";
        }

        {
          key = "<leader>bd";
          mode = "n";
          silent = true;
          action = "<cmd>lua Snacks.bufdelete()<cr>";
          desc = "Delete Buffer";
        }
        {
          key = "<leader>bD";
          mode = "n";
          silent = true;
          action = "<cmd>lua Snacks.bufdelete.all()<cr>";
          desc = "Delete All Buffers";
        }
        {
          key = "<leader>bo";
          mode = "n";
          silent = true;
          action = "<cmd>lua Snacks.bufdelete.other()<cr>";
          desc = "Delete Other Buffers";
        }
        {
          key = "<leader>bn";
          mode = "n";
          silent = true;
          action = "<cmd>bnext<cr>";
          desc = "Next Buffer";
        }
        {
          key = "<leader>bp";
          mode = "n";
          silent = true;
          action = "<cmd>bprevious<cr>";
          desc = "Previous Buffer";
        }
        {
          key = "<leader>bl";
          mode = "n";
          silent = true;
          action = "<cmd>blast<cr>";
          desc = "Last Buffer";
        }
        {
          key = "<leader>bf";
          mode = "n";
          silent = true;
          action = "<cmd>bfirst<cr>";
          desc = "First Buffer";
        }
      ];
    };
  };
}
