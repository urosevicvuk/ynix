# QuickShell - end-4 bar and widgets (forked locally)
# Config is stored in ./quickshell/end4-config/ and can be customized
{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  # Python environment for wallpaper analysis (Material You colors)
  pythonEnv = pkgs.python3.withPackages (ps: [
    ps.build
    ps.cffi
    ps.click
    ps."dbus-python"
    ps."kde-material-you-colors"
    ps.libsass
    ps.loguru
    ps."material-color-utilities"
    ps.materialyoucolor
    ps.numpy
    ps.pillow
    ps.psutil
    ps.pycairo
    ps.pygobject3
    ps.pywayland
    ps.setproctitle
    ps."setuptools-scm"
    ps.tqdm
    ps.wheel
    ps."pyproject-hooks"
    ps.opencv4
  ]);

  # QuickShell with Qt dependencies and proper wrapping
  quickshellPackage = inputs.quickshell.packages.${pkgs.system}.default;

  wrappedQuickshell = pkgs.symlinkJoin {
    name = "quickshell-wrapped";
    paths = [quickshellPackage];
    buildInputs = [pkgs.makeWrapper];
    postBuild = ''
      # Wrap qs command with Qt module paths and Python
      for binary in quickshell qs; do
        if [ -f "$out/bin/$binary" ]; then
          wrapProgram "$out/bin/$binary" \
            --prefix QML2_IMPORT_PATH : "${lib.makeSearchPath "lib/qt-6/qml" [
        pkgs.kdePackages.qtpositioning
        pkgs.kdePackages.qtbase
        pkgs.kdePackages.qtdeclarative
        pkgs.kdePackages.qtmultimedia
        pkgs.kdePackages.qtsensors
        pkgs.kdePackages.qtsvg
        pkgs.kdePackages.qtwayland
        pkgs.kdePackages.qt5compat
        pkgs.kdePackages.qtimageformats
        pkgs.kdePackages.kirigami.unwrapped
        pkgs.kdePackages.syntax-highlighting
      ]}" \
            --prefix QT_PLUGIN_PATH : "${lib.makeSearchPath "lib/qt-6/plugins" [
        pkgs.kdePackages.qtbase
        pkgs.kdePackages.qtsvg
        pkgs.kdePackages.qtwayland
        pkgs.kdePackages.qtimageformats
        pkgs.qt6Packages.qt6ct
      ]}" \
            --set QT_QPA_PLATFORMTHEME "qt6ct" \
            --prefix PATH : "${pythonEnv}/bin" \
            --run 'export XDG_DATA_DIRS=$HOME/.nix-profile/share:$HOME/.local/state/nix/profiles/home-manager/home-path/share:/etc/profiles/per-user/$USER/share:/run/current-system/sw/share:${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}:$XDG_DATA_DIRS'
        fi
      done
    '';
  };
in {
  home.packages = with pkgs; [
    # QuickShell
    wrappedQuickshell

    # Material Symbols font (for icon glyphs)
    material-symbols

    # Core utilities required by end-4 bar
    cava
    lxqt.pavucontrol-qt
    libdbusmenu-gtk3
    playerctl
    brightnessctl
    ddcutil
    bc
    cliphist
    libqalculate
    jq

    # GUI applications
    foot
    fuzzel
    matugen
    mpvpaper
    swappy
    wf-recorder
    hyprshot
    wlogout

    # System utilities
    tesseract
    slurp
    upower
    wtype
    ydotool
    swww
    translate-shell
    imagemagick
    libnotify
    grim

    # Wayland/Hyprland
    hyprsunset
    wl-clipboard

    # Development libraries
    libsoup_3
    libportal-gtk4
    gobject-introspection
    sassc

    # Themes and icons (for the bar UI)
    adw-gtk3
    papirus-icon-theme
    adwaita-icon-theme
    hicolor-icon-theme

    # Python environment
    pythonEnv

    # Qt packages for QuickShell
    kdePackages.qt5compat
    kdePackages.qtbase
    kdePackages.qtdeclarative
    kdePackages.qtimageformats
    kdePackages.qtmultimedia
    kdePackages.qtpositioning
    kdePackages.qtsensors
    kdePackages.qtsvg
    kdePackages.qtwayland
    kdePackages.kirigami
    kdePackages.polkit-kde-agent-1
    qt6Packages.qt6ct

    # Additional utilities
    libsecret
  ];

  # Don't copy config to ~/.config - run directly from nix repo source
  # This allows version control and editing without readonly issues

  home.file.".local/state/quickshell/user/generated/colors.json".text = let
    colors = config.lib.stylix.colors;
  in
    builtins.toJSON {
      # Material Design 3 color scheme generated from stylix base16
      primary = "#${colors.base0D}";
      on_primary = "#${colors.base00}";
      primary_container = "#${colors.base01}";
      on_primary_container = "#${colors.base0D}";
      secondary = "#${colors.base0D}";
      on_secondary = "#${colors.base00}";
      secondary_container = "#${colors.base01}";
      on_secondary_container = "#${colors.base0D}";
      tertiary = "#${colors.base0D}";
      on_tertiary = "#${colors.base00}";
      tertiary_container = "#${colors.base01}";
      on_tertiary_container = "#${colors.base0D}";
      error = "#${colors.base08}";
      on_error = "#${colors.base00}";
      error_container = "#${colors.base01}";
      on_error_container = "#${colors.base08}";
      background = "#${colors.base00}";
      on_background = "#${colors.base05}";
      surface = "#${colors.base01}";
      on_surface = "#${colors.base05}";
      surface_variant = "#${colors.base02}";
      on_surface_variant = "#${colors.base04}";
      outline = "#${colors.base03}";
      outline_variant = "#${colors.base02}";
      shadow = "#${colors.base00}";
      scrim = "#${colors.base00}";
      inverse_surface = "#${colors.base06}";
      inverse_on_surface = "#${colors.base00}";
      inverse_primary = "#${colors.base0D}";
    };

  # Config file to disable wallpaper color extraction (initial setup only)
  # After first run, you can edit this file directly - it won't be overwritten
  home.activation.quickshellConfig = config.lib.dag.entryAfter ["writeBoundary"] ''
        CONFIG_FILE="$HOME/.config/illogical-impulse/config.json"
        if [ ! -f "$CONFIG_FILE" ]; then
          $DRY_RUN_CMD mkdir -p "$(dirname "$CONFIG_FILE")"
          $DRY_RUN_CMD cat > "$CONFIG_FILE" << 'EOF'
    {
      "ai": {
        "defaultGptProvider": "ollama",
        "enhancements": false,
        "taskbar_scroll_switch": false
      },
      "appearance": {
        "useWallpaperColors": false
      }
    }
    EOF
        fi
  '';

  # Symlink WhiteSur icons so Qt can find them
  home.file.".local/share/icons/WhiteSur".source = "${pkgs.whitesur-icon-theme.override {
    boldPanelIcons = true;
    alternativeIcons = true;
  }}/share/icons/WhiteSur";

  # Session variables for QuickShell
  home.sessionVariables = {
    # Point to source in nix repo so you can edit and version control changes
    qsConfig = "${config.home.homeDirectory}/code/ynix/modules-home/system/quickshell";
    # Tell Qt to use WhiteSur icons
    QT_ICON_THEME = "WhiteSur";
  };
}
