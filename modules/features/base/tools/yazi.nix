{
  flake.nixosModules.base = {pkgs, ...}: {
    # TODO: add stylix support config for this shit

    programs.yazi = {
      enable = true;
      plugins = {
        inherit (pkgs.yaziPlugins) git;
        inherit (pkgs.yaziPlugins) diff;
        inherit (pkgs.yaziPlugins) jjui;
        inherit (pkgs.yaziPlugins) drag;
        inherit (pkgs.yaziPlugins) sudo;
        inherit (pkgs.yaziPlugins) chmod;
        inherit (pkgs.yaziPlugins) mount;
        inherit (pkgs.yaziPlugins) duckdb;
        inherit (pkgs.yaziPlugins) lazygit;
        inherit (pkgs.yaziPlugins) starship;
        inherit (pkgs.yaziPlugins) recycle-bin;
        inherit (pkgs.yaziPlugins) ouch;
      };
    };
  };
}
