{
  self,
  inputs,
  ...
}: {
  flake.nixosModules.apps.imports = [self.nixosModules.spicetify];

  flake.nixosModules.spicetify = {pkgs, ...}: {
    home-manager.sharedModules = [self.homeModules.spotify];

    environment.systemPackages = with pkgs; [
      cliamp
      ];
  };

  flake.homeModules.spotify = {
    pkgs,
    lib,
    config,
    ...
  }: let
    spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};
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

      #customColorScheme = {
      #  button = accent;
      #  button-active = accent;
      #  tab-active = accent;
      #  player = background;
      #  main = background;
      #  sidebar = background;
      #};

      theme = lib.mkForce spicePkgs.themes.text;
      colorScheme = lib.mkForce "Gruvbox";

      enabledExtensions = with spicePkgs.extensions; [
        adblock
        fullAppDisplay
        keyboardShortcut
        shuffle
      ];
    };
  };
}
