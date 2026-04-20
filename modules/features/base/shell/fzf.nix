{self, ...}: {
  flake.nixosModules.fzf = {...}: {
    home-manager.sharedModules = [self.homeModules.fzf];
  };

  flake.homeModules.fzf = {lib, ...}: {
    programs.fzf = {
      enable = true;
      colors = lib.mkForce {
        "fg+" = self.theme.base0D;
        "bg+" = "-1";
        "fg" = self.theme.base05;
        "bg" = "-1";
        "prompt" = self.theme.base03;
        "pointer" = self.theme.base0D;
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
      tmux.enableShellIntegration = true;
    };
  };
}
