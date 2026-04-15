{
  flake.homeManagerModules.base = { ... }: {
        programs.nix-index = {
          enable = true;
          enableZshIntegration = true;
        };
  };
}
