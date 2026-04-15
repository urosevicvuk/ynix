{
  flake.homeManagerModules.core = { pkgs, ... }: {
        programs.tmux = {
          enable = true;
          mouse = true;
          shell = "${pkgs.zsh}/bin/zsh";
          prefix = "C-Space";
          terminal = "kitty";
          keyMode = "vi";
          extraConfig = ''
            bind-key | split-window -h -c "#{pane_current_path}"
            bind-key _ split-window -v -c "#{pane_current_path}"
            bind-key H swap-pane -U
            bind-key J swap-pane -D
            bind-key K swap-pane -U
            bind-key L swap-pane -D
            bind-key -r < resize-pane -L 5
            bind-key -r > resize-pane -R 5
            set-option -g status-position top
            set -g base-index 1
            setw -g pane-base-index 1
            set -gq allow-passthrough on
            bind-key x kill-pane
            bind-key ` run-shell "tmux neww tmux-sessionizer"
            set-option -g @continuum-restore 'on'
            set -g automatic-rename on
          '';
          plugins = with pkgs.tmuxPlugins; [
            vim-tmux-navigator
            sensible
            tmux-which-key
            {
              plugin = gruvbox;
              extraConfig = ''
                set -g @statusbar-alpha 'true'
                set -g @right-status-x '%d.%m.%Y'
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
                set -g @resurrect-strategy-vim 'session'
                set -g @resurrect-strategy-nvim 'session'
                set -g @resurrect-capture-pane-contents 'on'
              '';
            }
            {
              plugin = continuum;
              extraConfig = ''
                set -g @continuum-restore 'on'
                set -g @continuum-boot 'on'
                set -g @continuum-save-interval '10'
              '';
            }
          ];
        };
        home.packages = [ ];
  };
}
