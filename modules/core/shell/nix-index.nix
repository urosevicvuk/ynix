{
  flake.homeManagerModules.core = { ... }: {
        programs.nix-index = {
          enable = true;
          enableZshIntegration = true;
        };
  };
}
