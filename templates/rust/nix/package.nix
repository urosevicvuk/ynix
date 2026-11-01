# The project built by Nix, with crane: `nix build` puts its binaries in
# ./result/bin. Nothing is built until `cargo init` has created Cargo.toml, so
# the template also evaluates before there's a project in it.
{
  inputs,
  lib,
  ...
}: {
  perSystem = {pkgs, ...}: let
    craneLib = inputs.crane.mkLib pkgs;

    # Native libraries that crates link against through build scripts (the
    # *-sys crates). The devshell gets them too. Add to this list when a build
    # fails with "could not find system library 'foo'" or "Package foo was not
    # found in the pkg-config search path".
    nativeLibs = with pkgs; [
      # openssl
    ];

    commonArgs = {
      # Only what cargo reads (.rs, Cargo.toml, Cargo.lock), so editing
      # anything else doesn't rebuild. Files pulled in with include_str! or
      # similar need adding here.
      src = craneLib.cleanCargoSource ../.;
      strictDeps = true;

      nativeBuildInputs = [pkgs.pkg-config];
      buildInputs = nativeLibs;
    };

    # Every dependency in Cargo.lock, compiled once on its own. The package
    # and every check reuse it, so a change to your code doesn't rebuild them.
    # Cargo.lock has the hash of each crate, so unlike Go there's no hash to
    # maintain here.
    cargoArtifacts = craneLib.buildDepsOnly commonArgs;
  in {
    # Shared with nix/checks.nix and nix/devshell.nix.
    _module.args.crane = {inherit craneLib nativeLibs commonArgs cargoArtifacts;};

    packages = lib.mkIf (builtins.pathExists ../Cargo.toml) {
      default = craneLib.buildPackage (commonArgs
        // {
          inherit cargoArtifacts;
          # The tests are their own check in nix/checks.nix.
          doCheck = false;
        });
    };
  };
}
