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
              "flavor": "classic-medium-dark",
              "accent": "blue"
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
                "id": "dock_launcher",
                "widgetId": "dockLauncher",
                "enabled": true
              },
              {
                "id": "dock_apps",
                "widgetId": "appsDock",
                "enabled": true
              },
              {
                "id": "dock_trash",
                "widgetId": "dockTrash",
                "enabled": true
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
            "id": "user",
            "enabled": true,
            "w": 4,
            "h": 1,
            "col": 0,
            "row": 0,
            "background": true
          },
          {
            "id": "settings",
            "enabled": true,
            "w": 1,
            "h": 1,
            "small": true,
            "col": 5,
            "row": 0
          },
          {
            "id": "lock",
            "enabled": true,
            "w": 1,
            "h": 1,
            "small": true,
            "col": 6,
            "row": 0
          },
          {
            "id": "power",
            "enabled": true,
            "w": 1,
            "h": 1,
            "small": true,
            "col": 7,
            "row": 0
          },
          {
            "enabled": true,
            "id": "volumeSlider",
            "w": 4,
            "h": 1,
            "col": 0,
            "row": 1
          },
          {
            "enabled": true,
            "id": "brightnessSlider",
            "w": 4,
            "h": 1,
            "col": 4,
            "row": 1
          },
          {
            "enabled": true,
            "id": "wifi",
            "w": 1.5,
            "h": 1,
            "col": 0,
            "row": 2,
            "small": true
          },
          {
            "enabled": true,
            "id": "bluetooth",
            "w": 1.5,
            "h": 1,
            "col": 1.5,
            "row": 2,
            "small": true
          },
          {
            "enabled": true,
            "id": "audioOutput",
            "w": 1,
            "h": 1,
            "col": 3,
            "row": 2,
            "small": true
          },
          {
            "enabled": true,
            "id": "audioInput",
            "w": 1,
            "h": 1,
            "col": 4,
            "row": 2,
            "small": true
          },
          {
            "enabled": true,
            "id": "plugin_dankKDEConnect",
            "w": 3,
            "h": 1,
            "col": 5,
            "row": 2,
            "small": true
          },
          {
            "enabled": true,
            "id": "nightMode",
            "w": 1,
            "h": 1,
            "col": 2,
            "row": 3,
            "small": true
          },
          {
            "enabled": true,
            "id": "idleInhibitor",
            "w": 1,
            "h": 1,
            "col": 1,
            "row": 3,
            "small": true
          },
          {
            "enabled": true,
            "id": "doNotDisturb",
            "w": 1,
            "h": 1,
            "col": 0,
            "row": 3,
            "small": true
          },
          {
            "enabled": true,
            "id": "plugin_quickCapture",
            "w": 1,
            "h": 1,
            "col": 3,
            "row": 3,
            "small": true
          },
          {
            "id": "edit",
            "enabled": true,
            "w": 1,
            "h": 1,
            "small": true,
            "col": 4,
            "row": 0
          },
          {
            "id": "runningApps",
            "enabled": true,
            "w": 4,
            "h": 1,
            "small": true,
            "col": 4,
            "row": 3
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
            "id": "clock",
            "w": 1,
            "h": 1,
            "col": 0,
            "row": 0
          },
          {
            "id": "weather",
            "w": 2,
            "h": 1,
            "col": 1,
            "row": 0
          },
          {
            "id": "notifications",
            "w": 3,
            "h": 5,
            "col": 3,
            "row": 0
          },
          {
            "id": "calendar",
            "w": 3,
            "h": 3,
            "col": 0,
            "row": 1
          },
          {
            "id": "media",
            "w": 3,
            "h": 1,
            "col": 0,
            "row": 4
          },
          {
            "id": "wellbeing",
            "w": 1,
            "h": 1,
            "col": 3,
            "row": 5
          },
          {
            "id": "sysmon",
            "w": 2,
            "h": 1,
            "col": 0,
            "row": 6
          },
          {
            "id": "battery",
            "w": 1,
            "h": 1,
            "col": 5,
            "row": 6
          },
          {
            "id": "network",
            "w": 2,
            "h": 1,
            "col": 4,
            "row": 5
          },
          {
            "id": "memory",
            "w": 1,
            "h": 1,
            "col": 3,
            "row": 6
          },
          {
            "id": "cpu",
            "w": 1,
            "h": 1,
            "col": 2,
            "row": 6
          },
          {
            "id": "user",
            "w": 3,
            "h": 1,
            "col": 0,
            "row": 5
          },
          {
            "id": "disk",
            "w": 1,
            "h": 1,
            "col": 4,
            "row": 6
          }
        ],
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
                "id": "media",
                "enabled": true
              },
              {
                "id": "clock",
                "enabled": true
              },
              {
                "id": "weather",
                "enabled": true
              },
              {
                "id": "notifications",
                "enabled": true
              },
              {
                "id": "status",
                "enabled": false
              },
              {
                "id": "volume",
                "enabled": false
              },
              {
                "id": "brightness",
                "enabled": false
              },
              {
                "id": "workspaces",
                "enabled": false
              },
              {
                "id": "privacy",
                "enabled": true
              },
              {
                "id": "tray",
                "enabled": false
              }
            ],
            "islandInteractionMode": "hybrid",
            "islandMediaClockVisible": true,
            "islandNotificationBadgeClearOnOpen": false,
            "islandNotificationExpand": true,
            "islandOuterGap": 4,
            "islandPalette": "default",
            "islandReserveThickness": 34,
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
                "launcherLogoMode": "os",
                "launcherLogoColorOverride": "primary"
              },
              {
                "enabled": true,
                "id": "nixMonitor"
              },
              {
                "enabled": true,
                "id": "workspaceSwitcher",
                "showWorkspaceApps": true,
                "maxWorkspaceIcons": 10,
                "workspaceAppIconSizeOffset": 2,
                "groupWorkspaceApps": false,
                "showOccupiedWorkspacesOnly": false,
                "workspaceColorMode": "s",
                "workspaceOccupiedColorMode": "s",
                "workspaceUnfocusedColorMode": "s",
                "workspaceFocusedBorderEnabled": true,
                "workspaceFocusedBorderThickness": 1,
                "workspaceIndicatorStyle": "dots",
                "workspaceIndicatorCompact": false,
                "workspaceFocusedCustomColor": "#6750A4",
                "workspaceOccupiedCustomColor": "#625B71",
                "workspaceUnfocusedCustomColor": "#49454E",
                "workspaceUrgentColorMode": "secondary"
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
                "id": "systemTray",
                "trayAutoOverflow": true,
                "trayUseInlineExpansion": false
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
            "widgetOutlineColor": "primary",
            "widgetOutlineEnabled": false,
            "widgetOutlineOpacity": 1,
            "widgetOutlineThickness": 1,
            "widgetPadding": 8,
            "widgetTransparency": 1,
            "followInterfaceStyle": true,
            "widgetFollowInterfaceStyle": true,
            "islandNotch": false,
            "islandRouteLauncher": "island",
            "islandRouteControlCenter": "island",
            "islandRouteClipboard": "island",
            "islandRoutePowerMenu": "island",
            "islandRouteNotificationCenter": "island",
            "islandNotificationPopups": false,
            "widgetStyle": "pills"
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
