{self, ...}: {
  # Self-registers into the `dev` group (merged with the other dev modules).
  flake.nixosModules.dev.imports = [self.nixosModules.nix-ld];

  # Puts a shim at /lib64/ld-linux-x86-64.so.2 so downloaded, non-Nix binaries
  # (pip/uv wheels, prebuilt LSP servers, npm native tools, ...) can start at
  # all. The shim reads NIX_LD / NIX_LD_LIBRARY_PATH and hands off to the real
  # glibc loader in the store.
  #
  # Note: this only fires when the kernel launches a foreign executable. A
  # Nix-provided interpreter is already linked correctly and bypasses the shim,
  # so libraries it dlopens still need a scoped LD_LIBRARY_PATH in that
  # project's devshell.
  flake.nixosModules.nix-ld = {pkgs, ...}: {
    programs.nix-ld = {
      enable = true;

      # Merged with the upstream defaults, which already cover zlib, zstd,
      # stdenv.cc.cc, curl, openssl, xz, systemd and friends.
      libraries = with pkgs; [
        glib
        libGL
        libxkbcommon
        icu
        # Common needs of prebuilt Electron/GUI tooling.
        alsa-lib
        nss
        nspr
      ];
    };
  };
}
