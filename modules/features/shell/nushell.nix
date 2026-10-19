{self, ...}: {
  # Self-registers into the `shell` group (merged with the other shell modules).
  flake.nixosModules.shell.imports = [self.nixosModules.nushell];

  flake.nixosModules.nushell = {...}: {
    home-manager.sharedModules = [self.homeModules.nushell];
  };

  flake.homeModules.nushell = {
    pkgs,
    lib,
    ...
  }: {
    home.shell.enableNushellIntegration = true;
    programs.nushell = {
      enable = true;

      settings = {
        show_banner = false;
        edit_mode = "vi";
        use_kitty_protocol = true;
        rm.always_trash = true;
        highlight_resolved_externals = true;
        table = {
          mode = "rounded";
          index_mode = "auto";
        };
        cursor_shape = {
          vi_insert = "line";
          vi_normal = "block";
        };
      };
      extraEnv = ''
        $env.KUBECONFIG = ($env.HOME + "/.kube/firelink.kubeconfig")
      '';

      extraConfig = ''
        # Ctrl-B: run the current (pasted) line through bash verbatim, so
        # POSIX snippets work without translating them to nushell.
        def __bash_escape [] {
          commandline edit --replace --accept $"bash -c r#'(commandline)'#"
        }
        $env.config.keybindings ++= [{
          name: bash_escape
          modifier: control
          keycode: char_b
          mode: [vi_insert vi_normal emacs]
          event: {send: executehostcommand, cmd: "__bash_escape"}
        }]
      '';

      plugins = with pkgs.nushellPlugins; [
      ];

      shellAliases = {
        gitui = "lazygit";
        nix-shell = "nix-shell --command nu";
        ssh = "kitten ssh";
      };
    };

    home.packages = with pkgs; [
      rmtrash
      trash-cli
    ];
  };
}
