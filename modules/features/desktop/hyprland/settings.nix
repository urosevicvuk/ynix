{...}: {
  flake.homeModules.hyprland = {
    pkgs,
    themeData,
    ...
  }: let
    inherit (themeData) border-size gaps-in gaps-out active-opacity inactive-opacity rounding blur;
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
      hyprshot
      hyprpolkitagent
    ];

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
        "$shiftMod" = "SUPER_SHIFT";

        exec-once = [
          "systemctl --user start hyprpolkitagent"
          "systemctl --user enable --now hypridle.service"
          "${pkgs.tailscale-systray}/bin/tailscale-systray"
          "noctalia-shell"
          "opencloud-desktop"

          "[workspace 1 silent] zen"
          "[workspace 4 silent] kitty"
          "[workspace 5 silent] spotify"
          "[workspace 9 silent] discord"
          "[workspace 10 silent] obsidian"
          "kdeconnect-indicator"
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
          layout = "dwindle";
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
          vrr = 1;
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
          kb_options = "grp:alt_space_toggle";
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
      };
    };
  };
}
