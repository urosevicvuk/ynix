# What `nix flake check` and nixbot verify, besides formatting (treefmt) and
# the devshell. Each check is a derivation that builds in the sandbox from the
# same locked inputs, so a pass here is a pass in CI and the other way round.
{lib, ...}: {
  perSystem = {
    config,
    crane,
    ...
  }: let
    inherit (crane) craneLib commonArgs cargoArtifacts;
  in {
    # Only once nix/package.nix defines the package, i.e. after `cargo init`.
    checks = lib.mkIf (config.packages ? default) {
      build = config.packages.default;

      clippy = craneLib.cargoClippy (commonArgs
        // {
          inherit cargoArtifacts;
          cargoClippyExtraArgs = "--all-targets -- --deny warnings";
        });

      test = craneLib.cargoTest (commonArgs // {inherit cargoArtifacts;});
    };
  };
}
