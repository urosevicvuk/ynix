# Git integration
{ ... }:
{
  flake.homeManagerModules.dev = { pkgs, ... }: {
        programs.nvf.settings.vim = {
          terminal.toggleterm = {
            enable = true;
            lazygit = {
              enable = true;
              mappings.open = "<leader>gl";
            };
          };

          startPlugins = with pkgs.vimPlugins; [ git-blame-nvim ];

          globals = {
            gitblame_enabled = false;
            gitblame_message_template = "<author> • <date> • <summary>";
            gitblame_date_format = "%r";
            gitblame_display_virtual_text = true;
          };

          keymaps = [
            {
              key = "<leader>gB";
              mode = "n";
              silent = true;
              action = "<cmd>GitBlameToggle<cr>";
              desc = "Toggle Git Blame";
            }
            {
              key = "<leader>gO";
              mode = "n";
              silent = true;
              action = "<cmd>GitBlameOpenCommitURL<cr>";
              desc = "Open Commit URL";
            }
            {
              key = "<leader>gC";
              mode = "n";
              silent = true;
              action = "<cmd>GitBlameCopySHA<cr>";
              desc = "Copy Commit SHA";
            }

            {
              key = "<leader>gF";
              mode = "n";
              silent = true;
              action = "<cmd>lua Snacks.picker.git_files()<cr>";
              desc = "Git files";
            }
            {
              key = "<leader>gb";
              mode = "n";
              silent = true;
              action = "<cmd>lua Snacks.picker.git_branches()<cr>";
              desc = "Git branches";
            }
            {
              key = "<leader>gL";
              mode = "n";
              silent = true;
              action = "<cmd>lua Snacks.picker.git_log()<cr>";
              desc = "Git log";
            }
            {
              key = "<leader>gf";
              mode = "n";
              silent = true;
              action = "<cmd>lua Snacks.picker.git_log_file()<cr>";
              desc = "Git log (current file)";
            }
            {
              key = "<leader>gS";
              mode = "n";
              silent = true;
              action = "<cmd>lua Snacks.picker.git_stash()<cr>";
              desc = "Git stash";
            }
            {
              key = "<leader>gs";
              mode = "n";
              silent = true;
              action = "<cmd>lua Snacks.picker.git_status()<cr>";
              desc = "Git status";
            }
            {
              key = "<leader>gd";
              mode = "n";
              silent = true;
              action = "<cmd>lua Snacks.picker.git_diff()<cr>";
              desc = "Git diff";
            }
          ];
        };
  };
}
