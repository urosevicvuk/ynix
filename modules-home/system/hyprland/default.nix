# So best window tiling manager
{
  pkgs,
  config,
  inputs,
  lib,
  ...
}: let
  inherit (config.theme) border-size;
  inherit (config.theme) gaps-in;
  inherit (config.theme) gaps-out;
  inherit (config.theme) active-opacity;
  inherit (config.theme) inactive-opacity;
  inherit (config.theme) rounding;
  inherit (config.theme) blur;
  inherit (config.var) keyboardLayout;
  inherit (config.var) keyboardVariant;
  inherit (config.var) device;
  inherit (config.var) monitorScale;
  inherit (config.var) inputSensitivity;
  inherit (config.var) terminal;

  isLaptop = device == "laptop";
in {
  imports = [
    ./animations.nix
    ./bindings.nix
    ./polkitagent.nix
    #./hyprspace.nix
  ];

  home.packages = with pkgs; [
    qt5.qtwayland
    qt6.qtwayland
    libsForQt5.qt5ct
    qt6Packages.qt6ct
    hyprpicker
    # hyprpanel  # Disabled - replaced by illogical-impulse (QuickShell)
    imv
    wlr-randr
    wl-clipboard
    brightnessctl
    gnome-themes-extra
    libva
    dconf
    wayland-utils
    wayland-protocols
    glib
    direnv
    meson
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    systemd = {
      enable = false;
      variables = [
        "--all"
      ]; # https://wiki.hyprland.org/Nix/Hyprland-on-Home-Manager/#programs-dont-work-in-systemd-services-but-do-on-the-terminal
    };
    # Using nixpkgs hyprland for stability instead of git version
    package = pkgs.hyprland;
    portalPackage = null;

    plugins = [
      #pkgs.hyprlandPlugins.hyprscrolling
    ];

    extraConfig = ''
      # Laptop-specific gestures
      ${
        if isLaptop
        then ''
          gesture = 3, horizontal, workspace
        ''
        else ""
      }

      # Window rules - commented out until we find correct syntax for Hyprland 0.52
      # windowrule {
      #     match:tag = modal
      #     float = true
      #     pin = true
      #     center = true
      # }

      # windowrule {
      #     match:title = ^(Media viewer)$
      #     float = true
      # }

      # windowrule {
      #     match:title = ^(.*Bitwarden Password Manager.*)$
      #     float = true
      # }

      # windowrule {
      #     match:class = ^(org.gnome.Calculator)$
      #     float = true
      #     size = 360 490
      # }

      # windowrule {
      #     match:title = ^(Picture-in-Picture)$
      #     float = true
      #     pin = true
      # }

      # windowrule {
      #     match:class = ^(mpv|.+exe|celluloid)$
      #     idleinhibit = focus
      # }

      # windowrule {
      #     match:class = ^(zen)$
      #     match:title = ^(.*YouTube.*)$
      #     idleinhibit = focus
      # }

      # windowrule {
      #     match:class = ^(zen)$
      #     idleinhibit = fullscreen
      # }

      # windowrule {
      #     match:class = ^(gcr-prompter)$
      #     dimaround = true
      # }

      # windowrule {
      #     match:class = ^(xdg-desktop-portal-gtk)$
      #     dimaround = true
      # }

      # windowrule {
      #     match:class = ^(polkit-gnome-authentication-agent-1)$
      #     dimaround = true
      # }

      # windowrule {
      #     match:class = ^(zen)$
      #     match:title = ^(File Upload)$
      #     dimaround = true
      # }

      # windowrule {
      #     match:class = ^(.*jetbrains.*)$
      #     match:title = ^(Confirm Exit|Open Project|win424|win201|splash)$
      #     center = true
      # }

      # windowrule {
      #     match:class = ^(.*jetbrains.*)$
      #     match:title = ^(splash)$
      #     size = 640 400
      # }

      # Layer rules
      # layerrule {
      #     match:namespace = launcher
      #     noanim = true
      # }

      # layerrule {
      #     match:namespace = ^ags-.*
      #     noanim = true
      # }
    '';

    settings = {
      "$mod" = "SUPER";
      "$shiftMod" = "SUPER_SHIFT";

      exec-once = [
        # System services first
        "dbus-update-activation-environment --systemd --all"
        "systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
        "systemctl --user start graphical-session.target"
        "systemctl --user start hyprpolkitagent"

        # System tools
        "systemctl --user enable --now hyprpaper.service"
        "systemctl --user enable --now hypridle.service"
        "systemctl --user enable --now nextcloud-client.service"
        "systemctl --user enable --now elephant.service"
        "systemctl --user enable --now walker.service"
        "${pkgs.tailscale-systray}/bin/tailscale-systray"

        # Panel and utilities
        "qs -c $qsConfig &" # QuickShell (end-4 bar)
        "wl-paste --type text --watch cliphist store &"
        "wl-paste --type image --watch cliphist store &"

        # Workspace initialization - force create workspaces on correct monitors
        #"hyprctl dispatch focusmonitor DP-3"
        #"hyprctl dispatch workspace name:alternative1"
        #"hyprctl dispatch workspace name:alternative2"
        #"hyprctl dispatch workspace name:alternative1"
        #"hyprctl dispatch focusmonitor DP-2"
        #"hyprctl dispatch workspace 1"

        # Applications with workspace assignments
        "[workspace 1 silent] zen"
        "[workspace 4 silent] ${terminal}"
        "[workspace 5 silent] spotify"
        "[workspace 9 silent] discord"
        "[workspace 10 silent] obsidian"
        "kdeconnect-indicator"
        "localsend_app"
      ];

      monitor =
        if isLaptop
        then [
          "eDP-1,2880x1920@120,0x0,${monitorScale}"
          "DP-2,1920x1080@144,0x-1080,1"
          ",preferred,auto,1"
        ]
        else [
          "DP-2, 1920x1080@144, 0x0, 1"
          "DP-3, prefered, auto, 1, transform, 1"
          "HDMI-A-1, prefered, auto, 1, mirror, DP-2"
          ",prefered,auto,1"
        ];

      env = [
        "XDG_CURRENT_DESKTOP,Hyprland"
        "MOZ_ENABLE_WAYLAND,1"
        "ANKI_WAYLAND,1"
        "DISABLE_QT5_COMPAT,0"
        "NIXOS_OZONE_WL,1"
        "XDG_SESSION_TYPE,wayland"
        "XDG_SESSION_DESKTOP,Hyprland"
        "QT_AUTO_SCREEN_SCALE_FACTOR,1"
        "QT_QPA_PLATFORM=wayland,xcb"
        "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
        "ELECTRON_OZONE_PLATFORM_HINT,auto"
        "__GL_GSYNC_ALLOWED,0"
        "__GL_VRR_ALLOWED,0"
        "DISABLE_QT5_COMPAT,0"
        "DIRENV_LOG_FORMAT,"
        "WLR_DRM_NO_ATOMIC,0"
        "WLR_BACKEND,vulkan"
        "WLR_RENDERER,vulkan"
        "WLR_NO_HARDWARE_CURSORS,1"
        "SDL_VIDEODRIVER,wayland,x11,windows"
        "CLUTTER_BACKEND,wayland"
        "GDK_BACKEND,wayland"
        "GDK_SCALE,${monitorScale}"
      ];

      cursor = {
        no_hardware_cursors = true;
        default_monitor = "DP-2";
      };

      general = {
        resize_on_border = true;
        gaps_in = gaps-in;
        gaps_out = gaps-out;
        border_size = border-size;
        layout = "dwindle";
      };

      #"plugin:hyprscrolling" = {
      #  fullscreen_on_one_column = true;
      #  column_width = 0.499;
      #  focus_fit_method = 0;
      #};

      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };

      decoration = {
        active_opacity = active-opacity;
        inactive_opacity = inactive-opacity;
        rounding = rounding;
        shadow = {
          enabled = true;
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

      # Gestures configured via extraConfig below

      misc = {
        vfr = true;
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
        disable_autoreload = true;
        focus_on_activate = true;
        #new_window_takes_over_fullscreen = 2;
      };

      xwayland = {
        force_zero_scaling = true;
      };

      # windowrule and layerrule are now in extraConfig using block syntax

      workspace =
        if isLaptop
        then [
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
          "11, monitor:DP-3, persistent:true"
          "name:special, persistent:true"
        ]
        else [
          "special:special, monitor:DP-2"
          "1, monitor:DP-2, default:true"
          "2, monitor:DP-2, persistent:true"
          "3, monitor:DP-2, persistent:true"
          "4, monitor:DP-2, persistent:true"
          "5, monitor:DP-2, persistent:true"
          "6, monitor:DP-2, persistent:true"
          "7, monitor:DP-2, persistent:true"
          "8, monitor:DP-2, persistent:true"
          "9, monitor:DP-2, persistent:true"
          "10, monitor:DP-2, persistent:true"
          "name:alternative1, monitor:DP-3, default:true, persistent:true, layoutopt:orientation:top"
          "name:alternative2, monitor:DP-3, persistent:true, layoutopt:orientation:top"
        ];

      input = {
        kb_layout = keyboardLayout;
        kb_variant = keyboardVariant;

        kb_options = "grp:alt_space_toggle";
        follow_mouse = 1;
        sensitivity = inputSensitivity;
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
    };
  };
}
