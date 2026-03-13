{
  pkgs,
  config,
  ...
}: let
  inherit (config.var) terminal;
in {
  wayland.windowManager.hyprland.settings = {
    bind = [
      #Basic things
      "$mod, SPACE, exec, noctalia-shell ipc call launcher toggle"
      "$shiftMod, SPACE, exec, noctalia-shell ipc call bar toggle"
      "CTRL $shiftMod, SPACE, exec, noctalia-shell ipc call lockScreen lock"

      "$mod, Q, killactive,"
      "$mod, T, togglefloating,"
      "$mod, F, fullscreen"

      # CLI Apps
      "$mod, RETURN, exec, ${terminal}"
      "$mod, G, exec, ${terminal} -e lazygit"
      "$mod, D, exec, ${terminal} -e lazydocker"
      "$mod, I, exec, ${terminal} -e btop"
      "$mod, Y, exec, ${terminal} -e yazi"

      "$mod, H, movefocus, l"
      "$mod, L, movefocus, r"
      "$mod, K, movefocus, u"
      "$mod, J, movefocus, d"

      "$shiftMod, H, movewindow, l"
      "$shiftMod, L, movewindow, r"
      "$shiftMod, K, movewindow, u"
      "$shiftMod, J, movewindow, d"

      "$shiftMod CTRL, h, movecurrentworkspacetomonitor, l"
      "$shiftMod CTRL, l, movecurrentworkspacetomonitor, r"
      "$shiftMod CTRL, k, movecurrentworkspacetomonitor, u"
      "$shiftMod CTRL, j, movecurrentworkspacetomonitor, d"

      "$mod, Escape, exec, noctalia-shell ipc call controlCenter toggle"
      "$mod, Delete, exec, noctalia-shell ipc call sessionMenu toggle"

      "$mod, s, exec, noctalia-shell ipc call settings toggle"
      "$mod, Backspace, exec, noctalia-shell ipc call plugin togglePanel notes-scratchpad "

      "$mod, c, exec, noctalia-shell ipc call plugin:weekly-calendar togglePanel"
      "$mod, v, exec, noctalia-shell ipc call volume togglePanel"
      "$mod, b, exec, noctalia-shell ipc call battery togglePanel"
      "$mod, n, exec, noctalia-shell ipc call notifications toggleHistory"
      "$mod, m, exec, noctalia-shell ipc call media toggle"

      "$mod ALT, b, exec, noctalia-shell ipc call bluetooth togglePanel"
      "$mod ALT, n, exec, noctalia-shell ipc call network togglePanel"

      ",PRINT, exec, hyprshot -m region --freeze --clipboard-only"
      "SHIFT, PRINT, exec, hyprshot -m output --clipboard-only"
      "CTRL, PRINT, exec, hyprshot -m region --freeze --raw | ${pkgs.satty}/bin/satty -f -"
      "CTRL SHIFT, PRINT, exec, hyprshot -m output --raw | ${pkgs.satty}/bin/satty -f -"

      "ALT, PRINT, exec, noctalia-shell ipc call plugin:screen-recorder toggle"

      "$mod, Prior, exec, hyprctl keyword monitor eDP-1,2880x1920@120,auto,1.5,transform,2"
      "$mod, Next, exec, hyprctl keyword monitor eDP-1,2880x1920@120,auto,1.5,transform,0"

      "$mod, 1, workspace, 1"
      "$mod SHIFT, 1, movetoworkspace, 1"
      "$mod, 2, workspace, 2"
      "$mod SHIFT, 2, movetoworkspace, 2"
      "$mod, 3, workspace, 3"
      "$mod SHIFT, 3, movetoworkspace, 3"
      "$mod, 4, workspace, 4"
      "$mod SHIFT, 4, movetoworkspace, 4"
      "$mod, 5, workspace, 5"
      "$mod SHIFT, 5, movetoworkspace, 5"
      "$mod, 6, workspace, 6"
      "$mod SHIFT, 6, movetoworkspace, 6"
      "$mod, 7, workspace, 7"
      "$mod SHIFT, 7, movetoworkspace, 7"
      "$mod, 8, workspace, 8"
      "$mod SHIFT, 8, movetoworkspace, 8"
      "$mod, 9, workspace, 9"
      "$mod SHIFT, 9, movetoworkspace, 9"
      "$mod, 0, workspace, 10"
      "$mod SHIFT, 0, movetoworkspace, 10"

      "$mod, TAB, togglespecialworkspace"
      "$shiftMod, TAB, movetoworkspace, special"
    ];

    binde = [
      "$shiftMod, period, layoutmsg, colresize +0.1"
      "$shiftMod, comma, layoutmsg, colresize -0.1"
    ];

    bindm = [
      "$mod,mouse:272, movewindow"
      "$mod,R, resizewindow"
    ];

    bindl = [
      ",XF86AudioMute, exec, sound-toggle"
      "ALT,XF86AudioMute, exec, mic-toggle"
      ",XF86AudioPlay, exec, ${pkgs.playerctl}/bin/playerctl play-pause"
      ",XF86AudioNext, exec, ${pkgs.playerctl}/bin/playerctl next"
      ",XF86AudioPrev, exec, ${pkgs.playerctl}/bin/playerctl previous"
    ];

    bindle = [
      ",XF86AudioRaiseVolume, exec, sound-up"
      ",XF86AudioLowerVolume, exec, sound-down"
      "ALT,XF86AudioRaiseVolume, exec, mic-up"
      "ALT,XF86AudioLowerVolume, exec, mic-down"
      ",XF86MonBrightnessUp, exec, noctalia-shell ipc call brightness increase"
      ",XF86MonBrightnessDown, exec, noctalia-shell ipc call brightness decrease"
    ];
  };
}
