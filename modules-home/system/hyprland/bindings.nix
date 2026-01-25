{
  pkgs,
  config,
  ...
}: let
  terminal = config.var.terminal;

  # Shell/Bar selector
  # shellConfig = import ../shell-selector.nix;
  # useNoctalia = shellConfig.shellSystem == "noctalia";
  qsConfig = "${config.home.homeDirectory}/code/ynix/modules-home/system/quickshell";

  # Shell-specific IPC commands - QuickShell only now (Noctalia disabled)
  # QuickShell uses: qs -p <config> ipc call <target> <action>

  # Left sidebar: AI panel
  leftSidebarToggle = "qs -p ${qsConfig} ipc call sidebarLeft toggle";

  # Right sidebar: Control center / Notifications
  rightSidebarToggle = "qs -p ${qsConfig} ipc call sidebarRight toggle";

  # Notifications (same as right sidebar in QuickShell)
  notificationsToggle = "qs -p ${qsConfig} ipc call sidebarRight toggle";

  # Launcher/Search
  launcherToggle = "qs -p ${qsConfig} ipc call search toggle";

  # Clipboard history
  clipboardToggle = "qs -p ${qsConfig} ipc call search clipboardToggle";

  # Bar visibility
  barToggle = "qs -p ${qsConfig} ipc call bar toggle";

  # Session/Power menu
  sessionMenuToggle = "qs -p ${qsConfig} ipc call session toggle";

  # Lock screen
  lockScreen = "qs -p ${qsConfig} ipc call lock activate";

  # Brightness controls
  brightnessIncrease = "qs -p ${qsConfig} ipc call brightness increment";
  brightnessDecrease = "qs -p ${qsConfig} ipc call brightness decrement";

  # Screenshots
  screenshotRegion = "qs -p ${qsConfig} ipc call region screenshot";
  screenshotEdit = "qs -p ${qsConfig} ipc call region screenshotEdit";
  screenshotOCR = "qs -p ${qsConfig} ipc call region ocr";
  screenRecord = "qs -p ${qsConfig} ipc call region recordWithSound";

  # Wallpaper picker
  wallpaperPickerToggle = "qs -p ${qsConfig} ipc call wallpaperSelector toggle";
  wallpaperRandom = "qs -p ${qsConfig} ipc call wallpaperSelector random";
in {
  wayland.windowManager.hyprland.settings = {
    bind = [
      #Basic things
      "$mod, W, exec, walker" # Walker Launcher
      "$shiftMod, SPACE, exec, hyprfocus-toggle" # Toggle HyprFocus
      "CTRL $shiftMod, SPACE, exec, ${lockScreen}" # Lock

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

      # Shell-specific controls
      "$mod, A, exec, ${leftSidebarToggle}" # Left sidebar (AI panel in QS / Settings in Noctalia)
      "$mod, C, exec, ${rightSidebarToggle}" # Right sidebar (Control/Notifications center)
      "$mod, N, exec, ${notificationsToggle}" # Notifications (same as C in QuickShell)
      "$mod, V, exec, ${clipboardToggle}" # Clipboard history (QuickShell only)
      "$mod, SPACE, exec, ${launcherToggle}" # Launcher/Search
      "$mod, SEMICOLON, exec, ${barToggle}" # Toggle bar visibility

      # Screenshots (QuickShell only)
      ",PRINT, exec, ${screenshotRegion}" # Screenshot region
      "SHIFT, PRINT, exec, ${screenshotEdit}" # Screenshot + edit
      "CTRL, PRINT, exec, ${screenshotRegion}" # Screenshot region (alt)
      "CTRL SHIFT, PRINT, exec, ${screenshotOCR}" # OCR from region
      "$mod SHIFT, S, exec, ${screenshotRegion}" # Alt screenshot shortcut

      # Screen Recording (QuickShell only)
      "ALT, PRINT, exec, ${screenRecord}" # Record region with sound

      # Wallpaper picker (QuickShell only)
      "$mod, U, exec, ${wallpaperPickerToggle}" # Toggle wallpaper picker
      "$mod SHIFT, U, exec, ${wallpaperRandom}" # Random wallpaper from current folder

      # Screen rotation
      "$mod, Prior, exec, hyprctl keyword monitor eDP-1,2880x1920@120,auto,1.5,transform,2" # Rotate 180° (PageUp)
      "$mod, Next, exec, hyprctl keyword monitor eDP-1,2880x1920@120,auto,1.5,transform,0" # Rotate back to normal (PageDown)

      # Framework function keys
      ",XF86AudioMedia, exec, ${sessionMenuToggle}" # F12: Power menu

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

      "$mod, TAB, togglespecialworkspace"
      "$shiftMod, TAB, movetoworkspace, special"
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
      ",XF86MonBrightnessUp, exec, ${brightnessIncrease}" # Brightness Up
      ",XF86MonBrightnessDown, exec, ${brightnessDecrease}" # Brightness Down
    ];
  };
}
