# Spicetify - Spotify client customizer
{
  self,
  inputs,
  ...
}: {
  flake.nixosModules.spicetify = {...}: {
    home-manager.sharedModules = [self.homeModules.spotify];
  };

  flake.homeModules.spotify = {
    pkgs,
    lib,
    config,
    ...
  }: let
    spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.system};
    theme = config.theme.active;
    accent = theme.base0D;
    background = theme.base00;
  in {
    imports = [inputs.spicetify-nix.homeManagerModules.default];

    programs.spicetify = {
      enable = true;

      alwaysEnableDevTools = true;
      experimentalFeatures = true;
      wayland = true;

      customColorScheme = {
        button = accent;
        button-active = accent;
        tab-active = accent;
        player = background;
        main = background;
        sidebar = background;
      };

      enabledExtensions = with spicePkgs.extensions; [
        fullAppDisplay
        keyboardShortcut
      ];
    };
  };
}
