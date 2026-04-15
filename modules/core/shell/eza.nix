{
  flake.homeManagerModules.core = { ... }: {
        programs.eza = {
          enable = true;
          icons = "auto";
          extraOptions = [
            "--group-directories-first"
            "--no-quotes"
            "--git-ignore"
            "--icons=always"
          ];
        };
  };
}
