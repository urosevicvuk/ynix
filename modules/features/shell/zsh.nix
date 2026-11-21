{self, ...}: {
  flake.nixosModules.shell.imports = [self.nixosModules.zsh];

  flake.nixosModules.zsh = {...}: {
    programs.zsh.enable = true;
    home-manager.sharedModules = [self.homeModules.zsh];
  };

  flake.homeModules.zsh = {
    pkgs,
    config,
    ...
  }: let
    theme = config.theme.active;
  in {
    home.shell.enableZshIntegration = true;

    programs.zsh = {
      enable = true;
      defaultKeymap = "viins";

      plugins = [
        {
          name = "fzf-tab";
          src = "${pkgs.zsh-fzf-tab}/share/fzf-tab";
          file = "fzf-tab.plugin.zsh";
        }
      ];

      history = {
        size = 100000;
        save = 100000;
        ignoreDups = true;
        ignoreSpace = true;
        share = true;
        extended = true;
      };

      shellAliases = {
        gitui = "lazygit";
        ssh = "kitten ssh";
        nix-shell = "nix-shell --command nu";
      };

      autosuggestion = {
        enable = true;
        strategy = ["history" "completion"];
        highlight = "fg=${theme.base03}";
      };

      syntaxHighlighting = {
        enable = true;
        highlighters = ["main" "brackets" "pattern"];
        styles = {
          default = "fg=${theme.base05}";
          unknown-token = "fg=${theme.base08},bold";
          reserved-word = "fg=${theme.base0A}";
          alias = "fg=${theme.base0B}";
          suffix-alias = "fg=${theme.base0C}";
          global-alias = "fg=${theme.base0C}";
          builtin = "fg=${theme.base0A}";
          function = "fg=${theme.base0C}";
          command = "fg=${theme.base0B}";
          precommand = "fg=${theme.base0B},underline";
          commandseparator = "fg=${theme.base0D}";
          hashed-command = "fg=${theme.base0B}";
          path = "fg=${theme.base0D}";
          path_pathseparator = "fg=${theme.base03}";
          globbing = "fg=${theme.base0E}";
          history-expansion = "fg=${theme.base0E}";
          single-hyphen-option = "fg=${theme.base09}";
          double-hyphen-option = "fg=${theme.base09}";
          back-quoted-argument = "fg=${theme.base0C}";
          single-quoted-argument = "fg=${theme.base0B}";
          double-quoted-argument = "fg=${theme.base0B}";
          dollar-quoted-argument = "fg=${theme.base0B}";
          assign = "fg=${theme.base0E}";
          redirection = "fg=${theme.base0E}";
          comment = "fg=${theme.base03},italic";
          named-fd = "fg=${theme.base09}";
          numeric-fd = "fg=${theme.base09}";
          arg0 = "fg=${theme.base0B}";
          bracket-error = "fg=${theme.base08},bold";
          bracket-level-1 = "fg=${theme.base0D}";
          bracket-level-2 = "fg=${theme.base0E}";
          bracket-level-3 = "fg=${theme.base0C}";
          bracket-level-4 = "fg=${theme.base09}";
          bracket-level-5 = "fg=${theme.base0A}";
          cursor-matchingbracket = "standout";
        };
      };

      initContent = ''
        setopt INTERACTIVE_COMMENTS
        setopt NO_BEEP

        KEYTIMEOUT=1

        KUBECONFIG=~/.kube/firelink.kubeconfig

        zstyle ':fzf-tab:*' use-fzf-default-opts yes

        zstyle ':fzf-tab:*' fzf-bindings 'tab:accept'
      '';
    };
  };
}
