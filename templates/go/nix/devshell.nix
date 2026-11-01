{
  perSystem = {
    config,
    pkgs,
    ...
  }: {
    devShells.default = pkgs.mkShell {
      packages = with pkgs; [
        go
        gopls
        gotools # goimports, among others
        delve
        golangci-lint

        # Standalone binaries belong here. Anything the code *imports* goes in
        # go.mod instead.
      ];

      # Nix's default _FORTIFY_SOURCE breaks the unoptimised cgo builds delve
      # asks for.
      hardeningDisable = ["fortify"];

      env = {
        # Pin go to the toolchain this flake locked, and forbid it from quietly
        # downloading the one a go.mod's `toolchain` line asks for.
        GOTOOLCHAIN = "local";
      };
    };

    # nixbot builds only .#checks, while `nix flake check` also builds the
    # devshell. Exporting it keeps the two equivalent.
    checks.devshell = config.devShells.default;
  };
}
