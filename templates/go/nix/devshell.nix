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
        gotools
        delve
        golangci-lint
      ];

      hardeningDisable = ["fortify"];

      env = {
        GOTOOLCHAIN = "local";
      };
    };

    checks.devshell = config.devShells.default;
  };
}
