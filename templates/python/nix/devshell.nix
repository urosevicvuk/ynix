{
  perSystem = {
    config,
    pkgs,
    lib,
    uv2nix,
    ...
  }: let
    inherit (uv2nix) python;

    # Wheels installed by uv dlopen these at runtime. A Nix-provided interpreter
    # is already linked correctly, so it bypasses the nix-ld shim entirely — the
    # wheels' own .so files still have to find these, hence LD_LIBRARY_PATH.
    # Add to this list when an import fails with "libfoo.so: cannot open shared
    # object file".
    wheelLibs = with pkgs; [
      stdenv.cc.cc.lib # libstdc++
      zlib
    ];
  in {
    devShells.default = pkgs.mkShell {
      packages = [
        python
        pkgs.uv
        pkgs.ruff # also what nix fmt runs; here for the editor

        # Standalone binaries belong here. Anything the project *imports* goes
        # in pyproject.toml instead, so it lands in the venv.
      ];

      env = {
        # Pin uv to the interpreter this flake locked, and forbid it from
        # quietly downloading one of its own.
        UV_PYTHON = python.interpreter;
        UV_PYTHON_DOWNLOADS = "never";

        LD_LIBRARY_PATH = lib.makeLibraryPath wheelLibs;
      };
    };

    # nixbot builds only .#checks, while `nix flake check` also builds the
    # devshell. Exporting it keeps the two equivalent.
    checks.devshell = config.devShells.default;
  };
}
