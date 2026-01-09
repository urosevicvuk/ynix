{
  pkgs,
  config,
  ...
}: let
  terminal = config.var.terminal;
in {
  wayland.windowManager.hyprland.settings = {
    bind = [
      #Basic things
      "$mod, SPACE, exec, walker" # Walker Launcher
      "$shiftMod, SPACE, exec, hyprfocus-toggle" # Toggle HyprFocus
      "CTRL $shiftMod, SPACE, exec, hyprlock" # Lock

      "$mod, Q, killactive," # Close window
      "$mod, T, togglefloating," # Toggle Floating
      "$mod, F, fullscreen" # Toggle Fullscreen

      "$mod, grave, exec, quickmenu" # Quickmenu

      # GUI Apps
      "$mod, B, exec, zen" # Zen Browser
      "$mod, E, exec, ${pkgs.xfce.thunar}/bin/thunar" # Thunar
      "$mod, P, exec, ${pkgs.bitwarden-desktop}/bin/bitwarden" # Bitwarden

      # CLI Apps
      "$mod, RETURN, exec, ${terminal}" # Terminal
      "$mod, G, exec, ${terminal} -e lazygit"
      "$mod, D, exec, ${terminal} -e lazydocker"
      "$mod, I, exec, ${terminal} -e btop"
      "$mod, Y, exec, ${terminal} -e yazi"

      #"$mod, C, layoutmsg, togglefit" # Toggle Hyprscrolling fit method

      # Hyprscrolling layout: move focus - custom layoutmsg for moving focus to edge columns
      "$mod, H, movefocus, l" # Move focus left
      "$mod, L, movefocus, r" # Move focus Right
      "$mod, K, movefocus, u" # Move focus Up
      "$mod, J, movefocus, d" # Move focus Down

      # Hyprscrolling layout: move windows - custom layoutmsg for moving windows to edge columns
      "$shiftMod, H, movewindow, l" # Move window left
      "$shiftMod, L, movewindow, r" # Move window right
      "$shiftMod, K, movewindow, u" # Move window up
      "$shiftMod, J, movewindow, d" # Move window down

      # Move current workspace to different monitor
      "$shiftMod CTRL, h, movecurrentworkspacetomonitor, l" # Move workspace to left monitor
      "$shiftMod CTRL, l, movecurrentworkspacetomonitor, r" # Move workspace to right monitor
      "$shiftMod CTRL, k, movecurrentworkspacetomonitor, u" # Move workspace to upper monitor
      "$shiftMod CTRL, j, movecurrentworkspacetomonitor, d" # Move workspace to lower monitor

      # Screenshots (QuickShell region selector)
      ",PRINT, exec, qs -i ipc call region screenshot" # Screenshot (QuickShell UI)
      "SHIFT, PRINT, exec, qs -i ipc call region screenshotEdit" # Screenshot + edit (satty)
      "CTRL, PRINT, exec, qs -i ipc call region screenshot" # Screenshot region
      "CTRL SHIFT, PRINT, exec, qs -i ipc call region ocr" # OCR from region
      "$mod SHIFT, S, exec, qs -i ipc call region screenshot" # Alt screenshot shortcut

      # Screen Recording (keep gpu-screen-recorder)
      "ALT, PRINT, exec, record-monitor" # Record current monitor (start/stop)
      "CTRL ALT, PRINT, exec, record-region" # Record region (start/stop)

      # QuickShell controls
      "$mod, SEMICOLON, exec, qs -i ipc call bar toggle" # Toggle bar visibility
      "$mod, V, exec, cliphist list | fuzzel --dmenu | cliphist decode | wl-copy" # Clipboard history
      "$mod, N, exec, qs -i ipc call sidebarRight toggle" # Right sidebar (notifications)
      "$mod, O, exec, qs -i ipc call overview toggle" # Overview/workspace switcher

      # Screen rotation
      "$mod, Prior, exec, hyprctl keyword monitor eDP-1,2880x1920@120,auto,1.5,transform,2" # Rotate 180° (PageUp)
      "$mod, Next, exec, hyprctl keyword monitor eDP-1,2880x1920@120,auto,1.5,transform,0" # Rotate back to normal (PageDown)

      # Framework function keys
      "ALT, P, exec, qs -i ipc call idleInhibitor toggle" # F9: Toggle idle inhibitor
      ",XF86AudioMedia, exec, qs -i ipc call sessionScreen toggle" # F12: Power menu (QuickShell)
      "$mod SHIFT, L, exec, qs -i ipc call lockScreen lock" # Lock screen

      #Workspaces
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

      "$mod, backspace, workspace, 11"
      "$mod SHIFT, backspace, movetoworkspace, 11"

      "$mod, TAB, togglespecialworkspace"
      "$shiftMod, TAB, movetoworkspace, special"

      #"$mod, minus, workspace, name:alternative1"
      #"$mod SHIFT, minus, movetoworkspace, name:alternative1"
      #"$mod, equal, workspace, name:alternative2"
      #"$mod SHIFT, equal, movetoworkspace, name:alternative2"
    ];

    binde = [
      "$shiftMod, period, layoutmsg, colresize +0.1" # Resize window smaller horizontally
      "$shiftMod, comma, layoutmsg, colresize -0.1" # Resize window larger horizontally
    ];

    bindm = [
      "$mod,mouse:272, movewindow" # Move Window (mouse)
      "$mod,R, resizewindow" # Resize Window (mouse)
    ];

    bindl = [
      ",XF86AudioMute, exec, sound-toggle" # Toggle Mute
      "ALT,XF86AudioMute, exec, mic-toggle" # Toggle Mic Mute
      ",XF86AudioPlay, exec, ${pkgs.playerctl}/bin/playerctl play-pause" # Play/Pause Song
      ",XF86AudioNext, exec, ${pkgs.playerctl}/bin/playerctl next" # Next Song
      ",XF86AudioPrev, exec, ${pkgs.playerctl}/bin/playerctl previous" # Previous Song
    ];

    bindle = [
      ",XF86AudioRaiseVolume, exec, sound-up" # Sound Up
      ",XF86AudioLowerVolume, exec, sound-down" # Sound Down
      "ALT,XF86AudioRaiseVolume, exec, mic-up" # Mic Volume Up
      "ALT,XF86AudioLowerVolume, exec, mic-down" # Mic Volume Down
      ",XF86MonBrightnessUp, exec, qs -i ipc call brightness increment" # Brightness Up (QuickShell)
      ",XF86MonBrightnessDown, exec, qs -i ipc call brightness decrement" # Brightness Down (QuickShell)
      "ALT,XF86MonBrightnessUp, exec, qs -i ipc call nightLight toggle" # Night Light toggle
      "ALT,XF86MonBrightnessDown, exec, qs -i ipc call nightLight toggle" # Night Light toggle
    ];
  };
}
