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
  }: {
    imports = [inputs.stylix.nixosModules.stylix];

    config.stylix = {
      enable = true;

      base16Scheme = lib.filterAttrs (n: _: builtins.match "base0[0-9A-F]" n != null) self.theme;

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
          name = "SF Pro nerd font";
        };
        serif = config.stylix.fonts.sansSerif;
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

      polarity = "dark";
      image =
        pkgs.runCommand "optimized-gruvbox-wallpaper.jpg"
        {
          buildInputs = [pkgs.imagemagick];
        }
        ''
          ${pkgs.imagemagick}/bin/convert ${
            pkgs.fetchurl {
              url = "https://gruvbox-wallpapers.pages.dev/wallpapers/mix/wall.jpg";
              sha256 = "sha256-AyRt1FpaQR1hp9ERP+MRk4M58I0mzVsE7x9TtnBCSiw=";
            }
          } -resize 2880x1920^ -gravity center -extent 2880x1920 -quality 92 $out
        '';
    };
  };
}
