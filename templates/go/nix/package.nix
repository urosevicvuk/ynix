# The project built by Nix: `nix build` puts its binaries in ./result/bin.
# Nothing is defined until `go mod init` has created go.mod, so the template
# also evaluates before there's a project in it.
{lib, ...}: let
  # The hash of every module go.sum names, fetched in a separate step that is
  # allowed network access. Whenever go.sum changes, `nix build` fails with a
  # hash mismatch: paste its `got:` value here. That makes a dependency change
  # a deliberate edit, like updating a lock file. Unused until there's a go.sum.
  vendorHash = lib.fakeHash;

  hasProject = builtins.pathExists ../go.mod;
  hasDeps = builtins.pathExists ../go.sum;

  # The last element of go.mod's module path: github.com/you/foo → foo.
  pname = baseNameOf (lib.head (
    builtins.match ".*module[[:space:]]+([^[:space:]]+).*" (builtins.readFile ../go.mod)
  ));
in {
  perSystem = {pkgs, ...}:
    lib.optionalAttrs hasProject {
      packages.default = pkgs.buildGoModule {
        inherit pname;
        version = "0.1.0";

        # Everything git tracks except the Nix and CI files, so editing those
        # doesn't rebuild the Go code.
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

        # A fetch is looked up by its name and hash alone, so with a stale hash
        # Nix would quietly reuse the old modules. go.sum's own hash in the
        # name makes every change to it fetch again and check the hash.
        overrideModAttrs = _: {
          name = "${pname}-go-modules-${builtins.hashFile "sha256" ../go.sum}";
        };

        # Fetch the modules as a Go module cache rather than a vendor/
        # directory. That's what lets the tidy check in nix/checks.nix run
        # offline.
        proxyVendor = true;

        # buildGoModule runs `go test ./...` after compiling, so a failing test
        # fails the build.

        meta.mainProgram = pname;
      };
    };
}
