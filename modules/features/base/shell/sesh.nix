{self, ...}: {
  flake.nixosModules.sesh = {...}: {
    home-manager.sharedModules = [self.homeModules.sesh];
  };

  flake.homeModules.sesh = {lib, ...}: {
    programs.sesh = {
      enable = true;
      enableAlias = false;
      enableTmuxIntegration = false;
      icons = true;

      settings = lib.fromTOML ''
        [[window]]
        name = "nvim"
        startup_script = "nvim"

        [[window]]
        name = "claude"
        startup_script = "claude"

        [[wildcard]]
        pattern = "~/Projects/personal/*"
        windows = [ "claude", "nvim" ]

        [[wildcard]]
        pattern = "~/Projects/work/*"
        windows = [ "claude", "nvim" ]

        [[wildcard]]
        pattern = "~/Projects/uni/*"
        windows = [ "claude", "nvim" ]

        [default_session]
        preview_command = "eza --all --git --icons --color=always"
      '';
    };
  };
}
