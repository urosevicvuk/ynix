{
  self,
  inputs,
  ...
}: {
  flake.nixosModules.tmux = {...}: {
    home-manager.sharedModules = [self.homeModules.tmux];
  };

  flake.homeModules.tmux = {
    pkgs,
    lib,
    config,
    ...
  }: let
    theme = config.theme.active;
  in {
    programs = {
      tmux = {
        enable = true;
        mouse = true;
        shell = lib.getExe pkgs.zsh;
        prefix = "C-Space";

        terminal = "kitty";
        keyMode = "vi";

        extraConfig = ''
          set-option -g status-position top
          set -g base-index 1
          set -g automatic-rename on
          set -g detach-on-destroy off
          set -gq allow-passthrough on

          bind-key Enter display-popup -E -w 80% -h 70% -d '#{pane_current_path}' -T 'Sesh' tv sesh
        '';

        plugins = with pkgs.tmuxPlugins; [
          vim-tmux-navigator
          sensible
          {
            plugin = inputs.tmux-powerkit.packages.${pkgs.system}.default;
            extraConfig = ''
              set -g @powerkit_theme "${theme.tmux-powerkit-theme}"
              set -g @powerkit_theme_variant "${theme.tmux-powerkit-variant}"

              set -g @powerkit_separator_style "normal"
              set -g @powerkit_edge_separator_style "normal"
              set -g @powerkit_elements_spacing "true"

              set -g @powerkit_status_interval "1"

              set -g @powerkit_plugins "datetime,hostname"
            '';
          }
          {
            plugin = yank;
            extraConfig = ''
              set -g @yank_selection_mouse 'clipboard'
              set -g @yank_action 'copy-pipe'
            '';
          }
          {
            plugin = resurrect;
            extraConfig = ''
              set -g @resurrect-capture-pane-contents 'on'
              set -g @resurrect-processes 'ssh psql "~nvim->nvim" "~vim->vim"'
              set -g @resurrect-strategy-vim 'session'
              set -g @resurrect-strategy-nvim 'session'
            '';
          }
          {
            plugin = continuum;
            extraConfig = ''
              set -g @continuum-restore 'on'
              set -g @continuum-save-interval '10'
            '';
          }
        ];
      };
    };
  };
}
