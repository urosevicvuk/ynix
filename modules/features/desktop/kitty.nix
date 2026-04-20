# Kitty is a fast, featureful, GPU based terminal emulator
{self, ...}: {
  flake.nixosModules.kitty = {...}: {
    home-manager.sharedModules = [self.homeModules.kitty];
  };

  flake.homeModules.kitty = {...}: {
    programs.kitty = {
      enable = true;

      shellIntegration.enableZshIntegration = true;

      settings = {
        scrollback_lines = 10000;
        initial_window_width = 1200;
        initial_window_height = 600;
        update_check_interval = 0;
        enable_audio_bell = false;
        confirm_os_window_close = 0;
        disable_ligatures = "never";
        url_style = "curly";
        copy_on_select = "clipboard";
        cursor_shape = "Underline";
        cursor_underline_thickness = 3;
        cursor_trail = 3;
        cursor_trail_decay = "0.1 0.4";
        window_padding_width = 6;
        open_url_with = "default";
        touch_scroll_multiplier = 3.0;
      };
    };
  };
}
