# Editing: motion, editing mini modules, file navigation, marks, sessions.
{self, ...}: {
  flake.homeModules.neovim = {pkgs, ...}: {
    programs.nvf.settings.vim = {
      # Seamless <C-hjkl> across nvim splits and tmux panes + sudo writes.
      startPlugins = with pkgs.vimPlugins; [
        vim-tmux-navigator
        vim-suda
      ];

      mini = {
        pairs.enable = true;
        surround.enable = true;
        ai.enable = true;
        move.enable = true;
      };

      utility = {
        motion.flash-nvim.enable = true;
        oil-nvim.enable = true;
        undotree.enable = true;
        direnv.enable = true;
        yazi-nvim = {
          enable = true;
          mappings.openYaziDir = "<leader>-";
        };
        yanky-nvim = {
          enable = true;
          setupOpts.ring.storage = "sqlite";
        };
      };

      navigation.harpoon = {
        enable = true;
        mappings = {
          markFile = "<leader>m";
          listMarks = "<leader>`";
          file1 = "<leader>1";
          file2 = "<leader>2";
          file3 = "<leader>3";
          file4 = "<leader>4";
        };
      };

      projects.project-nvim.enable = true;
      notes.todo-comments.enable = true;
    };
  };
}
