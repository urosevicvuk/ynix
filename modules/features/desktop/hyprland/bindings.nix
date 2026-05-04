{inputs, ...}: {
  flake.homeModules.hyprland = {
    pkgs,
    lib,
    ...
  }: let
    noct = "noctalia-shell ipc call ";

    launcher = noct + "launcher toggle";
    clipboard = noct + "launcher clipboard";
    bar = noct + "bar toggle";
    controlCenter = noct + "controlCenter toggle";
    sessionMenu = noct + "sessionMenu toggle";
    settings = noct + "settings toggle";

    # Volume
    outputUp = noct + "volume increase";
    outputDown = noct + "volume decrease";
    outputMute = noct + "volume muteOutput";
    inputUp = noct + "volume increaseInput";
    inputDown = noct + "volume decreaseInput";
    inputMute = noct + "volume muteInput";

    # Brightness
    brightnessUp = noct + "brightness increase";
    brightnessDown = noct + "brightness decrease";

    # Media
    playPause = noct + "media playPause";
    next = noct + "media next";
    previous = noct + "media previous";

    mediaPanel = noct + "media toggle";
    calendar = noct + "plugin:weekly-calendar togglePanel";
    caffeine = noct + "idleInhibitor toggle";
    volumePanel = noct + "volume togglePanel";
    volumeApp = terminal + " -e wiremix";
    bluetoothPanel = noct + "bluetooth togglePanel";
    bluetoothApp = terminal + " -e bluetuith";
    networkPanel = noct + "network togglePanel";
    networkApp = terminal + " -e nmtui";
    tailscalePanel = noct + "plugin:tailscale togglePanel";
    batteryPanel = noct + "battery togglePanel";
    notificationsPanel = noct + "notifications toggleHistory";
    mute = noct + "notifications toggleDND";

    zen = lib.getExe inputs.zen-browser.packages.${pkgs.system}.default;
    helium = lib.getExe inputs.helium-browser.packages.${pkgs.system}.default;

    terminal = "kitty";
  in {
    wayland.windowManager.hyprland.settings = {
      bind = [
        #Mental model for keybinds is this:
        #mod + key = OS/DE action
        #mod + SHIFT + key = OS/DE action
        #mod + CTRL + key = toggle shit on/off
        #mod + ALT + key = launch apps
        #mod + SHIFT + CTRL + key = action
        #mod + SHIFT + ALT + key = action

        "$mod, SPACE, exec, ${launcher}"
        "$mod SHIFT, SPACE, exec, ${clipboard}"
        "$mod CTRL, SPACE, exec, ${bar}"
        "$mod, Delete, exec, ${sessionMenu}"

        "$mod, Q, killactive,"
        "$mod, W, togglefloating,"
        "$mod, E, fullscreen"

        #TODO this should be mod + ALT but i can't because of hardware limitations...
        "$mod, RETURN, exec, ${terminal}"
        "$mod CTRL, D, exec, ${terminal} -e lazydocker"
        "$mod CTRL, G, exec, ${terminal} -e gh-dash"
        "$mod CTRL, I, exec, ${terminal} -e btop"
        "$mod CTRL, Y, exec, ${terminal} -e yazi"
        "$mod CTRL, V, exec, ${volumeApp}"
        "$mod CTRL, B, exec, ${bluetoothApp}"
        "$mod CTRL, N, exec, ${networkApp}"
        "$mod CTRL, H, exec, ${helium}"
        "$mod CTRL, Z, exec, ${zen}"

        "$mod, H, movefocus, l"
        "$mod, L, movefocus, r"
        "$mod, K, movefocus, u"
        "$mod, J, movefocus, d"

        "$mod SHIFT, H, movewindow, l"
        "$mod SHIFT, L, movewindow, r"
        "$mod SHIFT, K, movewindow, u"
        "$mod SHIFT, J, movewindow, d"

        "$mod SHIFT CTRL, h, movecurrentworkspacetomonitor, l"
        "$mod SHIFT CTRL, l, movecurrentworkspacetomonitor, r"
        "$mod SHIFT CTRL, k, movecurrentworkspacetomonitor, u"
        "$mod SHIFT CTRL, j, movecurrentworkspacetomonitor, d"

        "$mod, T, exec, ${tailscalePanel}"
        "$mod, X, exec, ${controlCenter}"
        "$mod, C, exec, ${calendar}"
        "$mod, V, exec, ${volumePanel}"
        "$mod, B, exec, ${bluetoothPanel}" #TOGGLE
        "$mod, N, exec, ${networkPanel}" #TOGGLE
        "$mod, M, exec, ${mediaPanel}"
        "$mod SHIFT, C, exec, ${caffeine}"
        "$mod SHIFT, B, exec, ${batteryPanel}"
        "$mod SHIFT, N, exec, ${notificationsPanel}" #TOGGLE
        "$mod SHIFT, M, exec, ${mute}"

        #TODO change this to the f12 key (the cog/gear icon)
        "$mod, s, exec, ${settings}"

        ",PRINT, exec, hyprshot -m region --freeze --clipboard-only"
        "SHIFT, PRINT, exec, hyprshot -m output --clipboard-only"
        "CTRL, PRINT, exec, hyprshot -m region --freeze --raw | ${pkgs.satty}/bin/satty -f -"
        "CTRL SHIFT, PRINT, exec, hyprshot -m output --raw | ${pkgs.satty}/bin/satty -f -"

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

        "$mod, grave, togglespecialworkspace, my_server"
        "$mod SHIFT, grave, movetoworkspace, special:my_server"
      ];

      binde = [
        "$mod SHIFT, period, layoutmsg, colresize +0.1"
        "$mod SHIFT, comma, layoutmsg, colresize -0.1"
      ];

      bindm = [
        "$mod,mouse:272, movewindow"
        "$mod,R, resizewindow"
      ];

      bindl = [
        ",XF86AudioMute, exec, ${outputMute}"
        "ALT,XF86AudioMute, exec, ${inputMute}"
        ",XF86AudioPlay, exec, ${playPause}"
        ",XF86AudioNext, exec, ${next}"
        ",XF86AudioPrev, exec, ${previous}"
      ];

      bindle = [
        ",XF86AudioRaiseVolume, exec, ${outputUp}"
        ",XF86AudioLowerVolume, exec, ${outputDown}"
        "ALT,XF86AudioRaiseVolume, exec, ${inputUp}"
        "ALT,XF86AudioLowerVolume, exec, ${inputDown}"
        ",XF86MonBrightnessUp, exec, ${brightnessUp}"
        ",XF86MonBrightnessDown, exec, ${brightnessDown}"
      ];
    };
  };
}
