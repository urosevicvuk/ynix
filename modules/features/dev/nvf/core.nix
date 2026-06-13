# Core: enables nvf, theme, which-key, and auto-loads every lua/*.lua file.
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

    # Escape hatch: drop a real .lua file in ./lua and it auto-loads as a
    # luaConfigRC DAG entry (full syntax highlighting, easy copy-paste).
    luaDir = ./lua;
    luaFiles =
      lib.filterAttrs
      (name: type: type == "regular" && lib.hasSuffix ".lua" name)
      (builtins.readDir luaDir);
    luaConfigRC =
      lib.mapAttrs'
      (name: _:
        lib.nameValuePair
        (lib.removeSuffix ".lua" name)
        (builtins.readFile (luaDir + "/${name}")))
      luaFiles;
  in {
    imports = [inputs.nvf.homeManagerModules.default];

    programs.nvf = {
      enable = true;

      settings.vim = {
        viAlias = false;
        vimAlias = true;
        syntaxHighlighting = true;

        # Auto-loaded lua/ files (see above).
        inherit luaConfigRC;

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
            "<leader>o" = "+opencode";
            "<leader>r" = "+rename";
            "<leader>t" = "+test";
            "<leader>u" = "+ui/toggle";
            "<leader>x" = "+trouble";
          };
        };
      };
    };
  };
}
