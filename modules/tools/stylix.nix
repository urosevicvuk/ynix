{
  self,
  inputs,
  ...
}: {
  flake.nixosModules.stylix = {
    lib,
    pkgs,
    config,
    ...
  }: let
    theme = config.theme.active;
  in {
    imports = [inputs.stylix.nixosModules.stylix];

    config.stylix = {
      enable = true;

      base16Scheme = lib.filterAttrs (n: _: builtins.match "base0[0-9A-F]" n != null) theme;

      cursor = {
        package = pkgs.bibata-cursors;
        name = "Bibata-Modern-Ice";
        size = 24;
      };

      fonts = {
        monospace = {
          package = pkgs.nerd-fonts.jetbrains-mono;
          name = "Jetbrains Mono Nerd Font";
        };
        sansSerif = {
          package = inputs.apple-fonts.packages.${pkgs.system}.sf-pro-nerd;
          name = "SFProDisplay Nerd Font";
        };
        serif = {
          package = inputs.apple-fonts.packages.${pkgs.system}.sf-pro-nerd;
          name = "SFProDisplay Nerd Font";
        };
        emoji = {
          package = pkgs.noto-fonts-color-emoji;
          name = "Noto Color Emoji";
        };
        sizes = {
          applications = 13;
          desktop = 13;
          popups = 13;
          terminal = 13;
        };
      };

      polarity = theme.stylix-polarity;
      image =
        pkgs.runCommand "optimized-wallpaper.jpg"
        {
          buildInputs = [pkgs.imagemagick];
        }
        ''
          ${pkgs.imagemagick}/bin/convert ${
            pkgs.fetchurl {
              url = theme.stylix-wallpaper-url;
              sha256 = theme.stylix-wallpaper-hash;
            }
          } -resize 2880x1920^ -gravity center -extent 2880x1920 -quality 92 $out
        '';
    };
  };
}
