{lib, ...}: let
  vendorHash = lib.fakeHash;

  hasProject = builtins.pathExists ../go.mod;
  hasDeps = builtins.pathExists ../go.sum;

  pname = baseNameOf (lib.head (
    builtins.match ".*module[[:space:]]+([^[:space:]]+).*" (builtins.readFile ../go.mod)
  ));
in {
  perSystem = {pkgs, ...}:
    lib.optionalAttrs hasProject {
      packages.default = pkgs.buildGoModule {
        inherit pname;
        version = "0.1.0";

        src = lib.fileset.toSource {
          root = ../.;
          fileset = lib.fileset.difference ../. (lib.fileset.unions [
            ../nix
            ../flake.nix
            (lib.fileset.maybeMissing ../flake.lock)
            (lib.fileset.maybeMissing ../.github)
          ]);
        };

        vendorHash =
          if hasDeps
          then vendorHash
          else null;

        overrideModAttrs = _: {
          name = "${pname}-go-modules-${builtins.hashFile "sha256" ../go.sum}";
        };

        proxyVendor = true;

        meta.mainProgram = pname;
      };
    };
}
