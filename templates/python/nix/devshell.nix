{
  perSystem = {
    pkgs,
    lib,
    ...
  }: let
    python = pkgs.python313;

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

      shellHook = ''
        if [ -f pyproject.toml ]; then
          uv sync --quiet
          source .venv/bin/activate
        else
          echo "No pyproject.toml yet — run 'uv init', then re-enter the shell."
        fi
      '';
    };
  };
}
