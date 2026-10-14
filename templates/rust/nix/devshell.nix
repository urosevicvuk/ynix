{
  perSystem = {
    pkgs,
    lib,
    ...
  }: let
    # Native libraries that crates link against through build scripts (the
    # *-sys crates). pkg-config finds them via the buildInputs below. Add to
    # this list when a build fails with "could not find system library 'foo'"
    # or "Package foo was not found in the pkg-config search path".
    nativeLibs = with pkgs; [
      # openssl
    ];
  in {
    devShells.default = pkgs.mkShell {
      packages = with pkgs; [
        # The toolchain comes from nixpkgs and is pinned by flake.lock, so
        # rustup is never involved.
        cargo
        rustc
        clippy
        rustfmt
        rust-analyzer

        pkg-config

        # Standalone binaries belong here. Anything the code *uses* is a crate
        # and goes in Cargo.toml instead.
      ];

      buildInputs = nativeLibs;

      env = {
        # rust-analyzer needs the standard library's source to index it, which
        # rustup would normally provide.
        RUST_SRC_PATH = "${pkgs.rustPlatform.rustLibSrc}";

        # Crates that dlopen at runtime rather than linking need this too.
        LD_LIBRARY_PATH = lib.makeLibraryPath nativeLibs;
      };

      shellHook = ''
        if [ ! -f Cargo.toml ]; then
          echo "No Cargo.toml yet — run 'cargo init', then re-enter the shell."
        fi
      '';
    };
  };
}
