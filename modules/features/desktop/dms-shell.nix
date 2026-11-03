{
  self,
  inputs,
  ...
}: {
  # Self-registers into the `desktop` group (merged with the other desktop modules).
  flake.nixosModules.desktop.imports = [self.nixosModules.dms-shell];

  flake.nixosModules.dms-shell = {
    config,
    pkgs,
    ...
  }: {
    imports = [inputs.dcal.nixosModules.default];

    # The shell itself (service, plugins, settings) lives in the home-manager module
    # below. These are the system-side defaults the NixOS module used to set.
    services.accounts-daemon.enable = true;
    hardware.i2c.enable = true;
    hardware.graphics.enable = true;

    # Runtime tools the plugins shell out to. The registry module doesn't install
    # a plugin's "requires", and a missing one usually fails silently.
    environment.systemPackages = with pkgs; [
      jq # claudeCodeUsage, dankCalendarAgenda, nixPackageRunner
      rbw # dankBitwarden backend
      wtype # dankBitwarden + emojiLauncher auto-paste
      sshfs # dankKDEConnect file browsing
      # quickCapture: exports, OCR, QR, CPU recording fallback
      imagemagick
      img2pdf
      tesseract
      zbar
      wf-recorder
    ];

    # quickCapture's preferred recorder; the module adds the cap_sys_admin wrapper KMS capture needs
    programs.gpu-screen-recorder.enable = true;

    # DankCalendar - backend for the calendar plugins, runs `dcal run --session --hidden`
    programs.dank-calendar = {
      enable = true;
      systemd = {
        enable = true;
        restartIfChanged = true;
      };
    };

    # DankSearch - file results in the launcher, runs `dsearch serve` (systemd on by default)
    programs.dsearch.enable = true;

    # --- dms-greeter (on) --- only one greeter may be active; to switch back,
    # comment this block and uncomment the registration in tuigreet.nix
    services.displayManager.dms-greeter = {
      enable = true;
      compositor.name = "niri";

      # copies DMS settings, session (wallpaper) and theme into the greeter on boot
      configHome = "/home/${config.preferences.username}";
    };

    home-manager.sharedModules = [self.homeModules.dms-shell];
  };

  flake.homeModules.dms-shell = {
    imports = [
      inputs.dms.homeModules.dank-material-shell
      inputs.dms-plugin-registry.homeModules.default
    ];

    programs.dank-material-shell.enable = true;
    programs.dank-material-shell.systemd.enable = true;

    # Themed via the registry's gruvboxMulti below; stylix's target would also
    # take over fonts/transparency and make session.json (wallpaper) read-only.
    stylix.targets.dank-material-shell.enable = false;

    # Linked into ~/.config/DankMaterialShell/plugins only. Don't also install them
    # system-wide (/etc/xdg/quickshell/dms-plugins): a plugin present in both dirs
    # races on startup and can end up unloaded but flagged as loaded, so it can't be
    # enabled. Some plugins also resolve their scripts relative to the user dir.
    programs.dank-material-shell.plugins = {
      calculator.enable = true;
      claudeCodeUsage.enable = true;
      dankBitwarden.enable = true;
      dankCalendarAgenda.enable = true;
      dankKDEConnect.enable = true;
      dankscale.enable = true;
      dockerManager.enable = true;
      emojiLauncher.enable = true;
      nixMonitor.enable = true;
      nixPackageRunner.enable = true;
      quickCapture.enable = true;
    };

    xdg.configFile."DankMaterialShell/themes/gruvboxMulti".source = "${inputs.dms-plugin-registry}/themes/gruvbox-multi";

    # Read-only on purpose: GUI changes still apply live, and Settings shows an
    # "unsaved changes" banner with a copy-settings.json button — paste that here.
    # (or: dms ipc call settings dump | wl-copy)
    programs.dank-material-shell.settings = builtins.fromJSON ''
      {
        "currentThemeName": "custom",
        "customThemeFile": "/home/vyke/.config/dms/themes/gruvboxMulti.hm-backup/theme.json",
        "registryThemeVariants": {
          "gruvboxMaterial": "hard",
          "gruvboxMulti": {
            "dark": {
              "accent": "blue",
              "flavor": "classic-medium-dark"
            }
          }
        },
        "radiusStrength": 50,
        "radiusMode": "scale",
        "wallpaperFillMode": "Tile",
        "wallpaperBackgroundColorMode": "black",
        "lockDateFormat": "dddd, MMMM d",
        "useAutoLocation": true,
        "powerMenuDefaultAction": "suspend",
        "dockConfigs": [
          {
            "id": "dock",
            "name": "Dock",
            "enabled": true,
            "screenPreferences": [
              "all"
            ],
            "showOnLastDisplay": true,
            "position": 1,
            "mode": "compact",
            "taskbarAlign": "center",
            "widgetExpansion": "popout",
            "iconSize": 50,
            "spacing": 10,
            "itemSpacing": 4,
            "margin": 10,
            "bottomGap": 0,
            "transparency": 0.85,
            "followInterfaceStyle": false,
            "autoHide": false,
            "smartAutoHide": true,
            "useOverlayLayer": true,
            "editOnRightClick": false,
            "showOnFullscreen": false,
            "openOnOverview": true,
            "groupByApp": true,
            "separatePinnedAndRunningApps": false,
            "restoreSpecialWorkspaceOnClick": false,
            "isolateDisplays": false,
            "indicatorStyle": "circle",
            "borderEnabled": false,
            "borderColor": "surfaceText",
            "borderOpacity": 1,
            "borderThickness": 1,
            "launcherEnabled": false,
            "launcherLogoMode": "apps",
            "launcherLogoCustomPath": "",
            "launcherLogoColorOverride": "",
            "launcherLogoSizeOffset": 0,
            "launcherLogoBrightness": 0.5,
            "launcherLogoContrast": 1,
            "maxVisibleApps": 0,
            "maxVisibleRunningApps": 0,
            "showOverflowBadge": true,
            "showTrash": false,
            "trashFileManager": "default",
            "trashCustomCommand": "",
            "magnification": false,
            "magnificationScale": 130,
            "magnificationProfile": "parabolic",
            "magnificationExpand": false,
            "order": [],
            "widgets": [
              {
                "enabled": true,
                "id": "dock_launcher",
                "widgetId": "dockLauncher"
              },
              {
                "enabled": true,
                "id": "dock_apps",
                "widgetId": "appsDock"
              },
              {
                "enabled": true,
                "id": "dock_trash",
                "widgetId": "dockTrash"
              }
            ]
          }
        ],
        "currentThemeCategory": "registry",
        "dmsWindowsFloatingSeeded": [
          "niri"
        ],
        "firstDayOfWeek": 1,
        "blurLayerOutlineOpacity": 0,
        "blurWallpaperOnOverview": true,
        "controlCenterWidgets": [
          {
            "background": true,
            "col": 0,
            "enabled": true,
            "h": 1,
            "id": "user",
            "row": 0,
            "w": 4
          },
          {
            "col": 5,
            "enabled": true,
            "h": 1,
            "id": "settings",
            "row": 0,
            "small": true,
            "w": 1
          },
          {
            "col": 6,
            "enabled": true,
            "h": 1,
            "id": "lock",
            "row": 0,
            "small": true,
            "w": 1
          },
          {
            "col": 7,
            "enabled": true,
            "h": 1,
            "id": "power",
            "row": 0,
            "small": true,
            "w": 1
          },
          {
            "col": 0,
            "enabled": true,
            "h": 1,
            "id": "volumeSlider",
            "row": 1,
            "w": 4
          },
          {
            "col": 4,
            "enabled": true,
            "h": 1,
            "id": "brightnessSlider",
            "row": 1,
            "w": 4
          },
          {
            "col": 0,
            "enabled": true,
            "h": 1,
            "id": "wifi",
            "row": 2,
            "small": true,
            "w": 4
          },
          {
            "col": 4,
            "enabled": true,
            "h": 1,
            "id": "bluetooth",
            "row": 2,
            "small": true,
            "w": 4
          },
          {
            "col": 0,
            "enabled": true,
            "h": 1,
            "id": "audioOutput",
            "row": 3,
            "small": true,
            "w": 4
          },
          {
            "col": 4,
            "enabled": true,
            "h": 1,
            "id": "audioInput",
            "row": 3,
            "small": true,
            "w": 4
          },
          {
            "col": 0,
            "enabled": true,
            "h": 1,
            "id": "plugin_dankKDEConnect",
            "row": 5,
            "small": true,
            "w": 4
          },
          {
            "col": 2,
            "enabled": true,
            "h": 1,
            "id": "nightMode",
            "row": 4,
            "small": true,
            "w": 2
          },
          {
            "col": 0,
            "enabled": true,
            "h": 1,
            "id": "idleInhibitor",
            "row": 4,
            "small": true,
            "w": 2
          },
          {
            "col": 4,
            "enabled": true,
            "h": 1,
            "id": "doNotDisturb",
            "row": 4,
            "small": true,
            "w": 2
          },
          {
            "col": 6,
            "enabled": true,
            "h": 1,
            "id": "plugin_quickCapture",
            "row": 4,
            "small": true,
            "w": 2
          },
          {
            "col": 4,
            "enabled": true,
            "h": 1,
            "id": "edit",
            "row": 0,
            "small": true,
            "w": 1
          },
          {
            "col": 0,
            "enabled": true,
            "h": 1,
            "id": "runningApps",
            "row": 7,
            "small": true,
            "w": 8
          },
          {
            "col": 4,
            "enabled": true,
            "h": 1,
            "id": "builtin_cups",
            "row": 5,
            "small": true,
            "w": 4
          }
        ],
        "appIdSubstitutions": [],
        "clockDateFormat": "dddd, MMMM d",
        "greeterPamExternallyManaged": true,
        "dankLauncherV2Size": "compact",
        "launcherUseOverlayLayer": true,
        "launcherStyle": "island",
        "avatarRing": "primary",
        "dashCards": [
          {
            "col": 0,
            "h": 1,
            "id": "clock",
            "row": 0,
            "w": 1
          },
          {
            "col": 1,
            "h": 1,
            "id": "weather",
            "row": 0,
            "w": 2
          },
          {
            "col": 3,
            "h": 6,
            "id": "notifications",
            "row": 0,
            "w": 3
          },
          {
            "col": 0,
            "h": 3,
            "id": "calendar",
            "row": 1,
            "w": 3
          },
          {
            "col": 0,
            "h": 2,
            "id": "media",
            "row": 4,
            "w": 3
          }
        ],
        "dashOptions": {
          "overview": {
            "panelRows": 6
          }
        },
        "networkPreference": "wifi",
        "cursorSettings": {
          "hyprland": {
            "hideOnKeyPress": false,
            "hideOnTouch": false,
            "inactiveTimeout": 0
          },
          "mango": {
            "cursorHideTimeout": 0
          },
          "niri": {
            "hideAfterInactiveMs": 0,
            "hideWhenTyping": false
          },
          "size": 24,
          "theme": "System Default"
        },
        "soundNewNotification": false,
        "soundVolumeChanged": true,
        "acProfileName": "2",
        "batteryLockTimeout": 300,
        "batterySuspendTimeout": 600,
        "batteryProfileName": "1",
        "batteryPostLockMonitorTimeout": 30,
        "lockBeforeSuspend": true,
        "fadeToLockGracePeriod": 5,
        "enableFprint": true,
        "osdAlwaysShowValue": true,
        "osdPosition": 4,
        "osdPowerProfileEnabled": true,
        "screenPreferences": {
          "wallpaper": [
            "all"
          ]
        },
        "displayProfileAutoSelect": false,
        "barConfigs": [
          {
            "attachToScreenEdge": false,
            "autoHide": false,
            "autoHideDelay": 250,
            "autoHideStrict": false,
            "barInsetPadding": 4,
            "batteryColorMode": "theme",
            "borderColor": "surfaceText",
            "borderEnabled": false,
            "borderOpacity": 1,
            "borderThickness": 1,
            "bottomGap": 0,
            "centerWidgets": [
              {
                "clockCompactMode": false,
                "enabled": true,
                "id": "clock"
              }
            ],
            "clickThrough": false,
            "enabled": true,
            "followInterfaceStyle": true,
            "fontScale": 1,
            "gothCornerRadiusOverride": false,
            "gothCornerRadiusValue": 12,
            "gothCornersEnabled": false,
            "hoverPopoutDelay": 150,
            "hoverPopouts": false,
            "iconScale": 1,
            "id": "default",
            "innerPadding": 4,
            "island": true,
            "islandAlongOffset": 0,
            "islandBatteryStyle": "ring",
            "islandCompactThickness": 30,
            "islandFloating": false,
            "islandHighContrast": false,
            "islandHomeClockDisplay": "both",
            "islandHomeCompactTight": false,
            "islandHomeLayout": [
              {
                "enabled": true,
                "id": "media"
              },
              {
                "enabled": true,
                "id": "clock"
              },
              {
                "enabled": true,
                "id": "weather"
              },
              {
                "enabled": true,
                "id": "notifications"
              },
              {
                "enabled": false,
                "id": "status"
              },
              {
                "enabled": false,
                "id": "volume"
              },
              {
                "enabled": false,
                "id": "brightness"
              },
              {
                "enabled": false,
                "id": "workspaces"
              },
              {
                "enabled": true,
                "id": "privacy"
              },
              {
                "enabled": false,
                "id": "tray"
              }
            ],
            "islandInteractionMode": "hybrid",
            "islandMediaClockVisible": true,
            "islandNotch": false,
            "islandNotificationBadgeClearOnOpen": false,
            "islandNotificationExpand": true,
            "islandNotificationPopups": false,
            "islandOuterGap": 4,
            "islandPalette": "default",
            "islandReserveThickness": 34,
            "islandRouteClipboard": "island",
            "islandRouteControlCenter": "island",
            "islandRouteLauncher": "island",
            "islandRouteNotificationCenter": "island",
            "islandRoutePowerMenu": "island",
            "islandSatelliteBackground": false,
            "islandSatelliteGothCorners": false,
            "islandSatellitePosition": "edges",
            "islandSatelliteTransparency": 1,
            "islandSatellitesEnabled": true,
            "islandUseOverlayLayer": false,
            "leftWidgets": [
              {
                "enabled": true,
                "id": "launcherButton",
                "launcherLogoColorOverride": "primary",
                "launcherLogoMode": "os"
              },
              {
                "enabled": false,
                "id": "nixMonitor"
              },
              {
                "enabled": true,
                "groupWorkspaceApps": false,
                "id": "workspaceSwitcher",
                "maxWorkspaceIcons": 10,
                "showOccupiedWorkspacesOnly": false,
                "showWorkspaceApps": true,
                "workspaceAppIconSizeOffset": 2,
                "workspaceColorMode": "s",
                "workspaceFocusedBorderEnabled": true,
                "workspaceFocusedBorderThickness": 1,
                "workspaceFocusedCustomColor": "#6750A4",
                "workspaceIndicatorCompact": false,
                "workspaceIndicatorStyle": "dots",
                "workspaceOccupiedColorMode": "s",
                "workspaceOccupiedCustomColor": "#625B71",
                "workspaceUnfocusedColorMode": "s",
                "workspaceUnfocusedCustomColor": "#49454E",
                "workspaceUrgentColorMode": "secondary"
              },
              {
                "enabled": true,
                "id": "systemTray",
                "trayAutoOverflow": true,
                "trayUseInlineExpansion": false
              },
              {
                "enabled": true,
                "id": "dockerManager"
              }
            ],
            "maximizeDetection": true,
            "maximizeWidgetIcons": false,
            "maximizeWidgetText": false,
            "name": "Main Bar",
            "noBackground": false,
            "openOnOverview": false,
            "popupGapsAuto": true,
            "popupGapsManual": 4,
            "position": 0,
            "rightWidgets": [
              {
                "enabled": false,
                "id": "privacyIndicator"
              },
              {
                "enabled": true,
                "id": "claudeCodeUsage"
              },
              {
                "enabled": true,
                "id": "dankCalendarAgenda"
              },
              {
                "enabled": true,
                "id": "keyboard_layout_name",
                "keyboardLayoutNameCompactMode": false,
                "keyboardLayoutNameShowIcon": false
              },
              {
                "batteryStyle": "icon",
                "enabled": true,
                "id": "battery",
                "showBatteryPercentOnlyOnBattery": false,
                "showBatteryPowerCharging": false,
                "showBatteryPowerDischarging": false,
                "showBatteryTime": false,
                "showBatteryTimeOnlyOnBattery": false
              },
              {
                "controlCenterGroupOrder": [
                  "network",
                  "vpn",
                  "bluetooth",
                  "audio",
                  "microphone",
                  "brightness",
                  "battery",
                  "printer",
                  "idleInhibitor",
                  "screenSharing",
                  "doNotDisturb"
                ],
                "enabled": true,
                "id": "controlCenterButton",
                "showAudioIcon": true,
                "showAudioPercent": false,
                "showBatteryIcon": false,
                "showDoNotDisturbIcon": true,
                "showIdleInhibitorIcon": true,
                "showMicIcon": false,
                "showMicPercent": false,
                "showPrinterIcon": false,
                "showScreenSharingIcon": true
              }
            ],
            "screenPreferences": [
              "all"
            ],
            "scrollEnabled": true,
            "scrollXBehavior": "focusWindow",
            "scrollYBehavior": "workspace",
            "shadowColorMode": "default",
            "shadowCustomColor": "#000000",
            "shadowIntensity": 0,
            "shadowOpacity": 60,
            "showOnLastDisplay": true,
            "showOnWindowsOpen": false,
            "spacing": 5,
            "squareCorners": false,
            "transparency": 1,
            "useOverlayLayer": true,
            "visible": true,
            "widgetFollowInterfaceStyle": true,
            "widgetOutlineColor": "primary",
            "widgetOutlineEnabled": false,
            "widgetOutlineOpacity": 1,
            "widgetOutlineThickness": 1,
            "widgetPadding": 8,
            "widgetStyle": "pills",
            "widgetTransparency": 1
          }
        ],
        "builtInPluginSettings": {
          "dms_clipboard_search": {
            "trigger": "cb"
          },
          "dms_power": {
            "trigger": "pw"
          },
          "dms_qr_generator": {
            "trigger": "qrg"
          },
          "dms_settings_search": {
            "trigger": "?"
          }
        },
        "clipboardUseOverlayLayer": true,
        "frameRounding": 28,
        "barInsetPaddingShared": 8,
        "barInsetPaddingSyncAll": true,
        "configVersion": 42
      }
    '';
  };
}
