# Editor enhancements - motion, text objects, undo
{pkgs, ...}: {
  programs.nvf.settings.vim = {
    # Flash.nvim - Quick motion
    utility.motion.flash-nvim.enable = true;

    startPlugins = with pkgs.vimPlugins; [
      nvim-surround
      undotree
    ];

    luaConfigRC.nvim-surround = ''
      require("nvim-surround").setup({})
    '';

    keymaps = [
      # Flash motion
      {
        key = "s";
        mode = "n";
        silent = true;
        action = "<cmd>lua require('flash').jump()<cr>";
        desc = "Flash";
      }

      # Undotree
      {
        key = "<leader>u";
        mode = "n";
        silent = true;
        action = "<cmd>UndotreeToggle<CR>";
        desc = "Toggle Undotree";
      }
    ];
  };
}
