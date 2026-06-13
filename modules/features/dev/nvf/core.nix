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

        # The one piece of raw lua with no nvf-option equivalent: runs before
        # everything else to silence nvim-lspconfig's one-time "require(
        # 'lspconfig') framework is deprecated" notice - nvf still uses that
        # framework internally, so it fires on every startup. Remove once nvf
        # migrates to vim.lsp.config.
        # "require('lspconfig') framework is deprecated" notice - nvf still
        # uses that framework internally, so it fires on every startup.
        # Remove once nvf migrates to vim.lsp.config.
        luaConfigPre = ''
          local _deprecate = vim.deprecate
          vim.deprecate = function(name, ...)
            if type(name) == "string" and name:find("lspconfig", 1, true) then
              return
            end
            return _deprecate(name, ...)
          end
        '';

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
