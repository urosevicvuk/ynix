{
  flake.modules.homeManager.core = [
    (
      { ... }:
      {
        programs.nix-index = {
          enable = true;
          enableZshIntegration = true;
        };
      }
    )
  ];
}
