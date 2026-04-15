{...}: let
  theme = import ../../themes/_theme-data.nix;
  animationSpeed = theme.animation-speed;

  animationDuration =
    if animationSpeed == "slow"
    then "4"
    else if animationSpeed == "medium"
    then "2.5"
    else if animationSpeed == "fast"
    then "1.5"
    else "0";
  borderDuration =
    if animationSpeed == "slow"
    then "10"
    else if animationSpeed == "medium"
    then "6"
    else if animationSpeed == "fast"
    then "3"
    else "0";
in {
  flake.homeManagerModules.desktop = {...}: {
    wayland.windowManager.hyprland.settings = {
      animations = {
        enabled = animationSpeed != "none";
        bezier = [
          "snap, 0.05, 0.7, 0.1, 1"
          "snappier, 0.16, 1, 0.3, 1"
          "quickOut, 0.3, 0, 0.8, 0.15"
          "smoothOut, 0, 0.55, 0.45, 1"
        ];

        animation = [
          "windowsIn, 1, ${animationDuration}, snappier, popin 20%"
          "windowsOut, 1, ${animationDuration}, quickOut, popin 80%"
          "windowsMove, 1, ${animationDuration}, snap"
          "border, 1, ${borderDuration}, smoothOut"
          "borderangle, 1, ${borderDuration}, smoothOut"
          "fade, 1, ${animationDuration}, snap"
          "fadeIn, 1, ${animationDuration}, snap"
          "fadeOut, 1, ${animationDuration}, quickOut"
          "layersIn, 1, ${animationDuration}, snappier, slide"
          "layersOut, 1, ${animationDuration}, quickOut"
          "workspaces, 1, ${animationDuration}, snap, slide"
          "specialWorkspace, 1, ${animationDuration}, snappier, slidevert"
        ];
      };
    };
  };
}
