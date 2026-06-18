{self, ...}: {
  flake.nixosModules.claude-code = {...}: {
    home-manager.sharedModules = [self.homeModules.claude-code];
  };

  flake.homeModules.claude-code = {pkgs, ...}: {
    programs.claude-code = {
      enable = true;
      enableMcpIntegration = true;

      # we have a lot of bs to configure here, but i don't think we need it
    };
  };
}
