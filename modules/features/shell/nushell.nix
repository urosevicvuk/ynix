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
        $env.PROMPT_INDICATOR_VI_INSERT = "❯ "
        $env.PROMPT_INDICATOR_VI_NORMAL = "❮ "

        $env.KUBECONFIG = ($env.HOME + "/.kube/firelink.kubeconfig")
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
