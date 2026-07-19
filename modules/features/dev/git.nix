{self, ...}: {
  # Self-registers into the `dev` group (merged with the other dev modules).
  flake.nixosModules.dev.imports = [self.nixosModules.git];

  flake.nixosModules.git = {...}: {
    home-manager.sharedModules = [self.homeModules.git];
  };

  flake.homeModules.git = {
    lib,
    pkgs,
    config,
    ...
  }: let
    theme = config.theme.active;
    accent = theme.base0D;
    muted = theme.base03;
  in {
    home.file.".ssh/allowed_signers".text = "* ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINQpgKiftVTzqkfu6zbRpvZFtWZH/HBQSj6DhuVvVRul vuk23urosevic@gmail.com";
    home.packages = with pkgs; [
      git-absorb
      pre-commit
    ];
    programs = {
      git = {
        enable = true;
        lfs.enable = true;
        ignores = [
          ".cache/"
          ".DS_Store"
          ".idea/"
          "*.swp"
          "*.elc"
          "auto-save-list"
          ".direnv/"
          "node_modules"
          "result"
          "result-*"
        ];
        includes = [
          {
            condition = "gitdir:~/Projects/uni/";
            contents = {
              user = {
                name = "vurosevic6422rn";
                email = "vurosevic6422rn@raf.rs";
                signingkey = "~/.ssh/id_ed25519_uni.pub";
              };
              core.sshCommand = "ssh -i ~/.ssh/id_ed25519_uni";
            };
          }
        ];
        settings = {
          user = {
            name = "urosevicvuk";
            email = "vuk23urosevic@gmail.com";
            signingkey = "~/.ssh/id_ed25519.pub";
          };
          init.defaultBranch = "master";
          pull.rebase = "false";
          push.autoSetupRemote = true;
          push.followTags = true;
          color.ui = "1";
          commit.gpgsign = true;
          gpg = {
            ssh.allowedSignersFile = "~/.ssh/allowed_signers";
            format = "ssh";
          };
          merge.conflictstyle = "diff3";
          diff.colorMoved = "default";
          maintenance = {
            auto = true;
            strategy = "incremental";
          };
          gc.autoDetach = true;
          alias = {
            essa = "push --force";
            co = "checkout";
            fuck = "commit --amend -m";
            c = "commit -m";
            ca = "commit -am";
            forgor = "commit --amend --no-edit";
            graph = "log --all --decorate --graph --oneline";
            oops = "checkout --";
            l = "log";
            r = "rebase";
            s = "status --short";
            ss = "status";
            d = "diff";
            ps = "!git push origin $(git rev-parse --abbrev-ref HEAD)";
            pl = "!git pull origin $(git rev-parse --abbrev-ref HEAD)";
            af = "!git add $(git ls-files -m -o --exclude-standard | sk -m)";
            st = "status";
            br = "branch";
            df = "!git hist | peco | awk '{print $2}' | xargs -I {} git diff {}^ {}";
            hist = ''log --pretty=format:"%Cgreen%h %Creset%cd %Cblue[%cn] %Creset%s%C(yellow)%d%C(reset)" --graph --date=relative --decorate --all'';
            llog = ''log --graph --name-status --pretty=format:"%C(red)%h %C(reset)(%cd) %C(green)%an %Creset%s %C(yellow)%d%Creset" --date=relative'';
            edit-unmerged = "!f() { git ls-files --unmerged | cut -f2 | sort -u ; }; hx `f`";
          };
        };
      };

      # these can be configued more, but idk what we need
      gh = {
        enable = true;
        #can add extenstions!
      };

      gh-dash = {
        enable = true;
        settings = {
          repoPaths = {
            "urosevicvuk/*" = "~/Projects/personal/*";
          };
        };
      };

      delta = {
        enable = true;
        enableGitIntegration = true;
        options = {
          navigate = true;
          side-by-side = true;
          line-numbers = true;
          syntax-theme = "base16";
          hyperlinks = true;
          hyperlinks-file-link-format = "vscode://file/{path}:{line}";
        };
      };

      lazygit = {
        enable = true;
        enableNushellIntegration = true;
        enableZshIntegration = true;
        settings = lib.mkForce {
          disableStartupPopups = true;
          notARepository = "skip";
          promptToReturnFromSubprocess = false;
          update.method = "never";
          git = {
            commit.signOff = true;
            parseEmoji = true;
          };
          gui = {
            theme = {
              activeBorderColor = [
                accent
                "bold"
              ];
              inactiveBorderColor = [muted];
            };
            showListFooter = false;
            showRandomTip = false;
            showCommandLog = false;
            showBottomLine = false;
            nerdFontsVersion = "3";
          };
        };
      };
    };
  };
}
