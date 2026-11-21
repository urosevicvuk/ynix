{self, ...}: {
  flake.nixosModules.dev.imports = [self.nixosModules.nix-ld];

  flake.nixosModules.nix-ld = {pkgs, ...}: {
    programs.nix-ld = {
      enable = true;

      libraries = with pkgs; [
        glib
        libGL
        libxkbcommon
        icu
        alsa-lib
        nss
        nspr
      ];
    };
  };
}
