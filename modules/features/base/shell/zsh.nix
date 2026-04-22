{self, ...}: {
  flake.nixosModules.zsh = {...}: {
    home-manager.sharedModules = [self.homeModules.zsh];
  };

  flake.homeModules.zsh = {
    pkgs,
    lib,
    config,
    ...
  }: let
    fetch = self.theme.fetch;
  in {
    home.packages = with pkgs; [
      bat
      ripgrep
      tldr
      sesh
      rmtrash
    ];
    home.sessionPath = ["$HOME/go/bin"];
    programs.zsh = {
      enable = false;
      enableCompletion = false;
      #autosuggestion.enable = true;
      syntaxHighlighting = {
        enable = true;
        highlighters = [
          "main"
          "brackets"
          "pattern"
          "regexp"
          "root"
          "line"
        ];
      };
      historySubstringSearch.enable = true;
      history = {
        ignoreDups = true;
        save = 10000;
        size = 10000;
      };
      profileExtra = lib.optionalString (config.home.sessionPath != []) ''
        export PATH="$PATH''${PATH:+:}${lib.concatStringsSep ":" config.home.sessionPath}"
      '';
      plugins = [
        {
          name = "zsh-vi-mode";
          src = pkgs.zsh-vi-mode;
        }
        {
          name = "zsh-nix-shell";
          src = pkgs.zsh-nix-shell;
        }
        {
          name = "zsh-autopair";
          src = pkgs.zsh-autopair;
        }
      ];
      shellAliases = {
        vim = "nvim";
        vi = "nvim";
        v = "nvim";
        c = "clear";
        clera = "clear";
        celar = "clear";
        e = "exit";
        ls = "eza --icons=always --no-quotes -l";
        tree = "eza --icons=always --tree --no-quotes";
        sl = "ls";
        open = "${pkgs.xdg-utils}/bin/xdg-open";
        icat = "${pkgs.kitty}/bin/kitty +kitten icat";
        cat = "bat --theme=base16 --color=always --paging=never --tabs=2 --wrap=never --plain";
        mkdir = "mkdir -p";
        rm = "${pkgs.rmtrash}/bin/rmtrash";
        rmdir = "${pkgs.rmtrash}/bin/rmdirtrash";
        quantum = "pw-metadata -n settings 0 clock.force-quantum";
        obsidian-no-gpu = "env ELECTRON_OZONE_PLATFORM_HINT=auto obsidian --ozone-platform=x11";
        wireguard-import = "nmcli connection import type wireguard file";
        note = "notes";
        tmp = "nvim /tmp/$(date | sed 's/ //g;s/\\.//g').md";
        nix-shell = "nix-shell --command zsh";
        g = "lazygit";
        ga = "git add";
        gc = "git commit";
        gcu = "git add . && git commit -m 'Update'";
        gp = "git push";
        gpl = "git pull";
        gs = "git status";
        gd = "git diff";
        gco = "git checkout";
        gcb = "git checkout -b";
        gbr = "git branch";
        grs = "git reset HEAD~1";
        grh = "git reset --hard HEAD~1";
        gaa = "git add .";
        gcm = "git commit -m";
      };
      #${lib.optionalString (config.sops or null != null && config.sops.secrets ? anthropic-api-key) ''
      #  export ANTHROPIC_API_KEY="$(cat ${config.sops.secrets.anthropic-api-key.path})"
      #''}
      initContent = ''


        bindkey -v
        ${
          if fetch == "neofetch"
          then pkgs.neofetch + "/bin/neofetch"
          else if fetch == "nerdfetch"
          then "nerdfetch"
          else if fetch == "pfetch"
          then "echo; ${pkgs.pfetch}/bin/pfetch"
          else ""
        }

        function tmux-sessionizer-widget() {
          tmux-sessionizer
        }
        zle     -N             tmux-sessionizer-widget
        bindkey -M emacs '\e`' tmux-sessionizer-widget
        bindkey -M vicmd '\e`' tmux-sessionizer-widget
        bindkey -M viins '\e`' tmux-sessionizer-widget

        function dev-flake() {
          nix flake init --template "https://flakehub.com/f/the-nix-way/dev-templates/*#$1" && direnv allow
        }

        autoload -U history-search-end
        zle -N history-beginning-search-backward-end history-search-end
        zle -N history-beginning-search-forward-end history-search-end
        bindkey "^[OA" history-beginning-search-backward-end
        bindkey "^[OB" history-beginning-search-forward-end

        zstyle ':completion:*' completer _extensions _complete _approximate
        zstyle ':completion:*' use-cache on
        zstyle ':completion:*' cache-path "$XDG_CACHE_HOME/zsh/.zcompcache"
        zstyle ':completion:*' complete true
        zstyle ':completion:*' complete-options true
        zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
        zstyle ':completion:*' keep-prefix true
        zstyle ':completion:*' menu select
        zstyle ':completion:*' list-grouped false
        zstyle ':completion:*' list-separator '''
        zstyle ':completion:*' group-name '''
        zstyle ':completion:*' verbose yes
        zstyle ':completion:*:matches' group 'yes'
        zstyle ':completion:*:warnings' format '%F{red}%B-- No match for: %d --%b%f'
        zstyle ':completion:*:messages' format '%d'
        zstyle ':completion:*:corrections' format '%B%d (errors: %e)%b'
        zstyle ':completion:*:descriptions' format '[%d]'
        zstyle ':completion:*' list-colors ''${(s.:.)LS_COLORS}
        zstyle ':completion:*:*:cd:*' tag-order local-directories directory-stack path-directories
        zstyle ':completion:*:*:cd:*:directory-stack' menu yes select
        zstyle ':completion:*:-tilde-:*' group-order 'named-directories' 'path-directories' 'users' 'expand'
        zstyle ':completion:*:*:-command-:*:*' group-order aliases builtins functions commands
        zstyle ':completion:*' special-dirs true
        zstyle ':completion:*' squeeze-slashes true
        zstyle ':completion:*' sort false
        zstyle ":completion:*:git-checkout:*" sort false
        zstyle ':completion:*' file-sort modification
        zstyle ':completion:*:eza' sort false
        zstyle ':completion:complete:*:options' sort false
        zstyle ':completion:files' sort false

        ${lib.optionalString config.services.gpg-agent.enable ''
          gnupg_path=$(ls $XDG_RUNTIME_DIR/gnupg)
          export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/gnupg/$gnupg_path/S.gpg-agent.ssh"
        ''}

        function precmd {
          if ! builtin zle; then
              print -n "\e]133;D\e\\"
          fi
        }
        function preexec {
          print -n "\e]133;C\e\\"
        }
      '';
    };
  };
}
