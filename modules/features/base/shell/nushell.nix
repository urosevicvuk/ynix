{self, ...}: {
  flake.nixosModules.nushell = {...}: {
    home-manager.sharedModules = [self.homeModules.nushell];
  };

  flake.homeModules.nushell = {
    pkgs,
    lib,
    ...
  }: {
    programs.nushell = {
      enable = true;

      settings = {
        show_banner = false;
        edit_mode = "vi";
        use_kitty_protocol = true;
        rm.always_trash = true;
        highlight_resolved_externals = true;
        table = {
          mode = "rounded";
          index_mode = "auto";
        };
        cursor_shape = {
          vi_insert = "line";
          vi_normal = "block";
        };
      };
      extraEnv = ''
        $env.PROMPT_INDICATOR_VI_INSERT = "❯ "
        $env.PROMPT_INDICATOR_VI_NORMAL = "❮ "
        $env.MANPAGER = "sh -c 'col -bx | bat -l man -p'"
        $env.PAGER = "bat --plain"
        $env.MANROFFOPT = "-c"
      '';

      plugins = with pkgs.nushellPlugins; [
        polars
        gstat
        query
        formats
      ];

      shellAliases = {
        gitui = "lazygit";
        nix-shell = "nix-shell --command nu";
      };
    };

    home.packages = with pkgs; [
      rmtrash
      trash-cli
    ];
  };
}
