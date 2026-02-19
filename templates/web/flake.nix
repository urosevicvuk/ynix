{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = inputs @ {flake-parts, ...}:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = ["x86_64-linux" "aarch64-linux"];
      perSystem = {
        pkgs,
        self',
        ...
      }: let
        name = "myapp"; # change this
        version = "0.1.0";
      in {
        packages = {
          default = pkgs.buildNpmPackage {
            pname = name;
            inherit version;
            src = ./.;
            npmDepsHash = ""; # update after first build
          };
          container = pkgs.dockerTools.buildLayeredImage {
            inherit name;
            tag = version;
            contents = [self'.packages.default];
          };
        };

        devShells.default = pkgs.mkShell {
          packages = with pkgs; [nodejs pnpm typescript biome];
        };
      };
    };
}
