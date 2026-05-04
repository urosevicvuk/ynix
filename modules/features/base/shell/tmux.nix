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
          bind-key Enter display-popup -E -w 80% -h 70% -d '#{pane_current_path}' -T 'Sesh' tv sesh
          set-option -g @continuum-restore 'on'
          set -g automatic-rename on
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

              set -g @powerkit_plugins "git,github,kubernetes,terraform,datetime,hostname,ssh"

              set -g @powerkit_plugin_git_show_files "true"

              set -g @powerkit_plugin_kubernetes_show_namespace "true"
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
      #sessionizer
    };
    #home.packages = with pkgs; [
    #  sesh
    #];
  };
}
