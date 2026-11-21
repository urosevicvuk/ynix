{self, ...}: {
  flake.nixosModules.apps.imports = [self.nixosModules.opencloud];

  flake.nixosModules.opencloud = {pkgs, ...}: {
    environment.systemPackages = [
      (pkgs.symlinkJoin {
        name = "opencloud-desktop";
        paths = [pkgs.opencloud-desktop];
        nativeBuildInputs = [pkgs.makeWrapper];
        postBuild = ''
          wrapProgram $out/bin/opencloud --set QT_STYLE_OVERRIDE Fusion
        '';
      })
    ];
  };
}
