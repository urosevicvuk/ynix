{
  flake.modules.homeManager.core = [
    (
      { ... }:
      {
        programs.zoxide = {
          enable = true;
          enableZshIntegration = true;
        };
      }
    )
  ];
}
