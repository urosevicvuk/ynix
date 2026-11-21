{
  perSystem = {
    config,
    pkgs,
    lib,
    uv2nix,
    ...
  }: let
    inherit (uv2nix) python;

    wheelLibs = with pkgs; [
      stdenv.cc.cc.lib
      zlib
    ];
  in {
    devShells.default = pkgs.mkShell {
      packages = [
        python
        pkgs.uv
        pkgs.ruff
      ];

      env = {
        UV_PYTHON = python.interpreter;
        UV_PYTHON_DOWNLOADS = "never";

        LD_LIBRARY_PATH = lib.makeLibraryPath wheelLibs;
      };
    };

    checks.devshell = config.devShells.default;
  };
}
