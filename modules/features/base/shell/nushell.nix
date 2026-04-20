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
        edit_mode = "vi";
        cursor_shape = {
          vi_insert = "line";
          vi_normal = "block";
        };
      };
      extraEnv = ''
        $env.PROMPT_INDICATOR_VI_INSERT = ""
        $env.PROMPT_INDICATOR_VI_NORMAL = ""
      '';

      plugins = with pkgs.nushellPlugins; [
        polars
        gstat
        query
        formats
      ];

      shellAliases = {
        g = "git";
        k = "kubectl";
        t = "talosctl";
        rm = lib.getExe pkgs.rmtrash;
        rmdir = lib.getExe pkgs.rmtrash;
      };
    };

    home.packages = with pkgs; [
      bat
      television
      ripgrep
      tldr
      rmtrash
      jq
    ];
  };
}
