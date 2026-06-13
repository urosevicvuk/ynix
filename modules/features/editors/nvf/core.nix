# Core: enables nvf, theme, and which-key.
# This is the only module that imports the nvf option module + sets enable;
# the sibling modules just set `programs.nvf.settings.vim.*` and rely on this.
{
  self,
  inputs,
  ...
}: {
  flake.nixosModules.nvf-core = {...}: {
    home-manager.sharedModules = [self.homeModules.nvf-core];
  };

  flake.homeModules.nvf-core = {
    lib,
    config,
    ...
  }: let
    theme = config.theme.active;
  in {
    imports = [inputs.nvf.homeManagerModules.default];

    programs.nvf = {
      enable = true;

      settings.vim = {
        viAlias = false;
        vimAlias = true;
        syntaxHighlighting = true;

        theme = {
          enable = true;
          name = lib.mkForce theme.nvim-theme;
          style = lib.mkForce theme.nvim-theme-style;
          transparent = lib.mkForce true;
        };

        binds.whichKey = {
          enable = true;
          register = {
            "<leader>b" = "+buffer";
            "<leader>c" = "+code";
            "<leader>d" = "+debug";
            "<leader>f" = "+find/file";
            "<leader>g" = "+git";
            "<leader>gh" = "+hunk";
            "<leader>r" = "+rename";
            "<leader>u" = "+ui/toggle";
            "<leader>x" = "+trouble";
          };
        };
      };
    };
  };
}
