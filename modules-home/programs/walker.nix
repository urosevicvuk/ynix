{
  inputs,
  pkgs,
  config,
  ...
}: {
  imports = [inputs.walker.homeManagerModules.default];

  programs.walker = {
    enable = false; # Disabled - using noctalia launcher instead
    runAsService = false;

    config = {
      theme = "gruvbox";
      force_keyboard_focus = true;
      close_when_open = true;
      selection_wrap = true;
      click_to_close = true;
      exact_search_prefix = "'";

      # Faster animations
      animation_duration = 100; # milliseconds (default is 250)
      animation_type = "fade"; # fade instead of slide

      shell = {
        anchor_top = true;
        anchor_bottom = true;
        anchor_left = true;
        anchor_right = true;
      };

      dmenu = {
        anchor_top = true;
        width = 600;
        height = 400;
      };

      placeholders = {
        default = {
          input = " Search...";
          list = "No Results";
        };
      };

      keybinds = {
        close = ["Escape"];
        next = ["Down" "ctrl n"];
        previous = ["Up" "ctrl p"];
        toggle_exact = ["ctrl e"];
        resume_last_query = ["ctrl r"];
      };

      providers = {
        default = [
          "desktopapplications"
          "websearch"
        ];
        empty = ["desktopapplications"];
        max_results = 50;

        prefixes = [
          {
            prefix = "/";
            provider = "providerlist";
          }
          {
            prefix = ".";
            provider = "files";
          }
          {
            prefix = ":";
            provider = "symbols";
          }
          {
            prefix = "=";
            provider = "calc";
          }
          {
            prefix = "@";
            provider = "websearch";
          }
          {
            prefix = "$";
            provider = "clipboard";
          }
        ];

        actions.desktopapplications = [
          {
            action = "start";
            default = true;
            bind = "Return";
          }
          {
            action = "start:keep";
            label = "open+next";
            bind = "shift Return";
            after = "KeepOpen";
          }
          {
            action = "pin";
            bind = "ctrl shift p";
            after = "AsyncReload";
          }
          {
            action = "unpin";
            bind = "ctrl shift p";
            after = "AsyncReload";
          }
          {
            action = "pinup";
            bind = "ctrl shift n";
            after = "AsyncReload";
          }
          {
            action = "pindown";
            bind = "ctrl m";
            after = "AsyncReload";
          }
        ];

        actions.clipboard = [
          {
            action = "copy";
            default = true;
            bind = "Return";
          }
          {
            action = "remove";
            bind = "ctrl d";
            after = "ClearReload";
          }
          {
            action = "remove_all";
            global = true;
            bind = "ctrl shift d";
            after = "ClearReload";
          }
          {
            action = "pause";
            bind = "ctrl shift p";
          }
          {
            action = "unpause";
            bind = "ctrl shift p";
          }
          {
            action = "edit";
            bind = "ctrl o";
          }
        ];
      };
    };

    themes = {
      gruvbox.style = ''
        * {
          all: unset;
          font-family: "${config.stylix.fonts.serif.name}";
          font-size: ${toString config.stylix.fonts.sizes.desktop}px;
        }

        scrollbar {
          opacity: 0;
        }

        .box-wrapper {
          background: #${config.lib.stylix.colors.base00};
          padding: 16px;
          border-radius: ${toString config.theme.rounding}px;
          border: ${toString config.theme.border-size}px solid #${config.lib.stylix.colors.base0D};
          opacity: 1.0;
        }

        window {
          background: rgba(0, 0, 0, 0);
          opacity: 1.0;
        }

        .input {
          caret-color: #${config.lib.stylix.colors.base05};
          background: #${config.lib.stylix.colors.base01};
          padding: 12px 16px;
          color: #${config.lib.stylix.colors.base05};
          border-radius: ${toString (config.theme.rounding - 2)}px;
          margin-bottom: 8px;
          font-size: ${toString (config.stylix.fonts.sizes.desktop + 2)}px;
        }

        .input placeholder {
          opacity: 0.4;
          color: #${config.lib.stylix.colors.base04};
        }

        .list {
          color: #${config.lib.stylix.colors.base05};
        }

        .item-box {
          border-radius: ${toString (config.theme.rounding - 4)}px;
          padding: 10px;
        }

        child:hover .item-box,
        child:selected .item-box {
          background: #${config.lib.stylix.colors.base02};
        }

        .item-subtext {
          font-size: ${toString (config.stylix.fonts.sizes.desktop - 2)}px;
          opacity: 0.6;
          color: #${config.lib.stylix.colors.base04};
        }

        .placeholder,
        .elephant-hint {
          color: #${config.lib.stylix.colors.base04};
        }

        .large-icons {
          -gtk-icon-size: 32px;
        }

        .normal-icons {
          -gtk-icon-size: 16px;
        }

        .item-quick-activation {
          opacity: 0;
        }
      '';
    };
  };
}
