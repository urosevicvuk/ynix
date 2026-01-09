{
  lib,
  pkgs,
  config,
  inputs,
  ...
}: {
  options.theme = lib.mkOption {
    type = lib.types.attrs;
    default = {
      rounding = 18;
      gaps-in = 5;
      gaps-out = 5;
      active-opacity = 1;
      inactive-opacity = 1;
      blur = true;
      border-size = 2;
      animation-speed = "fast"; # "fast" | "medium" | "slow"
      fetch = "none"; # "nerdfetch" | "neofetch" | "pfetch" | "none"
      textColorOnWallpaper = config.lib.stylix.colors.base0D; # Color of the text displayed on the wallpaper (Lockscreen, display manager, ...) bar = { position = "top"; # "top" | "bottom"

      bar = {
        position = "top";
        transparent = true;
        transparentButtons = false;
        floating = true;
      };
    };
    description = "Theme configuration options";
  };

  config.stylix = {
    enable = true;

    # Gruvbox dark medium
    base16Scheme = {
      base00 = "282828"; # Default Background
      base01 = "3c3836"; # Lighter Background (Used for status bars, line number and folding marks)
      base02 = "504945"; # Selection Background
      base03 = "665c54"; # Comments, Invisibles, Line Highlighting
      base04 = "bdae93"; # Dark Foreground (Used for status bars)
      base05 = "d5c4a1"; # Default Foreground, Caret, Delimiters, Operators
      base06 = "ebdbb2"; # Light Foreground (Not often used)
      base07 = "fbf1c7"; # Light Background (Not often used)
      base08 = "fb4934"; # Variables, XML Tags, Markup Link Text, Markup Lists, Diff Deleted
      base09 = "fe8019"; # Integers, Boolean, Constants, XML Attributes, Markup Link Url
      base0A = "fabd2f"; # Classes, Markup Bold, Search Text Background
      base0B = "b8bb26"; # Strings, Inherited Class, Markup Code, Diff Inserted
      base0C = "8ec07c"; # Support, Regular Expressions, Escape Characters, Markup Quotes
      base0D = "83a598"; # Functions, Methods, Attribute IDs, Headings, Accent color
      base0E = "d3869b"; # Keywords, Storage, Selector, Markup Italic, Diff Changed
      base0F = "d65d0e"; # Deprecated, Opening/Closing Embedded Language Tags, e.g. <?php ?>
    };

    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
      size = 24;
    };

    fonts = {
      monospace = {
        #package = pkgs.nerd-fonts.blex-mono;
        #name = "Blex Mono Nerd Font";
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
}
