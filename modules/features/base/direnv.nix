{self, ...}: {
  flake.nixosModules.direnv = {...}: {
    home-manager.sharedModules = [self.homeModules.direnv];
  };

  flake.homeModules.direnv = {...}: {
    programs.direnv = {
      enable = true;
      silent = true;
      stdlib = ''
        export SSH_AUTH_SOCK="$SSH_AUTH_SOCK"
        export GIT_CONFIG_GLOBAL="$HOME/.config/git/config"
      '';
      nix-direnv.enable = true;
    };
  };
}
