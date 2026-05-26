# Noctalia Shell - Wayland desktop shell built with QuickShell
{
  self,
  inputs,
  ...
}: {
  flake.nixosModules.noctalia = {...}: {
    home-manager.sharedModules = [self.homeModules.noctalia];
  };

  flake.homeModules.noctalia = {
    pkgs,
    lib,
    config,
    ...
  }: let
    theme = config.theme.active;
  in {
    imports = [inputs.noctalia.homeModules.default];

    home.packages = with pkgs; [
      brightnessctl
      playerctl

      git
      kdePackages.qttools
    ];

    programs.noctalia-shell = lib.mkForce {
      enable = true;
      package = inputs.noctalia.packages.${pkgs.system}.default;

      colors = {
        mPrimary = theme.base0D;
        mOnPrimary = theme.base00;
        mSecondary = theme.base04;
        mOnSecondary = theme.base00;
        mTertiary = theme.base0C;
        mOnTertiary = theme.base00;
        mError = theme.base08;
        mOnError = theme.base00;
        mSurface = theme.base00;
        mOnSurface = theme.base05;
        mSurfaceVariant = theme.base01;
        mOnSurfaceVariant = theme.base04;
        mOutline = theme.base03;
        mShadow = theme.base00;
        mHover = theme.base0C;
        mOnHover = theme.base00;
      };

      settings = builtins.fromJSON ''
        {
          "settingsVersion": 59,
          "bar": {
            "barType": "simple",
            "position": "top",
            "monitors": [],
            "density": "default",
            "showOutline": false,
            "showCapsule": true,
            "capsuleOpacity": 1,
            "capsuleColorKey": "none",
            "widgetSpacing": 6,
            "contentPadding": 4,
            "fontScale": 1,
            "enableExclusionZoneInset": true,
            "backgroundOpacity": 1,
            "useSeparateOpacity": false,
            "marginVertical": 4,
            "marginHorizontal": 4,
            "frameThickness": 8,
            "frameRadius": 12,
            "outerCorners": true,
            "hideOnOverview": false,
            "displayMode": "always_visible",
            "autoHideDelay": 500,
            "autoShowDelay": 150,
            "showOnWorkspaceSwitch": true,
            "widgets": {
              "left": [
                {
                  "colorizeDistroLogo": false,
                  "colorizeSystemIcon": "none",
                  "colorizeSystemText": "none",
                  "customIconPath": "",
                  "enableColorization": false,
                  "icon": "snowflake",
                  "id": "ControlCenter",
                  "useDistroLogo": true
                },
                {
                  "characterCount": 2,
                  "colorizeIcons": false,
                  "emptyColor": "secondary",
                  "enableScrollWheel": true,
                  "focusedColor": "primary",
                  "followFocusedScreen": false,
                  "fontWeight": "bold",
                  "groupedBorderOpacity": 1,
                  "hideUnoccupied": false,
                  "iconScale": 0.8,
                  "id": "Workspace",
                  "labelMode": "index",
                  "occupiedColor": "secondary",
                  "pillSize": 0.6,
                  "showApplications": true,
                  "showApplicationsHover": true,
                  "showBadge": false,
                  "showLabelsOnlyWhenOccupied": false,
                  "unfocusedIconsOpacity": 1
                }
              ],
              "center": [
                {
                  "clockColor": "none",
                  "customFont": "",
                  "formatHorizontal": "dddd, MMMM dd - HH:mm",
                  "formatVertical": "HH mm - dd MM",
                  "id": "Clock",
                  "tooltipFormat": "HH:mm ddd, MMM dd",
                  "useCustomFont": false
                }
              ],
              "right": [
                {
                  "defaultSettings": {
                    "activeColor": "primary",
                    "camFilterRegex": "",
                    "enableToast": true,
                    "hideInactive": false,
                    "iconSpacing": 4,
                    "inactiveColor": "none",
                    "micFilterRegex": "",
                    "removeMargins": false
                  },
                  "id": "plugin:privacy-indicator"
                },
                {
                  "blacklist": [],
                  "chevronColor": "none",
                  "colorizeIcons": false,
                  "drawerEnabled": true,
                  "hidePassive": false,
                  "id": "Tray",
                  "pinned": []
                },
                {
                  "iconColor": "none",
                  "id": "KeepAwake",
                  "textColor": "none"
                },
                {
                  "displayMode": "onhover",
                  "iconColor": "none",
                  "id": "Volume",
                  "middleClickCommand": "pwvucontrol || pavucontrol",
                  "textColor": "none"
                },
                {
                  "displayMode": "onhover",
                  "iconColor": "none",
                  "id": "Bluetooth",
                  "textColor": "none"
                },
                {
                  "displayMode": "onhover",
                  "iconColor": "none",
                  "id": "Network",
                  "textColor": "none"
                },
                {
                  "defaultSettings": {},
                  "id": "plugin:kde-connect"
                },
                {
                  "displayMode": "forceOpen",
                  "iconColor": "none",
                  "id": "KeyboardLayout",
                  "showIcon": false,
                  "textColor": "none"
                },
                {
                  "deviceNativePath": "__default__",
                  "displayMode": "graphic",
                  "hideIfIdle": false,
                  "hideIfNotDetected": true,
                  "id": "Battery",
                  "showNoctaliaPerformance": true,
                  "showPowerProfiles": true
                },
                {
                  "hideWhenZero": false,
                  "hideWhenZeroUnread": false,
                  "iconColor": "none",
                  "id": "NotificationHistory",
                  "showUnreadBadge": true,
                  "unreadBadgeColor": "primary"
                }
              ]
            },
            "mouseWheelAction": "none",
            "reverseScroll": false,
            "mouseWheelWrap": true,
            "middleClickAction": "none",
            "middleClickFollowMouse": false,
            "middleClickCommand": "",
            "rightClickAction": "controlCenter",
            "rightClickFollowMouse": true,
            "rightClickCommand": "",
            "screenOverrides": []
          },
          "general": {
            "avatarImage": "/home/vyke/.face",
            "dimmerOpacity": 0.2,
            "showScreenCorners": false,
            "forceBlackScreenCorners": false,
            "scaleRatio": 1,
            "radiusRatio": 1,
            "iRadiusRatio": 1,
            "boxRadiusRatio": 1,
            "screenRadiusRatio": 1,
            "animationSpeed": 1,
            "animationDisabled": false,
            "compactLockScreen": true,
            "lockScreenAnimations": true,
            "lockOnSuspend": true,
            "showSessionButtonsOnLockScreen": true,
            "showHibernateOnLockScreen": true,
            "enableLockScreenMediaControls": false,
            "enableShadows": false,
            "enableBlurBehind": false,
            "shadowDirection": "bottom",
            "shadowOffsetX": 0,
            "shadowOffsetY": 3,
            "language": "",
            "allowPanelsOnScreenWithoutBar": true,
            "showChangelogOnStartup": true,
            "telemetryEnabled": false,
            "enableLockScreenCountdown": true,
            "lockScreenCountdownDuration": 10000,
            "autoStartAuth": true,
            "allowPasswordWithFprintd": false,
            "clockStyle": "custom",
            "clockFormat": "hh\\nmm",
            "passwordChars": false,
            "lockScreenMonitors": [],
            "lockScreenBlur": 0,
            "lockScreenTint": 0,
            "keybinds": {
              "keyUp": [
                "Up",
                "Ctrl+P"
              ],
              "keyDown": [
                "Down",
                "Ctrl+N"
              ],
              "keyLeft": [
                "Left"
              ],
              "keyRight": [
                "Right"
              ],
              "keyEnter": [
                "Return"
              ],
              "keyEscape": [
                "Esc"
              ],
              "keyRemove": [
                "Del"
              ]
            },
            "reverseScroll": false,
            "smoothScrollEnabled": true
          },
          "ui": {
            "fontDefault": "SF Pro nerd font",
            "fontFixed": "Jetbrains Mono Nerd Font",
            "fontDefaultScale": 1,
            "fontFixedScale": 1,
            "tooltipsEnabled": true,
            "scrollbarAlwaysVisible": false,
            "boxBorderEnabled": false,
            "panelBackgroundOpacity": 1,
            "translucentWidgets": false,
            "panelsAttachedToBar": true,
            "settingsPanelMode": "attached",
            "settingsPanelSideBarCardStyle": false
          },
          "location": {
            "name": "Belgrade",
            "weatherEnabled": true,
            "weatherShowEffects": false,
            "weatherTaliaMascotAlways": true,
            "useFahrenheit": false,
            "use12hourFormat": false,
            "showWeekNumberInCalendar": false,
            "showCalendarEvents": true,
            "showCalendarWeather": true,
            "analogClockInCalendar": false,
            "firstDayOfWeek": -1,
            "hideWeatherTimezone": false,
            "hideWeatherCityName": false,
            "autoLocate": false
          },
          "calendar": {
            "cards": [
              {
                "enabled": true,
                "id": "calendar-header-card"
              },
              {
                "enabled": true,
                "id": "calendar-month-card"
              },
              {
                "enabled": true,
                "id": "weather-card"
              }
            ]
          },
          "wallpaper": {
            "enabled": true,
            "overviewEnabled": false,
            "directory": "/home/vyke/Pictures/Wallpapers",
            "monitorDirectories": [],
            "enableMultiMonitorDirectories": false,
            "showHiddenFiles": false,
            "viewMode": "single",
            "setWallpaperOnAllMonitors": true,
            "linkLightAndDarkWallpapers": true,
            "fillMode": "crop",
            "fillColor": "#000000",
            "useSolidColor": false,
            "solidColor": "#1a1a2e",
            "automationEnabled": false,
            "wallpaperChangeMode": "random",
            "randomIntervalSec": 300,
            "transitionDuration": 1500,
            "transitionType": [
              "fade",
              "disc",
              "stripes",
              "wipe",
              "pixelate",
              "honeycomb"
            ],
            "skipStartupTransition": false,
            "transitionEdgeSmoothness": 0.05,
            "panelPosition": "follow_bar",
            "hideWallpaperFilenames": false,
            "useOriginalImages": false,
            "overviewBlur": 0.4,
            "overviewTint": 0.6,
            "useWallhaven": false,
            "wallhavenQuery": "",
            "wallhavenSorting": "relevance",
            "wallhavenOrder": "desc",
            "wallhavenCategories": "111",
            "wallhavenPurity": "100",
            "wallhavenRatios": "",
            "wallhavenApiKey": "",
            "wallhavenResolutionMode": "atleast",
            "wallhavenResolutionWidth": "",
            "wallhavenResolutionHeight": "",
            "sortOrder": "name",
            "favorites": []
          },
          "appLauncher": {
            "enableClipboardHistory": true,
            "autoPasteClipboard": false,
            "enableClipPreview": true,
            "clipboardWrapText": true,
            "enableClipboardSmartIcons": true,
            "enableClipboardChips": true,
            "clipboardWatchTextCommand": "wl-paste --type text --watch cliphist store",
            "clipboardWatchImageCommand": "wl-paste --type image --watch cliphist store",
            "position": "top_center",
            "pinnedApps": [],
            "sortByMostUsed": true,
            "terminalCommand": "kitty -e",
            "customLaunchPrefixEnabled": false,
            "customLaunchPrefix": "",
            "viewMode": "list",
            "showCategories": false,
            "iconMode": "tabler",
            "showIconBackground": false,
            "enableSettingsSearch": true,
            "enableWindowsSearch": true,
            "enableSessionSearch": true,
            "ignoreMouseInput": true,
            "screenshotAnnotationTool": "satty -f -",
            "overviewLayer": false,
            "density": "default"
          },
          "controlCenter": {
            "position": "close_to_bar_button",
            "diskPath": "/",
            "shortcuts": {
              "left": [
                {
                  "id": "AirplaneMode"
                },
                {
                  "defaultSettings": {},
                  "id": "plugin:kde-connect"
                },
                {
                  "id": "Bluetooth"
                },
                {
                  "id": "Network"
                }
              ],
              "right": [
                {
                  "id": "KeepAwake"
                },
                {
                  "id": "NightLight"
                },
                {
                  "id": "NoctaliaPerformance"
                },
                {
                  "id": "PowerProfile"
                }
              ]
            },
            "cards": [
              {
                "enabled": true,
                "id": "profile-card"
              },
              {
                "enabled": true,
                "id": "shortcuts-card"
              },
              {
                "enabled": true,
                "id": "audio-card"
              },
              {
                "enabled": true,
                "id": "brightness-card"
              },
              {
                "enabled": false,
                "id": "weather-card"
              },
              {
                "enabled": false,
                "id": "media-sysmon-card"
              }
            ]
          },
          "systemMonitor": {
            "cpuWarningThreshold": 80,
            "cpuCriticalThreshold": 90,
            "tempWarningThreshold": 80,
            "tempCriticalThreshold": 90,
            "gpuWarningThreshold": 80,
            "gpuCriticalThreshold": 90,
            "memWarningThreshold": 80,
            "memCriticalThreshold": 90,
            "swapWarningThreshold": 80,
            "swapCriticalThreshold": 90,
            "diskWarningThreshold": 80,
            "diskCriticalThreshold": 90,
            "diskAvailWarningThreshold": 20,
            "diskAvailCriticalThreshold": 10,
            "batteryWarningThreshold": 20,
            "batteryCriticalThreshold": 5,
            "enableDgpuMonitoring": false,
            "useCustomColors": false,
            "warningColor": "",
            "criticalColor": "",
            "externalMonitor": "resources || missioncenter || jdsystemmonitor || corestats || system-monitoring-center || gnome-system-monitor || plasma-systemmonitor || mate-system-monitor || ukui-system-monitor || deepin-system-monitor || pantheon-system-monitor"
          },
          "noctaliaPerformance": {
            "disableWallpaper": true,
            "disableDesktopWidgets": true
          },
          "dock": {
            "enabled": true,
            "position": "bottom",
            "displayMode": "auto_hide",
            "dockType": "floating",
            "backgroundOpacity": 1,
            "floatingRatio": 1,
            "size": 1.25,
            "onlySameOutput": true,
            "monitors": [],
            "pinnedApps": [
              "zen-beta",
              "helium",
              "LocalSend",
              "kitty",
              "bitwarden",
              "spotify",
              "signal",
              "discord",
              "obsidian",
              "steam",
              "dev.zed.Zed",
              "idea",
              "datagrip"
            ],
            "colorizeIcons": false,
            "showLauncherIcon": false,
            "launcherPosition": "end",
            "launcherUseDistroLogo": false,
            "launcherIcon": "",
            "launcherIconColor": "none",
            "pinnedStatic": true,
            "inactiveIndicators": true,
            "groupApps": true,
            "groupContextMenuMode": "extended",
            "groupClickAction": "list",
            "groupIndicatorStyle": "dots",
            "deadOpacity": 0.6,
            "animationSpeed": 1,
            "sitOnFrame": false,
            "showDockIndicator": true,
            "indicatorThickness": 3,
            "indicatorColor": "secondary",
            "indicatorOpacity": 0.30000000000000004
          },
          "network": {
            "bluetoothRssiPollingEnabled": true,
            "bluetoothRssiPollIntervalMs": 10000,
            "networkPanelView": "wifi",
            "wifiDetailsViewMode": "grid",
            "bluetoothDetailsViewMode": "grid",
            "bluetoothHideUnnamedDevices": false,
            "disableDiscoverability": false,
            "bluetoothAutoConnect": true
          },
          "sessionMenu": {
            "enableCountdown": true,
            "countdownDuration": 5000,
            "position": "center",
            "showHeader": true,
            "showKeybinds": true,
            "largeButtonsStyle": true,
            "largeButtonsLayout": "grid",
            "powerOptions": [
              {
                "action": "lock",
                "command": "",
                "countdownEnabled": true,
                "enabled": true,
                "keybind": "1"
              },
              {
                "action": "suspend",
                "command": "",
                "countdownEnabled": true,
                "enabled": true,
                "keybind": "2"
              },
              {
                "action": "hibernate",
                "command": "",
                "countdownEnabled": true,
                "enabled": true,
                "keybind": "3"
              },
              {
                "action": "reboot",
                "command": "",
                "countdownEnabled": true,
                "enabled": true,
                "keybind": "4"
              },
              {
                "action": "logout",
                "command": "",
                "countdownEnabled": true,
                "enabled": true,
                "keybind": "5"
              },
              {
                "action": "shutdown",
                "command": "",
                "countdownEnabled": true,
                "enabled": true,
                "keybind": "6"
              },
              {
                "action": "rebootToUefi",
                "command": "",
                "countdownEnabled": true,
                "enabled": false,
                "keybind": ""
              },
              {
                "action": "userspaceReboot",
                "command": "",
                "countdownEnabled": true,
                "enabled": false,
                "keybind": ""
              }
            ]
          },
          "notifications": {
            "enabled": true,
            "enableMarkdown": false,
            "density": "default",
            "monitors": [],
            "location": "top_right",
            "overlayLayer": true,
            "backgroundOpacity": 1,
            "respectExpireTimeout": false,
            "lowUrgencyDuration": 3,
            "normalUrgencyDuration": 5,
            "criticalUrgencyDuration": 7,
            "clearDismissed": true,
            "saveToHistory": {
              "low": true,
              "normal": true,
              "critical": true
            },
            "sounds": {
              "enabled": false,
              "volume": 0.5,
              "separateSounds": false,
              "criticalSoundFile": "",
              "normalSoundFile": "",
              "lowSoundFile": "",
              "excludedApps": "discord,firefox,chrome,chromium,edge"
            },
            "enableMediaToast": false,
            "enableKeyboardLayoutToast": false,
            "enableBatteryToast": true
          },
          "osd": {
            "enabled": true,
            "location": "top",
            "autoHideMs": 2000,
            "overlayLayer": true,
            "backgroundOpacity": 1,
            "enabledTypes": [
              0,
              1,
              2,
              3
            ],
            "monitors": []
          },
          "audio": {
            "volumeStep": 5,
            "volumeOverdrive": false,
            "spectrumFrameRate": 30,
            "visualizerType": "linear",
            "spectrumMirrored": true,
            "mprisBlacklist": [],
            "preferredPlayer": "",
            "volumeFeedback": false,
            "volumeFeedbackSoundFile": ""
          },
          "brightness": {
            "brightnessStep": 5,
            "enforceMinimum": true,
            "enableDdcSupport": false,
            "backlightDeviceMappings": []
          },
          "colorSchemes": {
            "useWallpaperColors": false,
            "predefinedScheme": "Noctalia (default)",
            "darkMode": true,
            "schedulingMode": "off",
            "manualSunrise": "06:30",
            "manualSunset": "18:30",
            "generationMethod": "tonal-spot",
            "monitorForColors": "",
            "syncGsettings": true
          },
          "templates": {
            "activeTemplates": [],
            "enableUserTheming": false
          },
          "nightLight": {
            "enabled": false,
            "forced": false,
            "autoSchedule": true,
            "nightTemp": "4000",
            "dayTemp": "6500",
            "manualSunrise": "06:30",
            "manualSunset": "18:30"
          },
          "hooks": {
            "enabled": false,
            "wallpaperChange": "",
            "darkModeChange": "",
            "screenLock": "",
            "screenUnlock": "",
            "performanceModeEnabled": "",
            "performanceModeDisabled": "",
            "startup": "",
            "session": "",
            "colorGeneration": ""
          },
          "plugins": {
            "autoUpdate": true,
            "notifyUpdates": false
          },
          "idle": {
            "enabled": true,
            "screenOffTimeout": 300,
            "lockTimeout": 600,
            "suspendTimeout": 660,
            "fadeDuration": 5,
            "screenOffCommand": "",
            "lockCommand": "",
            "suspendCommand": "",
            "resumeScreenOffCommand": "",
            "resumeLockCommand": "",
            "resumeSuspendCommand": "",
            "customCommands": "[]"
          },
          "desktopWidgets": {
            "enabled": false,
            "overviewEnabled": true,
            "gridSnap": false,
            "gridSnapScale": false,
            "monitorWidgets": []
          }
        }
      '';
    };
  };
}
