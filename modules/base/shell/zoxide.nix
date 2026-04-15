{
  flake.homeModules.base = {...}: {
    programs.zoxide = {
      enable = true;
      enableZshIntegration = true;
    };
  };
}
