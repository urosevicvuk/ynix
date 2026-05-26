{
  self,
  inputs,
  ...
}: {
  flake.nixosModules.niri = {pkgs, ...}: {
    imports = [inputs.niri.nixosModules.niri];

    home-manager.sharedModules = [self.homeModules.niri];

    programs.niri.enable = true;

    # polkit-kde-agent crashes when rendering dialogs on niri (KCrash / SIGSEGV).
    # Use hyprpolkitagent instead — started via spawn-at-startup in the home module below.
    systemd.user.services.niri-flake-polkit.enable = false;

    environment.systemPackages = with pkgs; [
      xwayland-satellite
    ];
  };

  flake.homeModules.niri = {
    pkgs,
    lib,
    config,
    ...
  }: let
    theme = config.theme.active;
    inherit
      (theme)
      border-size
      gaps-out
      active-opacity
      inactive-opacity
      rounding
      ;

    animationSpeed = theme.animation-speed;
    animationsDisabled = animationSpeed == "none";

    noct = "noctalia-shell ipc call";

    launcher = "${noct} launcher toggle";
    clipboard = "${noct} launcher clipboard";
    bar = "${noct} bar toggle";
    controlCenter = "${noct} controlCenter toggle";
    sessionMenu = "${noct} sessionMenu toggle";
    settings = "${noct} settings toggle";

    outputUp = "${noct} volume increase";
    outputDown = "${noct} volume decrease";
    outputMute = "${noct} volume muteOutput";
    inputUp = "${noct} volume increaseInput";
    inputDown = "${noct} volume decreaseInput";
    inputMute = "${noct} volume muteInput";

    brightnessUp = "${noct} brightness increase";
    brightnessDown = "${noct} brightness decrease";

    playPause = "${noct} media playPause";
    next = "${noct} media next";
    previous = "${noct} media previous";

    mediaPanel = "${noct} media toggle";
    calendar = "${noct} plugin:weekly-calendar togglePanel";
    caffeine = "${noct} idleInhibitor toggle";
    volumePanel = "${noct} volume togglePanel";
    bluetoothPanel = "${noct} bluetooth togglePanel";
    networkPanel = "${noct} network togglePanel";
    tailscalePanel = "${noct} plugin:tailscale togglePanel";
    batteryPanel = "${noct} battery togglePanel";
    notificationsPanel = "${noct} notifications toggleHistory";
    mute = "${noct} notifications toggleDND";

    zen = lib.getExe inputs.zen-browser.packages.${pkgs.system}.default;
    helium = lib.getExe inputs.helium-browser.packages.${pkgs.system}.default;

    terminal = "kitty";
  in {
    home.packages = with pkgs; [
      qt5.qtwayland
      qt6.qtwayland
      libsForQt5.qt5ct
      qt6Packages.qt6ct
      imv
      wlr-randr
      wl-clipboard
      brightnessctl
      libva
      dconf
      wayland-utils
      glib
      polkit_gnome
      satty
    ];

    programs.niri.settings = with config.lib.niri.actions; {
      prefer-no-csd = true;

      hotkey-overlay.skip-at-startup = true;

      screenshot-path = "~/Pictures/Screenshots/Screenshot-%Y-%m-%d_%H-%M-%S.png";

      environment = {
        MOZ_ENABLE_WAYLAND = "1";
        LIBVA_DRIVER_NAME = "radeonsi";
        ANKI_WAYLAND = "1";
        NIXOS_OZONE_WL = "1";
        QT_AUTO_SCREEN_SCALE_FACTOR = "1";
        QT_QPA_PLATFORM = "wayland;xcb";
        QT_QPA_PLATFORMTHEME = "qt6ct";
        QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
        DISABLE_QT5_COMPAT = "0";
        ELECTRON_OZONE_PLATFORM_HINT = "auto";
        SDL_VIDEODRIVER = "wayland";
        CLUTTER_BACKEND = "wayland";
        DIRENV_LOG_FORMAT = null;
      };

      spawn-at-startup = [
        {command = ["xwayland-satellite"];}
        {command = ["${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"];}
        {command = ["noctalia-shell"];}
        {command = ["${pkgs.tailscale-systray}/bin/tailscale-systray"];}
        {command = ["kdeconnect-indicator"];}
        {command = ["bitwarden"];}
        {command = [zen];}
        {command = ["kitty" "-e" "tmux" "a"];}
        {command = ["spotify"];}
        {command = ["discord"];}
        {command = ["obsidian"];}
      ];

      cursor = {
        hide-when-typing = true;
      };

      layout = {
        gaps = gaps-out;
        border = {
          enable = true;
          width = border-size;
        };
        focus-ring.enable = false;
        default-column-width.proportion = 0.5;
        preset-column-widths = [
          {proportion = 0.33333;}
          {proportion = 0.5;}
          {proportion = 0.66667;}
          {proportion = 1.0;}
        ];
        always-center-single-column = true;
        center-focused-column = "always";
      };

      input = {
        keyboard = {
          xkb = {
            layout = "us,rs,rs";
            variant = ",latinyz,yz";
            options = "grp:alt_space_toggle,lv3:ralt_alt";
          };
          numlock = true;
          repeat-delay = 300;
          repeat-rate = 50;
        };

        touchpad = {
          tap = true;
          dwt = true;
          natural-scroll = true;
          click-method = "clickfinger";
          accel-profile = "flat";
          scroll-factor = 0.1;
        };

        mouse = {
          accel-profile = "flat";
        };

        focus-follows-mouse.enable = true;
        warp-mouse-to-focus.enable = false;
      };

      animations = {
        enable = !animationsDisabled;
      };

      workspaces = {
        "01" = {name = "1";};
        "02" = {name = "2";};
        "03" = {name = "3";};
        "04" = {name = "4";};
        "05" = {name = "5";};
        "06" = {name = "6";};
        "07" = {name = "7";};
        "08" = {name = "8";};
        "09" = {name = "9";};
        "10" = {name = "10";};
      };

      window-rules = [
        {
          geometry-corner-radius = {
            top-left = rounding * 1.0;
            top-right = rounding * 1.0;
            bottom-left = rounding * 1.0;
            bottom-right = rounding * 1.0;
          };
          clip-to-geometry = true;
          opacity = active-opacity * 1.0;
        }
        {
          matches = [{is-focused = false;}];
          opacity = inactive-opacity * 1.0;
        }

        {
          matches = [
            {
              app-id = "^zen";
              at-startup = true;
            }
          ];
          open-on-workspace = "1";
        }
        {
          matches = [
            {
              app-id = "^kitty$";
              at-startup = true;
            }
          ];
          open-on-workspace = "2";
        }
        {
          matches = [{app-id = "^spotify$";}];
          open-on-workspace = "3";
        }
        {
          matches = [{app-id = "discord";}];
          open-on-workspace = "9";
        }
        {
          matches = [{app-id = "obsidian";}];
          open-on-workspace = "10";
        }
      ];

      binds = {
        # mod + key = OS/DE action
        # mod + SHIFT + key = action
        # mod + CTRL + key = toggle shit on/off
        # mod + ALT + key = launch apps

        "Mod+Space".action = spawn "sh" "-c" launcher;
        "Mod+Shift+Space".action = spawn "sh" "-c" clipboard;
        "Mod+Ctrl+Space".action = spawn "sh" "-c" bar;
        "Mod+Delete".action = spawn "sh" "-c" sessionMenu;

        "Mod+Q".action = close-window;
        "Mod+W".action = toggle-window-floating;
        "Mod+E".action = maximize-column;
        "Mod+F".action = fullscreen-window;

        "Mod+Return".action = spawn terminal;
        "Mod+Ctrl+D".action = spawn terminal "-e" "lazydocker";
        "Mod+Ctrl+G".action = spawn terminal "-e" "gh-dash";
        "Mod+Ctrl+I".action = spawn terminal "-e" "btop";
        "Mod+Ctrl+Y".action = spawn terminal "-e" "yazi";
        "Mod+Ctrl+V".action = spawn terminal "-e" "wiremix";
        "Mod+Ctrl+B".action = spawn terminal "-e" "bluetuith";
        "Mod+Ctrl+N".action = spawn terminal "-e" "nmtui";
        "Mod+Ctrl+H".action = spawn helium;
        "Mod+Ctrl+Z".action = spawn zen;

        "Mod+H".action = focus-column-left;
        "Mod+L".action = focus-column-right;
        "Mod+K".action = focus-window-up;
        "Mod+J".action = focus-window-down;

        "Mod+Shift+H".action = move-column-left;
        "Mod+Shift+L".action = move-column-right;
        "Mod+Shift+K".action = move-window-up;
        "Mod+Shift+J".action = move-window-down;

        "Mod+Shift+Ctrl+H".action = move-workspace-to-monitor-left;
        "Mod+Shift+Ctrl+L".action = move-workspace-to-monitor-right;
        "Mod+Shift+Ctrl+K".action = move-workspace-to-monitor-up;
        "Mod+Shift+Ctrl+J".action = move-workspace-to-monitor-down;

        "Mod+T".action = spawn "sh" "-c" tailscalePanel;
        "Mod+X".action = spawn "sh" "-c" controlCenter;
        "Mod+C".action = spawn "sh" "-c" calendar;
        "Mod+V".action = spawn "sh" "-c" volumePanel;
        "Mod+B".action = spawn "sh" "-c" bluetoothPanel;
        "Mod+N".action = spawn "sh" "-c" networkPanel;
        "Mod+M".action = spawn "sh" "-c" mediaPanel;
        "Mod+Shift+C".action = spawn "sh" "-c" caffeine;
        "Mod+Shift+B".action = spawn "sh" "-c" batteryPanel;
        "Mod+Shift+N".action = spawn "sh" "-c" notificationsPanel;
        "Mod+Shift+M".action = spawn "sh" "-c" mute;

        "Mod+S".action = spawn "sh" "-c" settings;

        "Print".action.screenshot = {};
        "Shift+Print".action.screenshot-screen = {};
        "Ctrl+Print".action = spawn "sh" "-c" "grim -g \"$(slurp)\" - | satty -f -";
        "Ctrl+Shift+Print".action = spawn "sh" "-c" "grim - | satty -f -";

        "Mod+1".action = focus-workspace "1";
        "Mod+Shift+1".action.move-column-to-workspace = "1";
        "Mod+2".action = focus-workspace "2";
        "Mod+Shift+2".action.move-column-to-workspace = "2";
        "Mod+3".action = focus-workspace "3";
        "Mod+Shift+3".action.move-column-to-workspace = "3";
        "Mod+4".action = focus-workspace "4";
        "Mod+Shift+4".action.move-column-to-workspace = "4";
        "Mod+5".action = focus-workspace "5";
        "Mod+Shift+5".action.move-column-to-workspace = "5";
        "Mod+6".action = focus-workspace "6";
        "Mod+Shift+6".action.move-column-to-workspace = "6";
        "Mod+7".action = focus-workspace "7";
        "Mod+Shift+7".action.move-column-to-workspace = "7";
        "Mod+8".action = focus-workspace "8";
        "Mod+Shift+8".action.move-column-to-workspace = "8";
        "Mod+9".action = focus-workspace "9";
        "Mod+Shift+9".action.move-column-to-workspace = "9";
        "Mod+0".action = focus-workspace "10";
        "Mod+Shift+0".action.move-column-to-workspace = "10";

        "Mod+Tab".action = toggle-overview;

        "Mod+Shift+period" = {
          action = set-column-width "+10%";
          repeat = true;
        };
        "Mod+Shift+comma" = {
          action = set-column-width "-10%";
          repeat = true;
        };

        "XF86AudioMute" = {
          action = spawn "sh" "-c" outputMute;
          allow-when-locked = true;
        };
        "Alt+XF86AudioMute" = {
          action = spawn "sh" "-c" inputMute;
          allow-when-locked = true;
        };
        "XF86AudioPlay" = {
          action = spawn "sh" "-c" playPause;
          allow-when-locked = true;
        };
        "XF86AudioNext" = {
          action = spawn "sh" "-c" next;
          allow-when-locked = true;
        };
        "XF86AudioPrev" = {
          action = spawn "sh" "-c" previous;
          allow-when-locked = true;
        };

        "XF86AudioRaiseVolume" = {
          action = spawn "sh" "-c" outputUp;
          allow-when-locked = true;
        };
        "XF86AudioLowerVolume" = {
          action = spawn "sh" "-c" outputDown;
          allow-when-locked = true;
        };
        "Alt+XF86AudioRaiseVolume" = {
          action = spawn "sh" "-c" inputUp;
          allow-when-locked = true;
        };
        "Alt+XF86AudioLowerVolume" = {
          action = spawn "sh" "-c" inputDown;
          allow-when-locked = true;
        };
        "XF86MonBrightnessUp" = {
          action = spawn "sh" "-c" brightnessUp;
          allow-when-locked = true;
        };
        "XF86MonBrightnessDown" = {
          action = spawn "sh" "-c" brightnessDown;
          allow-when-locked = true;
        };
      };
    };
  };
}
