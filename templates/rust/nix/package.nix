{
  inputs,
  lib,
  ...
}: {
  perSystem = {pkgs, ...}: let
    craneLib = inputs.crane.mkLib pkgs;

    nativeLibs = with pkgs; [
      # openssl
    ];

    commonArgs = {
      src = craneLib.cleanCargoSource ../.;
      strictDeps = true;

      nativeBuildInputs = [pkgs.pkg-config];
      buildInputs = nativeLibs;
    };

    cargoArtifacts = craneLib.buildDepsOnly commonArgs;
  in {
    _module.args.crane = {inherit craneLib nativeLibs commonArgs cargoArtifacts;};

    packages = lib.mkIf (builtins.pathExists ../Cargo.toml) {
      default = craneLib.buildPackage (commonArgs
        // {
          inherit cargoArtifacts;
          doCheck = false;
        });
    };
  };
}
