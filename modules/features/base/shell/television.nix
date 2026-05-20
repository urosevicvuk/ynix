{self, ...}: {
  flake.nixosModules.television = {...}: {
    home-manager.sharedModules = [self.homeModules.television];
  };

  flake.homeModules.television = {lib, ...}: {
    programs.television = {
      enable = true;
      enableNushellIntegration = true;
      enableBashIntegration = true;
      settings = {
        ui = {
          use_nerd_font_icons = true;
        };
      };

      channels = {
        sesh = lib.fromTOML ''
          [metadata]
          name = "sesh"
          description = "Sessions, zoxide directories, configured paths, and project dirs"
          requirements = [ "sesh", "fd",]

          [source]
          command = [ "sesh list --icons", "sesh list -t --icons", "fd -H -t d --min-depth 2 --max-depth 2 . ~/Projects | sed 's|^|󰉋 |'" ]
          ansi = true
          output = "{strip_ansi|split: :1..|join: }"

          [preview]
          command = "sesh preview '{strip_ansi|split: :1..|join: }'"

          [keybindings]
          enter = "actions:connect"
          ctrl-d = [ "actions:kill_session", "reload_source",]

          [actions.connect]
          description = "Connect to selected session"
          command = "sesh connect '{strip_ansi|split: :1..|join: }'"
          mode = "execute"

          [actions.kill_session]
          description = "Kill selected tmux session (press Ctrl+r to reload)"
          command = "tmux kill-session -t '{strip_ansi|split: :1..|join: }'"
          mode = "fork"
        '';

        alias = lib.fromTOML ''
          [metadata]
          name = "alias"
          description = "A channel to select from shell aliases"

          [source]
          command = "$SHELL -ic 'alias'"
          output = "{split:=:0}"

          [preview]
          command = "$SHELL -ic 'alias' | grep -E '^(alias )?{split:=:0}='"

          [ui.preview_panel]
          size = 30
        '';

        tailscale-exit-node = lib.fromTOML ''
          [metadata]
          name = "tailscale-exit-node"
          description = "A channel to select a tailscale exit node"
          requirements = [ "tailscale", "awk",]

          [source]
          command = "tailscale exit-node list | awk '/^[[:space:]]*[0-9]+\\./ {gsub(/^[[:space:]]+/, \"\"); print $1}'"

          [preview]
          command = "tailscale whois {}"

          [keybindings]
          enter = "actions:connect"

          [actions.connect]
          description = "Set selected host as exit node"
          command = "tailscale set --exit-node='{}'"
          mode = "execute"
        '';

        trash = lib.fromTOML ''
          [metadata]
          name = "trash"
          description = "Browse and restore trashed files"
          requirements = [ "trash-list", "trash-restore",]

          [source]
          command = "trash-list 2>/dev/null"
          no_sort = true
          frecency = false

          [preview]
          command = "echo '{}'"

          [ui]
          layout = "portrait"

          [ui.preview_panel]
          size = 30

          [actions.restore]
          description = "Restore the selected trashed file"
          command = "echo '{split: :1..}' | trash-restore"
          mode = "execute"

          [actions.empty]
          description = "Empty the entire trash"
          command = "trash-empty"
          mode = "execute"
        '';

        ports = lib.fromTOML ''
          [metadata]
          name = "ports"
          description = "List listening ports and associated processes"
          requirements = [ "ss", "awk",]

          [source]
          command = "ss -tlnp 2>/dev/null | tail -n +2 | awk '{gsub(/.*:/,\"\",$4); print $4, $1, $6}' | sed 's/users:((\"//; s/\".*//'"
          display = "{split: :0} ({split: :2})"

          [preview]
          command = "ss -tlnp 2>/dev/null | grep ':{split: :0} ' | head -20"

          [ui.preview_panel]
          size = 40

          [actions.kill]
          description = "Kill the process listening on the selected port"
          command = "fuser -k {split: :0}/tcp"
          mode = "execute"
        '';

        man-pages = lib.fromTOML ''
          [metadata]
          name = "man-pages"
          description = "Browse and preview system manual pages"
          requirements = [ "apropos", "man",]

          [source]
          command = "apropos ."

          [preview]
          command = "man '{0}'"

          [keybindings]
          enter = "actions:open"

          [ui]
          layout = "portrait"

          [preview.env]
          MANWIDTH = "80"

          [actions.open]
          description = "Open the selected man page in the system pager"
          command = "man '{0}'"
          mode = "execute"

          [ui.preview_panel]
          header = "{0}"
        '';

        kubectx = lib.fromTOML ''
          [metadata]
          name = "k8s-contexts"
          description = "List and switch kubectl contexts"
          requirements = [ "kubectl",]

          [source]
          command = "kubectl config get-contexts -o name"

          [preview]
          command = "kubectl config view --minify --context='{}' -o yaml"

          [ui]
          layout = "portrait"

          [keybindings]
          enter = "actions:use"
          ctrl-d = "actions:delete"

          [actions.use]
          description = "Switch to the selected context"
          command = "kubectl config use-context '{}'"
          mode = "execute"

          [actions.delete]
          description = "Delete the selected context"
          command = "kubectl config delete-context '{}'"
          mode = "execute"
        '';
      };
    };
  };
}
