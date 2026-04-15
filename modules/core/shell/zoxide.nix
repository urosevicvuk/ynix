{
  flake.homeManagerModules.core = { ... }: {
        programs.zoxide = {
          enable = true;
          enableZshIntegration = true;
        };
  };
}
