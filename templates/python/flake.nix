{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = inputs @ {flake-parts, ...}:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = ["x86_64-linux" "aarch64-linux"];
      perSystem = {pkgs, ...}: let
        python = pkgs.python3;
      in {
        devShells.default = pkgs.mkShell {
          packages = [
            (python.withPackages (ps: with ps; [pip setuptools]))
            pkgs.ruff
            pkgs.uv
          ];
          shellHook = ''
            # Auto-create venv if it doesn't exist
            test -d .venv || ${python}/bin/python -m venv .venv
            source .venv/bin/activate
          '';
        };
      };
    };
}
