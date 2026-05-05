{
  self,
  inputs,
  ...
}: {
  flake.nixosModules.hyprland = {pkgs, ...}: {
    home-manager.sharedModules = [self.homeModules.hyprland];

    programs.hyprland = {
      enable = true;
      withUWSM = true;
      package = pkgs.hyprland;
      portalPackage = pkgs.xdg-desktop-portal-hyprland;
    };

    environment.systemPackages = with pkgs; [
      hyprland-qtutils
    ];
  };

  flake.homeModules.hyprland = {
    pkgs,
    lib,
    config,
    ...
  }: let
    theme = config.theme.active;
    inherit
      (theme)
      border-size
      gaps-in
      gaps-out
      active-opacity
      inactive-opacity
      rounding
      blur
      ;

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
    home.packages = with pkgs; [
      qt5.qtwayland
      qt6.qtwayland
      libsForQt5.qt5ct
      qt6Packages.qt6ct
      hyprpicker
      imv
      wlr-randr
      wl-clipboard
      brightnessctl
      gnome-themes-extra
      libva
      dconf
      wayland-utils
      glib
      hyprpolkitagent
    ];

    programs.hyprshot = {
      enable = true;
      saveLocation = "${config.home.homeDirectory}/Pictures/hyprshot";
    };

    wayland.windowManager.hyprland = {
      enable = true;
      xwayland.enable = true;
      systemd = {
        enable = true;
        variables = ["--all"];
      };
      package = pkgs.hyprland;
      portalPackage = null;

      settings = {
        "$mod" = "SUPER";

        exec-once = [
          "systemctl --user start hyprpolkitagent"
          "${pkgs.tailscale-systray}/bin/tailscale-systray"
          "noctalia-shell"

          "[workspace 1 silent] ${lib.getExe inputs.zen-browser.packages.${pkgs.system}.default}"
          "[workspace 4 silent] kitty -e tmux a"
          "[workspace 5 silent] spotify"
          "[workspace 9 silent] discord"
          "[workspace 10 silent] obsidian"
          "kdeconnect-indicator"
          "bitwarden"
        ];

        monitor = [];

        env = [
          "XDG_CURRENT_DESKTOP,Hyprland"
          "XDG_SESSION_TYPE,wayland"
          "XDG_SESSION_DESKTOP,Hyprland"
          "MOZ_ENABLE_WAYLAND,1"
          "MOZ_DISABLE_RDD_SANDBOX,1"
          "LIBVA_DRIVER_NAME,radeonsi"
          "ANKI_WAYLAND,1"
          "NIXOS_OZONE_WL,1"
          "QT_AUTO_SCREEN_SCALE_FACTOR,1"
          "QT_QPA_PLATFORM=wayland,xcb"
          "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
          "DISABLE_QT5_COMPAT,0"
          "ELECTRON_OZONE_PLATFORM_HINT,auto"
          "SDL_VIDEODRIVER,wayland,x11,windows"
          "CLUTTER_BACKEND,wayland"
          "GDK_BACKEND,wayland"
          "DIRENV_LOG_FORMAT,"
        ];

        cursor = {
          no_hardware_cursors = false;
        };

        general = {
          resize_on_border = true;
          gaps_in = gaps-in;
          gaps_out = gaps-out;
          border_size = border-size;
          layout = "scrolling";
        };

        dwindle = {
          pseudotile = true;
          preserve_split = true;
        };

        decoration = {
          active_opacity = active-opacity;
          inactive_opacity = inactive-opacity;
          rounding = rounding;
          shadow = {
            enabled = false;
            range = 20;
            render_power = 3;
          };
          blur = {
            enabled =
              if blur
              then "true"
              else "false";
            size = 18;
          };
        };

        binds.hide_special_on_workspace_change = true;

        misc = {
          vfr = true;
          vrr = 2;
          disable_hyprland_logo = true;
          disable_splash_rendering = true;
          disable_autoreload = true;
          focus_on_activate = true;
        };

        xwayland.force_zero_scaling = true;

        workspace = [
          "1, default:true, persistent:true"
          "2, persistent:true"
          "3, persistent:true"
          "4, persistent:true"
          "5, persistent:true"
          "6, persistent:true"
          "7, persistent:true"
          "8, persistent:true"
          "9, persistent:true"
          "10, persistent:true"
        ];

        input = {
          kb_layout = "us,rs,rs";
          kb_variant = ",latinyz,yz";
          kb_options = "grp:alt_space_toggle,lv3:ralt_alt";
          follow_mouse = 1;
          accel_profile = "flat";
          repeat_delay = 300;
          repeat_rate = 50;
          numlock_by_default = true;

          touchpad = {
            natural_scroll = true;
            clickfinger_behavior = true;
            scroll_factor = 0.1;
            disable_while_typing = true;
            tap-to-click = true;
            tap-and-drag = true;
          };
        };

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
  };
}
