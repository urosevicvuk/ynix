{self, ...}: {
  flake.nixosModules.starship = {...}: {
    home-manager.sharedModules = [self.homeModules.starship];
  };

  flake.homeModules.starship = {
    lib,
    config,
    ...
  }: let
    theme = config.theme.active;
    accent = theme.base0D;
    background-alt = theme.base01;
  in {
    programs.starship = {
      enable = true;
      enableNushellIntegration = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      settings = {
        add_newline = true;
        format = lib.concatStrings [
          "$nix_shell"
          "$kubernetes"
          "$hostname"
          "$directory"
          "$git_branch"
          "$git_state"
          "$git_status"
          "$line_break"
          "$character"
        ];
        directory.style = accent;
        nix_shell = {
          format = "[$symbol]($style) ";
          symbol = "🐚";
          style = "";
        };
        kubernetes = {
          disabled = false;
          format = "[$symbol$context( \($namespace\))]($style) in ";
          detect_env_vars = ["KUBECONFIG"];
        };
        git_branch = {
          symbol = "[](${background-alt}) ";
          style = "fg:${accent} bg:${background-alt}";
          format = "on [$symbol$branch]($style)[](${background-alt}) ";
        };
        git_status = {
          format = "[[(*$conflicted$untracked$modified$staged$renamed$deleted)](218)($ahead_behind$stashed)]($style)";
          style = "cyan";
          conflicted = "";
          renamed = "";
          deleted = "";
          stashed = "≡";
        };
        git_state = {
          format = "([$state( $progress_current/$progress_total)]($style)) ";
          style = "bright-black";
        };
        cmd_duration = {
          format = "[$duration]($style)";
        };
        character = {
          success_symbol = "[❯](${accent})";
          error_symbol = "[❯](red)";
          vimcmd_symbol = "[❮](cyan)";
        };
      };
    };
  };
}
