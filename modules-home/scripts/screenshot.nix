# - ## Screenshot
#-
#- Capture-first screenshot scripts. The screen is captured before
#- region selection so the crosshair cursor never appears in the image.
#-
#- - `screenshot-region` - Capture screen, select region, copy to clipboard.
#- - `screenshot-region-annotate` - Capture screen, select region, open in satty.
#- - `screenshot-screen` - Screenshot the focused monitor to clipboard.
#- - `screenshot-screen-annotate` - Screenshot the focused monitor, open in satty.
{pkgs, ...}: let
  screenshotDir = "$HOME/Pictures/Screenshots";

  screenshot-region =
    pkgs.writeShellScriptBin "screenshot-region"
    # bash
    ''
        mkdir -p ${screenshotDir}
        tmp=$(mktemp /tmp/screenshot-XXXXXX.png)
        trap "rm -f $tmp" EXIT

        read -r focused mon_x mon_y scale < <(hyprctl monitors -j | ${pkgs.jq}/bin/jq -r '.[] | select(.focused) | "\(.name) \(.x) \(.y) \(.scale)"')
        ${pkgs.grim}/bin/grim -o "$focused" "$tmp"

      region=$(${pkgs.slurp}/bin/slurp -o "$focused" -b '#ffffff33' -c '#ffffff' -f '%x,%y %wx%h') || exit 1
        IFS=', x' read -r x y w h <<< "$region"
        rel_x=$((x - mon_x))
        rel_y=$((y - mon_y))
        px_x=$(awk -v v="$rel_x" -v s="$scale" 'BEGIN { printf "%.0f", v * s }')
        px_y=$(awk -v v="$rel_y" -v s="$scale" 'BEGIN { printf "%.0f", v * s }')
        px_w=$(awk -v v="$w" -v s="$scale" 'BEGIN { printf "%.0f", v * s }')
        px_h=$(awk -v v="$h" -v s="$scale" 'BEGIN { printf "%.0f", v * s }')
        crop="''${px_w}x''${px_h}+''${px_x}+''${px_y}"

        ${pkgs.imagemagick}/bin/magick "$tmp" -crop "$crop" +repage png:- | ${pkgs.wl-clipboard}/bin/wl-copy
    '';

  screenshot-region-annotate =
    pkgs.writeShellScriptBin "screenshot-region-annotate"
    # bash
    ''
        mkdir -p ${screenshotDir}
        tmp=$(mktemp /tmp/screenshot-XXXXXX.png)
        trap "rm -f $tmp" EXIT

        read -r focused mon_x mon_y scale < <(hyprctl monitors -j | ${pkgs.jq}/bin/jq -r '.[] | select(.focused) | "\(.name) \(.x) \(.y) \(.scale)"')
        ${pkgs.grim}/bin/grim -o "$focused" "$tmp"

      region=$(${pkgs.slurp}/bin/slurp -o "$focused" -b '#ffffff33' -c '#ffffff' -f '%x,%y %wx%h') || exit 1
        IFS=', x' read -r x y w h <<< "$region"
        rel_x=$((x - mon_x))
        rel_y=$((y - mon_y))
        px_x=$(awk -v v="$rel_x" -v s="$scale" 'BEGIN { printf "%.0f", v * s }')
        px_y=$(awk -v v="$rel_y" -v s="$scale" 'BEGIN { printf "%.0f", v * s }')
        px_w=$(awk -v v="$w" -v s="$scale" 'BEGIN { printf "%.0f", v * s }')
        px_h=$(awk -v v="$h" -v s="$scale" 'BEGIN { printf "%.0f", v * s }')
        crop="''${px_w}x''${px_h}+''${px_x}+''${px_y}"

        ${pkgs.imagemagick}/bin/magick "$tmp" -crop "$crop" +repage png:- | \
          ${pkgs.satty}/bin/satty -f - \
            --output-filename "${screenshotDir}/$(date +%Y-%m-%d_%H-%M-%S).png" \
            --copy-command "${pkgs.wl-clipboard}/bin/wl-copy"
    '';

  screenshot-screen =
    pkgs.writeShellScriptBin "screenshot-screen"
    # bash
    ''
      mkdir -p ${screenshotDir}
      focused=$(hyprctl monitors -j | ${pkgs.jq}/bin/jq -r '.[] | select(.focused) | .name')
      ${pkgs.grim}/bin/grim -o "$focused" - | ${pkgs.wl-clipboard}/bin/wl-copy
    '';

  screenshot-screen-annotate =
    pkgs.writeShellScriptBin "screenshot-screen-annotate"
    # bash
    ''
      mkdir -p ${screenshotDir}
      focused=$(hyprctl monitors -j | ${pkgs.jq}/bin/jq -r '.[] | select(.focused) | .name')
      ${pkgs.grim}/bin/grim -o "$focused" - | \
        ${pkgs.satty}/bin/satty -f - \
          --output-filename "${screenshotDir}/$(date +%Y-%m-%d_%H-%M-%S).png" \
          --copy-command "${pkgs.wl-clipboard}/bin/wl-copy"
    '';
in {
  home.packages = [
    screenshot-region
    screenshot-region-annotate
    screenshot-screen
    screenshot-screen-annotate
  ];
}
