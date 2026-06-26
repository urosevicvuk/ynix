{...}: {
  flake.nixosModules.opencloud = {pkgs, ...}: {
    environment.systemPackages = [
      (pkgs.symlinkJoin {
        name = "opencloud-desktop";
        paths = [pkgs.opencloud-desktop];
        nativeBuildInputs = [pkgs.makeWrapper];
        # OpenCloud mirrors QT_STYLE_OVERRIDE onto its QtQuick Controls style, but
        # Kvantum ships no Quick style, so the QML `import kvantum` in the settings
        # dialog hits a qFatal and the app aborts on launch. Force Fusion just for
        # this app; the rest of the system keeps Kvantum. The .desktop Exec is a
        # bare `opencloud`, so this wrapper also catches app-launcher starts.
        postBuild = ''
          wrapProgram $out/bin/opencloud --set QT_STYLE_OVERRIDE Fusion
        '';
      })
    ];
  };
}
