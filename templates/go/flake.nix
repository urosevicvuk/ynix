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
          default = pkgs.buildGoModule {
            pname = name;
            inherit version;
            src = ./.;
            vendorHash = null; # update after first build
          };
          container = pkgs.dockerTools.buildLayeredImage {
            inherit name;
            tag = version;
            contents = [self'.packages.default];
            config.Cmd = ["/bin/${name}"];
          };
        };

        devShells.default = pkgs.mkShell {
          packages = with pkgs; [go gopls golangci-lint delve air];
        };
      };
    };
}
