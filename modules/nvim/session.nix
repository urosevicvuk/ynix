# Session and project management
{ ... }:
{
  flake.homeManagerModules.nvim = { pkgs, ... }: {
        programs.nvf.settings.vim = {
          projects.project-nvim.enable = true;

          startPlugins = with pkgs.vimPlugins; [ persistence-nvim ];

          luaConfigRC.persistence = ''
            require("persistence").setup({
              dir = vim.fn.expand(vim.fn.stdpath("state") .. "/sessions/"),
              options = { "buffers", "curdir", "tabpages", "winsize" },
            })
          '';

          keymaps = [
            {
              key = "<leader>sr";
              mode = "n";
              silent = true;
              action = "<cmd>lua require('persistence').load()<cr>";
              desc = "Restore Session";
            }
            {
              key = "<leader>sl";
              mode = "n";
              silent = true;
              action = "<cmd>lua require('persistence').load({ last = true })<cr>";
              desc = "Restore Last Session";
            }
            {
              key = "<leader>sd";
              mode = "n";
              silent = true;
              action = "<cmd>lua require('persistence').stop()<cr>";
              desc = "Don't Save Current Session";
            }
          ];
        };
  };
}
