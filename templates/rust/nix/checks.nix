{lib, ...}: {
  perSystem = {
    config,
    crane,
    ...
  }: let
    inherit (crane) craneLib commonArgs cargoArtifacts;
  in {
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
