{
  flake.homeManagerModules.base = {...}: {
    programs.direnv = {
      enable = true;
      silent = true;
      enableZshIntegration = true;
      stdlib = ''
        export SSH_AUTH_SOCK="$SSH_AUTH_SOCK"
        export GIT_CONFIG_GLOBAL="$HOME/.config/git/config"
      '';
      nix-direnv.enable = true;
    };
  };
}
