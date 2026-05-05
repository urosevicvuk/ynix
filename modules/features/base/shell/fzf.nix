{self, ...}: {
  flake.nixosModules.fzf = {...}: {
    home-manager.sharedModules = [self.homeModules.fzf];
  };

  flake.homeModules.fzf = {lib, config, ...}: let
    theme = config.theme.active;
  in {
    programs.fzf = {
      enable = true;
      tmux.enableShellIntegration = true;
      colors = lib.mkForce {
        "fg+" = theme.base0D;
        "bg+" = "-1";
        "fg" = theme.base05;
        "bg" = "-1";
        "prompt" = theme.base03;
        "pointer" = theme.base0D;
      };
      defaultOptions = [
        "--margin=1"
        "--layout=reverse"
        "--border=none"
        "--info='hidden'"
        "--header=''"
        "--prompt='/ '"
        "-i"
        "--no-bold"
      ];
    };
  };
}
