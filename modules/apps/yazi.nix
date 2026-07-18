{self, ...}: {
  # Self-registers into the `apps` group (merged with the other apps modules).
  flake.nixosModules.apps.imports = [self.nixosModules.yazi];

  flake.nixosModules.yazi = {...}: {
    home-manager.sharedModules = [self.homeModules.yazi];
  };

  flake.homeModules.yazi = {pkgs, ...}: {
    # TODO: add stylix support config for this shit

    programs.yazi = {
      enable = true;
      enableNushellIntegration = true;
      enableZshIntegration = true;
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
