# Editor enhancements - motion, text objects, undo
{...}: {
  flake.homeModules.nvim = {pkgs, ...}: {
    programs.nvf.settings.vim = {
      utility.motion.flash-nvim.enable = true;

      startPlugins = with pkgs.vimPlugins; [
        nvim-surround
        undotree
      ];

      luaConfigRC.nvim-surround = ''
        require("nvim-surround").setup({})
      '';

      keymaps = [
        {
          key = "s";
          mode = "n";
          silent = true;
          action = "<cmd>lua require('flash').jump()<cr>";
          desc = "Flash";
        }
        {
          key = "<leader>u";
          mode = "n";
          silent = true;
          action = "<cmd>UndotreeToggle<CR>";
          desc = "Toggle Undotree";
        }
      ];
    };
  };
}
