{
  config,
  lib,
  ...
}: {
  programs.ghostty = {
    enable = true;

    installVimSyntax = true;
    enableZshIntegration = true;

    settings = {
      # Font configuration
      # Force JetBrainsMono Nerd Font and prevent Stylix from adding emoji fallback
      font-family = lib.mkForce "JetBrainsMono Nerd Font Propo";
      font-size = lib.mkForce 13;

      # Window appearance
      window-padding-x = 6;
      window-padding-y = 6;
      window-padding-balance = true;

      # Shell integration features
      shell-integration = "detect";
      shell-integration-features = "cursor,sudo,title,ssh-env,ssh-terminfo";

      # Quick terminal (dropdown Quake-style terminal)
      # Summon with super+grave keybind
      quick-terminal-position = "center";
      quick-terminal-size = "50%";
      quick-terminal-autohide = true;

      # Keybindings
      keybind = [
        "ctrl+t=toggle_quick_terminal"
        "ctrl+shift+equal=increase_font_size:1"
        "ctrl+shift+minus=decrease_font_size:1"
        "ctrl+shift+0=reset_font_size"
        "ctrl+shift+n=new_window"
        "ctrl+shift+t=new_tab"
        "ctrl+shift+w=close_surface"
        "ctrl+tab=next_tab"
        "ctrl+shift+tab=previous_tab"
      ];

      # Link handling
      link-previews = true;

      # Clipboard behavior (matching Kitty)
      copy-on-select = "clipboard";
      clipboard-trim-trailing-spaces = true;

      # Scrollback (Kitty had 10000 lines, ~10MB in bytes)
      scrollback-limit = 10485760;

      # Quality of life
      confirm-close-surface = false;
    };
  };
}
