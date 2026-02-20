# Tmux is a terminal multiplexer that allows you to run multiple terminal sessions in a single window.
{
  pkgs,
  config,
  ...
}:
#let
#  Config = pkgs.writeShellScriptBin "Config" ''
#    SESSION="Nixy Config"
#
#    tmux has-session -t "$SESSION" 2>/dev/null
#
#    if [ $? == 0 ]; then
#      tmux attach -t "$SESSION"
#      exit 0
#    fi
#
#    tmux new-session -d -s "$SESSION"
#    tmux send-keys -t "$SESSION" "sleep 0.2 && clear && cd ~/.config/nixos/ && vim" C-m
#
#    tmux new-window -t "$SESSION" -n "nixy"
#    tmux send-keys -t "$SESSION":1 "sleep 0.2 && clear && cd ~/.config/nixos/ && nixy loop" C-m
#
#    tmux new-window -t "$SESSION" -n "lazygit"
#    tmux send-keys -t "$SESSION":2 "sleep 0.2 && clear && cd ~/.config/nixos/ && lazygit" C-m
#
#    tmux select-window -t "$SESSION":0
#    tmux select-pane -t 0
#    tmux attach -t "$SESSION"
#  '';
#in
{
  programs.tmux = {
    enable = true;
    mouse = true;
    shell = "${pkgs.zsh}/bin/zsh";
    prefix = "C-Space";
    terminal = "${config.var.terminal}";
    keyMode = "vi";

    extraConfig = ''
      # vim-tmux-navigator plugin handles C-h/j/k/l automatically
      # No need to bind or unbind - let the plugin do its magic

      # Better split pane bindings (intuitive and opens in current directory)
      bind-key | split-window -h -c "#{pane_current_path}"
      bind-key _ split-window -v -c "#{pane_current_path}"

      # Pane swapping with H/J/K/L
      bind-key H swap-pane -U
      bind-key J swap-pane -D
      bind-key K swap-pane -U
      bind-key L swap-pane -D

      # Horizontal resize with < and > (5 cells at a time)
      bind-key -r < resize-pane -L 5
      bind-key -r > resize-pane -R 5

      set-option -g status-position top

      set -g base-index 1
      setw -g pane-base-index 1

      set -gq allow-passthrough on
      bind-key x kill-pane # skip "kill-pane 1? (y/n)" prompt

      bind-key ` run-shell "tmux neww tmux-sessionizer"

      set-option -g @continuum-restore 'on'

      # Enable automatic window renaming (shows running program name)
      set -g automatic-rename on
    '';

    plugins = with pkgs.tmuxPlugins; [
      vim-tmux-navigator
      sensible
      gruvbox
      tmux-which-key
      yank
      {
        plugin = gruvbox;
        extraConfig = ''
          set -g @statusbar-alpha 'true'
          set -g @right-status-x '%d.%m.%Y' # e.g.: 30.01.2024
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
  #home.packages = [Config];
  home.packages = [];
}
