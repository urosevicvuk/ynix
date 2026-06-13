# UI layer: statusline, snacks suite, noice, visuals, and visual mini modules.
{self, ...}: {
  flake.nixosModules.nvf-ui = {...}: {
    home-manager.sharedModules = [self.homeModules.nvf-ui];
  };

  flake.homeModules.nvf-ui = {
    lib,
    config,
    ...
  }: let
    theme = config.theme.active;
  in {
    programs.nvf.settings.vim = {
      statusline.lualine = {
        enable = true;
        theme = lib.mkForce theme.nvim-lualine-theme;
      };

      ui = {
        borders.enable = true;
        noice = {
          enable = true;
          # snacks.notifier owns vim.notify toasts; noice handles the
          # cmdline/messages/LSP-progress only.
          setupOpts.notify.enabled = false;
        };
      };

      utility.snacks-nvim = {
        enable = true;
        setupOpts = {
          dashboard.enabled = true;
          picker.enabled = true;
          explorer.enabled = true;
          notifier.enabled = true;
          input.enabled = true;
          quickfile.enabled = true;
          statuscolumn.enabled = true;
          bufdelete.enabled = true;
          terminal.enabled = true;
          zen.enabled = true;
          image.enabled = true;
          scratch.enabled = true;
        };
      };

      visuals = {
        rainbow-delimiters.enable = true;
        highlight-undo.enable = true;
        cinnamon-nvim.enable = true;
        indent-blankline.enable = true;
        # mini.icons is the icon provider; don't pull in web-devicons too.
        nvim-web-devicons.enable = false;
      };

      mini = {
        icons.enable = true;
        indentscope.enable = true;
        hipatterns.enable = true;
      };
    };
  };
}
