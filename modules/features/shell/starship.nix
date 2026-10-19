{self, ...}: {
  # Self-registers into the `shell` group (merged with the other shell modules).
  flake.nixosModules.shell.imports = [self.nixosModules.starship];

  flake.nixosModules.starship = {...}: {
    home-manager.sharedModules = [self.homeModules.starship];
  };

  flake.homeModules.starship = {
    lib,
    pkgs,
    config,
    ...
  }: let
    theme = config.theme.active;
    accent = theme.base0D;
    background-alt = theme.base01;
    cfg = config.programs.starship;
  in {
    programs.starship = {
      enable = true;
      enableNushellIntegration = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      settings = {
        add_newline = true;
        format = lib.concatStrings [
          "$kubernetes"
          "$nix_shell"
          "$container"
          "$hostname"
          "$directory"
          "$vcs"
          #"$git_branch"
          #"$git_state"
          #"$git_status"
          "$cmd_duration"
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
          disabled = true;
          format = "[$symbol$context( \($namespace\))]($style) in ";
        };
        git_branch = {
          symbol = "[](${background-alt}) ";
          style = "fg:${accent} bg:${background-alt}";
          format = "on [$symbol$branch]($style)[](${background-alt}) ";
        };
        git_status = {
          format = "[[(*$conflicted$untracked$modified$staged$renamed$deleted)](218)($ahead_behind$stashed)]($style) ";
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
          format = "[$duration]($style) ";
        };
        character = {
          success_symbol = "[❯](${accent})";
          error_symbol = "[❯](red)";
          vimcmd_symbol = "[❮](cyan)";
        };
      };
    };

    # Nushell never redraws the starship prompt on a vi mode switch, only its
    # own PROMPT_INDICATOR_VI_* — so there $character is dropped and those
    # indicators take over, mirroring success/error/vimcmd above.
    programs.nushell = {
      environmentVariables.STARSHIP_CONFIG = toString ((pkgs.formats.toml {}).generate "starship-nushell.toml" (
        cfg.settings // {format = lib.removeSuffix "$character" cfg.settings.format;}
      ));
      extraEnv = ''
        $env.PROMPT_INDICATOR_VI_INSERT = {||
          if $env.LAST_EXIT_CODE == 0 { $"(ansi {fg: '${accent}'})❯(ansi reset) " } else { $"(ansi red)❯(ansi reset) " }
        }
        $env.PROMPT_INDICATOR_VI_NORMAL = {|| $"(ansi cyan)❮(ansi reset) " }
      '';
      # Nushell trims the final newline off captured external output, which
      # eats the trailing $line_break; put it back after starship's init.
      extraConfig = lib.mkAfter ''
        let starship_prompt = $env.PROMPT_COMMAND
        $env.PROMPT_COMMAND = {|| (do $starship_prompt) + "\n" }
      '';
    };
  };
}
