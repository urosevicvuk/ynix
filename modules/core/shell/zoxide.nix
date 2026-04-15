{
  flake.homeManagerModules.base = { ... }: {
        programs.zoxide = {
          enable = true;
          enableZshIntegration = true;
        };
  };
}
