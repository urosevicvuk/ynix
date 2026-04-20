{self, ...}: {
  flake.nixosModules.tmux = {...}: {
    home-manager.sharedModules = [self.homeModules.tmux];
  };

  flake.homeModules.tmux = {
    pkgs,
    lib,
    ...
  }: {
    programs = {
      tmux = {
        enable = true;
        mouse = true;
        shell = lib.getExe pkgs.nushell;
        prefix = "C-Space";
        terminal = "kitty";
        keyMode = "vi";
        disableConfirmationPrompt = true;
        sensibleOnTop = true;
        extraConfig = ''
          bind-key | split-window -h -c "#{pane_current_path}"
          bind-key _ split-window -v -c "#{pane_current_path}"
          bind-key -r < resize-pane -L 10
          bind-key -r > resize-pane -R 10
          setw -g pane-base-index 1
          set-option -g status-position top
          set -g base-index 1
          set -gq allow-passthrough on
          bind-key x kill-pane
          set -g detach-on-destroy off
          bind-key ` run-shell "tmux neww tmux-sessionizer"
          set-option -g @continuum-restore 'on'
          set -g automatic-rename on
        '';
        plugins = with pkgs.tmuxPlugins; [
          vim-tmux-navigator
          sensible
          tmux-which-key
          gruvbox
          jump
          tmux-fzf
          tmux-thumbs
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
              set -g @continuum-boot 'on'
              set -g @continuum-save-interval '10'
            '';
          }
        ];
      };
      #sessionizer
    };
    #home.packages = with pkgs; [
    #  sesh
    #];
  };
}
