# UI - theme, statusline, visuals, mini, snacks
{ lib, pkgs, ... }:
{
  programs.nvf.settings.vim = {
    # Theme
    theme = {
      enable = true;
      name = lib.mkForce "gruvbox";
      style = lib.mkForce "dark";
      transparent = lib.mkForce true;
    };

    # Statusline
    statusline.lualine = {
      enable = true;
      theme = lib.mkForce "gruvbox_dark";
    };

    # Dashboard
    dashboard.alpha.enable = true;

    # Notifications
    ui.noice.enable = true;

    # Window borders
    ui.borders.enable = true;
    ui.fastaction.enable = true;
    ui.colorizer.enable = true;

    # Visual enhancements
    visuals = {
      rainbow-delimiters.enable = true;
      nvim-scrollbar.enable = false;
      nvim-web-devicons.enable = true;
      nvim-cursorline.enable = true;
      highlight-undo.enable = true;
      cinnamon-nvim.enable = true;
      fidget-nvim.enable = true;
      indent-blankline.enable = true;
    };

    # Mini.nvim suite
    mini = {
      starter.enable = true;
      comment.enable = true;
      cursorword.enable = true;
      icons.enable = true;
      indentscope.enable = true;
      notify.enable = true;
      pairs.enable = true;
      diff.enable = true;
      git.enable = true;
      ai.enable = true;
      splitjoin.enable = true;
      bracketed.enable = true;
      move.enable = true;
      align.enable = true;
      hipatterns.enable = true;
      trailspace.enable = true;
    };

    # Snacks.nvim suite
    utility.snacks-nvim = {
      enable = true;
      setupOpts = {
        image.enabled = true;
        quickfile.enabled = true;
        statuscolumn.enabled = true;
        zen.enabled = true;
        bufdelete.enabled = true;
        input.enabled = true;
        terminal.enabled = true;
        picker.enabled = true;
        explorer.enabled = true;
        gitsigns.enabled = true;
      };
    };

    startPlugins = with pkgs.vimPlugins; [
      vim-highlightedyank
    ];

    luaConfigRC.rainbow-delimiters-config = ''
      local rainbow_delimiters = require('rainbow-delimiters')
      vim.g.rainbow_delimiters = {
        strategy = { [""] = rainbow_delimiters.strategy['global'] },
        query = { [""] = 'rainbow-delimiters' },
        highlight = { 'RainbowDelimiterGray' },
      }
      vim.api.nvim_set_hl(0, 'RainbowDelimiterGray', { fg = '#928374' })
    '';

    luaConfigRC.highlightedyank = ''
      vim.g.highlightedyank_highlight_duration = 200
    '';
  };
}
