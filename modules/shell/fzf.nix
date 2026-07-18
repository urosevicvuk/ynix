{self, ...}: {
  # Self-registers into the `shell` group (merged with the other shell modules).
  flake.nixosModules.shell.imports = [self.nixosModules.fzf];

  flake.nixosModules.fzf = {...}: {
    home-manager.sharedModules = [self.homeModules.fzf];
  };

  flake.homeModules.fzf = {
    lib,
    config,
    ...
  }: let
    theme = config.theme.active;
  in {
    programs.fzf = {
      enable = true;
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
        # Tab accepts the selection instead of toggling multi-select
        # (Shift-Tab still toggles); moving is Ctrl-N/Ctrl-P. fzf-tab doesn't
        # inherit this — it sets its own binds on the CLI, see zsh.nix.
        "--bind=tab:accept"
      ];
    };
  };
}
