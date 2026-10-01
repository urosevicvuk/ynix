{
  self,
  inputs,
  ...
}: {
  # Self-registers into the `desktop` group (merged with the other desktop modules).
  flake.nixosModules.desktop.imports = [self.nixosModules.dms-shell];

  flake.nixosModules.dms-shell = {config, ...}: {
    imports = [
      inputs.dms-plugin-registry.nixosModules.default
      inputs.dcal.nixosModules.default
    ];

    programs.dms-shell = {
      enable = true;

      systemd = {
        enable = true;
        restartIfChanged = true;
      };

      # Installed to /etc/xdg/quickshell/dms-plugins. A same-named copy in
      # ~/.config/DankMaterialShell/plugins wins over these, so clear those out.
      plugins = {
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
    };

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

  flake.homeModules.dms-shell = {config, ...}: {
    xdg.configFile."DankMaterialShell/themes/gruvboxMulti".source = "${inputs.dms-plugin-registry}/themes/gruvbox-multi";

    # Read-only on purpose: GUI changes still apply live, and Settings shows an
    # "unsaved changes" banner with a copy-settings.json button — paste that here.
    # (or: dms ipc call settings dump | wl-copy)
    xdg.configFile."DankMaterialShell/settings.json".text = ''
      {
        "currentThemeName": "custom",
        "currentThemeCategory": "registry",
        "customThemeFile": "${config.xdg.configHome}/DankMaterialShell/themes/gruvboxMulti/theme.json",
        "registryThemeVariants": {
          "gruvboxMulti": {
            "dark": {
              "flavor": "classic-hard-dark",
              "accent": "blue"
            }
          },
          "gruvboxMaterial": "hard"
        },
        "dockTransparency": 0.85,
        "cornerRadius": 12,
        "firstDayOfWeek": 1,
        "blurWallpaperOnOverview": true,
        "controlCenterShowMicPercent": true,
        "controlCenterWidgets": [
          {
            "id": "volumeSlider",
            "enabled": true,
            "width": 50
          },
          {
            "id": "brightnessSlider",
            "enabled": true,
            "width": 50
          },
          {
            "id": "wifi",
            "enabled": true,
            "width": 25
          },
          {
            "id": "bluetooth",
            "enabled": true,
            "width": 25
          },
          {
            "id": "audioOutput",
            "enabled": true,
            "width": 25
          },
          {
            "id": "audioInput",
            "enabled": true,
            "width": 25
          },
          {
            "id": "nightMode",
            "enabled": true,
            "width": 50
          },
          {
            "id": "darkMode",
            "enabled": true,
            "width": 50
          },
          {
            "id": "idleInhibitor",
            "enabled": true,
            "width": 50
          },
          {
            "id": "doNotDisturb",
            "enabled": true,
            "width": 50
          }
        ],
        "showWorkspaceApps": true,
        "maxWorkspaceIcons": 10,
        "workspaceAppIconSizeOffset": 2,
        "groupWorkspaceApps": false,
        "showOccupiedWorkspacesOnly": true,
        "workspaceColorMode": "sc",
        "workspaceOccupiedColorMode": "sc",
        "workspaceUnfocusedColorMode": "sc",
        "workspaceFocusedBorderEnabled": true,
        "workspaceFocusedBorderThickness": 1,
        "appIdSubstitutions": [],
        "clockDateFormat": "dddd, MMMM d",
        "lockDateFormat": "dddd, MMMM d",
        "greeterPamExternallyManaged": true,
        "launcherUseOverlayLayer": true,
        "launcherStyle": "island",
        "networkPreference": "wifi",
        "cursorSettings": {
          "theme": "System Default",
          "size": 24,
          "niri": {
            "hideWhenTyping": false,
            "hideAfterInactiveMs": 0
          },
          "hyprland": {
            "hideOnKeyPress": false,
            "hideOnTouch": false,
            "inactiveTimeout": 0
          },
          "mango": {
            "cursorHideTimeout": 0
          }
        },
        "launcherLogoMode": "os",
        "launcherLogoColorOverride": "primary",
        "soundNewNotification": false,
        "soundVolumeChanged": false,
        "lockBeforeSuspend": true,
        "showDock": true,
        "dockSmartAutoHide": true,
        "dockUseOverlayLayer": true,
        "dockGroupByApp": true,
        "dockOpenOnOverview": true,
        "dockSpacing": 10,
        "dockMargin": 10,
        "dockIconSize": 50,
        "enableFprint": true,
        "osdAlwaysShowValue": true,
        "osdPosition": 4,
        "osdPowerProfileEnabled": true,
        "powerMenuDefaultAction": "reboot",
        "screenPreferences": {
          "wallpaper": [
            "all"
          ]
        },
        "barConfigs": [
          {
            "id": "default",
            "name": "Main Bar",
            "enabled": true,
            "position": 0,
            "screenPreferences": [
              "all"
            ],
            "showOnLastDisplay": true,
            "leftWidgets": [
              {
                "id": "launcherButton",
                "enabled": true
              },
              {
                "id": "nixMonitor",
                "enabled": true
              },
              {
                "id": "workspaceSwitcher",
                "enabled": true
              }
            ],
            "centerWidgets": [
              {
                "id": "clock",
                "enabled": true,
                "clockCompactMode": false
              }
            ],
            "rightWidgets": [
              {
                "id": "privacyIndicator",
                "enabled": true
              },
              {
                "id": "systemTray",
                "enabled": true,
                "trayUseInlineExpansion": true,
                "trayAutoOverflow": true
              },
              {
                "id": "dankCalendarAgenda",
                "enabled": true
              },
              {
                "id": "claudeCodeUsage",
                "enabled": true
              },
              {
                "id": "dockerManager",
                "enabled": true
              },
              {
                "id": "dankKDEConnect",
                "enabled": true
              },
              {
                "id": "battery",
                "enabled": true,
                "showBatteryTime": false,
                "showBatteryTimeOnlyOnBattery": false,
                "showBatteryPowerCharging": false,
                "showBatteryPowerDischarging": false,
                "batteryStyle": "ring",
                "showBatteryPercentOnlyOnBattery": false
              },
              {
                "id": "controlCenterButton",
                "enabled": true,
                "showAudioPercent": false,
                "showIdleInhibitorIcon": true,
                "showDoNotDisturbIcon": true,
                "showBatteryIcon": false,
                "showPrinterIcon": false,
                "showScreenSharingIcon": true,
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
                "showAudioIcon": true,
                "showMicIcon": false,
                "showMicPercent": false
              }
            ],
            "spacing": 5,
            "innerPadding": 4,
            "barInsetPadding": 4,
            "bottomGap": 0,
            "transparency": 1,
            "widgetTransparency": 1,
            "squareCorners": false,
            "noBackground": false,
            "maximizeWidgetIcons": false,
            "maximizeWidgetText": false,
            "removeWidgetPadding": false,
            "widgetPadding": 8,
            "gothCornersEnabled": false,
            "gothCornerRadiusOverride": false,
            "gothCornerRadiusValue": 12,
            "borderEnabled": false,
            "borderColor": "surfaceText",
            "borderOpacity": 1,
            "borderThickness": 1,
            "widgetOutlineEnabled": false,
            "widgetOutlineColor": "primary",
            "widgetOutlineOpacity": 1,
            "widgetOutlineThickness": 1,
            "fontScale": 1,
            "iconScale": 1,
            "autoHide": false,
            "autoHideStrict": false,
            "autoHideDelay": 250,
            "showOnWindowsOpen": false,
            "openOnOverview": false,
            "visible": true,
            "popupGapsAuto": true,
            "popupGapsManual": 4,
            "maximizeDetection": true,
            "useOverlayLayer": true,
            "scrollEnabled": true,
            "scrollXBehavior": "column",
            "scrollYBehavior": "workspace",
            "shadowIntensity": 0,
            "shadowOpacity": 60,
            "shadowColorMode": "default",
            "shadowCustomColor": "#000000",
            "clickThrough": false,
            "hoverPopouts": false,
            "hoverPopoutDelay": 150,
            "attachToScreenEdge": false,
            "island": true,
            "islandFloating": false,
            "islandUseOverlayLayer": false,
            "islandCompactThickness": 30,
            "islandOuterGap": 4,
            "islandAlongOffset": 0,
            "islandHomeCompactTight": false,
            "islandPalette": "default",
            "islandCornerRadius": 34,
            "islandHighContrast": false,
            "islandMediaClockVisible": true,
            "islandBatteryStyle": "ring",
            "islandNotificationExpand": true,
            "islandNotificationBadgeClearOnOpen": false,
            "islandSatelliteBackground": false,
            "islandSatellitesEnabled": true,
            "islandSatellitePosition": "edges",
            "islandInteractionMode": "hybrid",
            "islandReserveThickness": 24,
            "batteryColorMode": "theme",
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
              }
            ],
            "islandHomeClockDisplay": "both",
            "islandSatelliteGothCorners": false,
            "islandSatelliteTransparency": 1
          }
        ],
        "desktopClockCustomColor": {
          "r": 1,
          "g": 1,
          "b": 1,
          "a": 1,
          "hsvHue": -1,
          "hsvSaturation": 0,
          "hsvValue": 1,
          "hslHue": -1,
          "hslSaturation": 0,
          "hslLightness": 1,
          "valid": true
        },
        "systemMonitorCustomColor": {
          "r": 1,
          "g": 1,
          "b": 1,
          "a": 1,
          "hsvHue": -1,
          "hsvSaturation": 0,
          "hsvValue": 1,
          "hslHue": -1,
          "hslSaturation": 0,
          "hslLightness": 1,
          "valid": true
        },
        "builtInPluginSettings": {
          "dms_settings_search": {
            "trigger": "?"
          },
          "dms_clipboard_search": {
            "trigger": "cb"
          },
          "dms_power": {
            "trigger": "pw"
          },
          "dms_qr_generator": {
            "trigger": "qrg"
          }
        },
        "clipboardUseOverlayLayer": true,
        "frameRounding": 28,
        "barInsetPaddingShared": 8,
        "barInsetPaddingSyncAll": true,
        "configVersion": 18
      }
    '';
  };
}
