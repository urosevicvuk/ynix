{self, ...}: {
  flake.nixosModules.zsh = {...}: {
    home-manager.sharedModules = [self.homeModules.zsh];
  };

  flake.homeModules.zsh = {
    pkgs,
    lib,
    config,
    ...
  }: {
    home.sessionPath = ["$HOME/go/bin"];
    programs.zsh = {
      enable = true;
      enableCompletion = false;
      profileExtra = lib.optionalString (config.home.sessionPath != []) ''
        export PATH="$PATH''${PATH:+:}${lib.concatStringsSep ":" config.home.sessionPath}"
      '';
      shellAliases = {
        ls = "eza --icons=always --no-quotes -l";
        tree = "eza --icons=always --tree --no-quotes";
        mkdir = "mkdir -p";
        rm = "${pkgs.rmtrash}/bin/rmtrash";
        rmdir = "${pkgs.rmtrash}/bin/rmdirtrash";
        nix-shell = "nix-shell --command zsh";
        gitui = "lazygit";
      };
    };
  };
}
