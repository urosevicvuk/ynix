# Spicetify - Spotify client customizer
{ inputs, ... }:
{
  flake.nixosModules.spicetify = { config, ... }: {
    home-manager.users.${config.preferences.username}.imports = [
      inputs.spicetify-nix.homeManagerModules.default
      ({ config, pkgs, ... }:
      let
        spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.system};
        accent = "${config.lib.stylix.colors.base0D}";
        background = "${config.lib.stylix.colors.base00}";
      in
      {
        programs.spicetify = {
          enable = true;

          customColorScheme = {
            button = accent;
            button-active = accent;
            tab-active = accent;
            player = background;
            main = background;
            sidebar = background;
          };

          enabledExtensions = with spicePkgs.extensions; [
            playlistIcons
            historyShortcut
            hidePodcasts
            adblock
            fullAppDisplay
            keyboardShortcut
          ];
        };
      })
    ];
  };
}
