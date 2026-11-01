{
  perSystem = {
    config,
    crane,
    pkgs,
    lib,
    ...
  }: {
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

      # The native libraries from nix/package.nix, so cargo here links against
      # the same ones the Nix build does.
      buildInputs = crane.nativeLibs;

      env = {
        # rust-analyzer needs the standard library's source to index it, which
        # rustup would normally provide.
        RUST_SRC_PATH = "${pkgs.rustPlatform.rustLibSrc}";

        # Crates that dlopen at runtime rather than linking need this too.
        LD_LIBRARY_PATH = lib.makeLibraryPath crane.nativeLibs;
      };
    };

    # nixbot builds only .#checks, while `nix flake check` also builds the
    # devshell. Exporting it keeps the two equivalent.
    checks.devshell = config.devShells.default;
  };
}
