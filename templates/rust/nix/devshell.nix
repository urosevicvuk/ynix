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
        cargo
        rustc
        clippy
        rustfmt
        rust-analyzer

        pkg-config
      ];

      buildInputs = crane.nativeLibs;

      env = {
        RUST_SRC_PATH = "${pkgs.rustPlatform.rustLibSrc}";

        LD_LIBRARY_PATH = lib.makeLibraryPath crane.nativeLibs;
      };
    };

    checks.devshell = config.devShells.default;
  };
}
