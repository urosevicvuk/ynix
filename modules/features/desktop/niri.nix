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
    screenToolkit = "${noct} plugin:screen-toolkit toggle";
    volumePanel = "${noct} volume togglePanel";
    bluetoothPanel = "${noct} bluetooth togglePanel";
    networkPanel = "${noct} network togglePanel";
    tailscalePanel = "${noct} plugin:tailscale togglePanel";
    batteryPanel = "${noct} battery togglePanel";
    notificationsPanel = "${noct} notifications toggleHistory";

    caffeine = "${noct} idleInhibitor toggle";
    volumeToggle = "${noct} volume toggle";
    bluetoothToggle = "${noct} bluetooth toggle";
    networkToggle = "${noct} network toggle";
    mute = "${noct} notifications toggleDND";

    screenshotArea = "${noct} plugin:screen-toolkit annotate";
    screenshotFullscreen = "${noct} plugin:screen-toolkit annotateFullscreen";
    recordArea = "${noct} plugin:screen-toolkit recordMp4";
    recordFullscreen = "${noct} plugin:screen-toolkit recordFullscreenMp4";

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
        {command = ["noctalia-shell"];}
        {command = ["xwayland-satellite"];}
        {command = ["${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"];}

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
        default-column-width.proportion = 0.67;
        preset-column-widths = [
          {proportion = 0.33;}
          {proportion = 0.5;}
          {proportion = 0.67;}
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

      gestures.hot-corners.enable = false;

      workspaces = {
        "01" = {name = "media";};
        "02" = {name = "comms";};
        "03" = {name = "browser";};
        "04" = {name = "terminal";};
        "05" = {name = "obsidian";};
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
          matches = [{app-id = "^spotify$";}];
          open-on-workspace = "media";
        }
        {
          matches = [{app-id = "^steam$";}];
          open-on-workspace = "media";
        }
        {
          matches = [{app-id = "^signal$";}];
          open-on-workspace = "comms";
          block-out-from = "screencast";
        }
        {
          matches = [{app-id = "discord";}];
          open-on-workspace = "comms";
          block-out-from = "screencast";
        }
        {
          matches = [
            {
              app-id = "^zen";
              at-startup = true;
            }
          ];
          open-on-workspace = "browser";
        }
        {
          matches = [
            {
              app-id = "^helium";
              at-startup = true;
            }
          ];
          open-on-workspace = "browser";
        }
        {
          matches = [
            {
              app-id = "^kitty$";
              at-startup = true;
            }
          ];
          open-on-workspace = "terminal";
        }
        {
          matches = [{app-id = "obsidian";}];
          open-on-workspace = "obsidian";
          block-out-from = "screencast";
        }

        {
          matches = [{app-id = "^Bitwarden$";}];
          block-out-from = "screencast"; # mozda moze da se stavi i "screen-capture"
        }

        #{
        #  matches = [{title = "^Picture-in-Picture$";}];
        #  open-floating = true;
        #}
        #{
        #  matches = [{app-id = "^satty$";}];
        #  open-floating = true;
        #}
        #{
        #  matches = [{app-id = "^polkit-gnome-authentication-agent-1$";}];
        #  open-floating = true;
        #}
      ];

      binds = {
        #Core nav
        "Mod+Space".action = spawn-sh launcher;
        "Mod+Shift+Space".action = spawn-sh clipboard;
        "Mod+Ctrl+Space".action = spawn-sh bar;
        "Mod+Delete".action = spawn-sh sessionMenu;
        "Mod+Escape".action = spawn-sh controlCenter;

        "Mod+Q".action = close-window;
        "Mod+W".action = toggle-window-floating;
        "Mod+E".action = maximize-column;
        "Mod+R".action = switch-preset-column-width;
        "Mod+F".action = fullscreen-window;

        "Mod+Return".action = spawn terminal;
        "Mod+Alt+D".action = spawn terminal "-e" "lazydocker";
        "Mod+Alt+G".action = spawn terminal "-e" "gh-dash";
        "Mod+Alt+I".action = spawn terminal "-e" "btop";
        "Mod+Alt+Y".action = spawn terminal "-e" "yazi";
        "Mod+Alt+V".action = spawn terminal "-e" "wiremix";
        "Mod+Alt+B".action = spawn terminal "-e" "bluetuith";
        "Mod+Alt+N".action = spawn terminal "-e" "nmtui";
        "Mod+Alt+H".action = spawn helium;
        "Mod+Alt+Z".action = spawn zen;

        "Mod+H".action = focus-column-left;
        "Mod+L".action = focus-column-right;
        "Mod+J".action = focus-window-or-workspace-down;
        "Mod+K".action = focus-window-or-workspace-up;

        "Mod+Shift+H".action = move-column-left;
        "Mod+Shift+L".action = move-column-right;
        "Mod+Shift+J".action = move-window-down-or-to-workspace-down;
        "Mod+Shift+K".action = move-window-up-or-to-workspace-up;

        "Mod+Ctrl+Alt+J".action = move-workspace-down;
        "Mod+Ctrl+Alt+K".action = move-workspace-up;

        #"Mod+Shift+Ctrl+H".action = move-workspace-to-monitor-left;
        #"Mod+Shift+Ctrl+L".action = move-workspace-to-monitor-right;
        #"Mod+Shift+Ctrl+K".action = move-workspace-to-monitor-up;
        #"Mod+Shift+Ctrl+J".action = move-workspace-to-monitor-down;

        "Mod+T".action = spawn-sh tailscalePanel;
        "Mod+X".action = spawn-sh screenToolkit;
        "Mod+C".action = spawn-sh calendar;
        "Mod+V".action = spawn-sh volumePanel;
        "Mod+B".action = spawn-sh bluetoothPanel;
        "Mod+N".action = spawn-sh networkPanel;
        "Mod+M".action = spawn-sh mediaPanel;
        "Mod+Shift+B".action = spawn-sh batteryPanel;
        "Mod+Shift+N".action = spawn-sh notificationsPanel;

        "Mod+Ctrl+C".action = spawn-sh caffeine;
        "Mod+Ctrl+V".action = spawn-sh volumeToggle;
        "Mod+Ctrl+B".action = spawn-sh bluetoothToggle;
        "Mod+Ctrl+N".action = spawn-sh networkToggle;
        "Mod+Ctrl+M".action = spawn-sh mute;

        "Mod+S".action = spawn-sh settings;

        "Print".action = spawn-sh screenshotArea;
        "Shift+Print".action = spawn-sh screenshotFullscreen;
        "Alt+Print".action = spawn-sh recordArea;
        "Alt+Shift+Print".action = spawn-sh recordFullscreen;

        "Mod+1".action = focus-workspace 1;
        "Mod+Shift+1".action.move-column-to-workspace = 1;
        "Mod+2".action = focus-workspace 2;
        "Mod+Shift+2".action.move-column-to-workspace = 2;
        "Mod+3".action = focus-workspace 3;
        "Mod+Shift+3".action.move-column-to-workspace = 3;
        "Mod+4".action = focus-workspace 4;
        "Mod+Shift+4".action.move-column-to-workspace = 4;
        "Mod+5".action = focus-workspace 5;
        "Mod+Shift+5".action.move-column-to-workspace = 5;
        "Mod+6".action = focus-workspace 6;
        "Mod+Shift+6".action.move-column-to-workspace = 6;
        "Mod+7".action = focus-workspace 7;
        "Mod+Shift+7".action.move-column-to-workspace = 7;
        "Mod+8".action = focus-workspace 8;
        "Mod+Shift+8".action.move-column-to-workspace = 8;
        "Mod+9".action = focus-workspace 9;
        "Mod+Shift+9".action.move-column-to-workspace = 9;
        "Mod+0".action = focus-workspace 10;
        "Mod+Shift+0".action.move-column-to-workspace = 10;

        "Mod+Grave".action = toggle-overview;
        "Mod+Tab".action = focus-workspace-previous;
        "Alt+Tab".action = focus-window-previous;

        "Mod+Shift+period" = {
          action = set-column-width "+5%";
          repeat = true;
        };
        "Mod+Shift+comma" = {
          action = set-column-width "-5%";
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
