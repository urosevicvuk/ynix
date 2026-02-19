{
  programs = {
    direnv = {
      enable = true;
      silent = true;
      enableZshIntegration = true;
      stdlib = ''
        export SSH_AUTH_SOCK="$SSH_AUTH_SOCK"
        export GIT_CONFIG_GLOBAL="$HOME/.gitconfig"
      '';

      nix-direnv.enable = true;
    };
  };
}
