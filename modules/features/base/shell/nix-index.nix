{
  flake.homeModules.base = {...}: {
    programs.nix-index = {
      enable = true;
      enableZshIntegration = true;
    };
  };
}
