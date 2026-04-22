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

        rm.always_trash = true;

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
        lg = "lazygit";
        nix-shell = "nix-shell --command nu";
      };
    };

    home.packages = with pkgs; [
      rmtrash
      trash-cli
    ];
  };
}
