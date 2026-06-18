{self, ...}: {
  flake.nixosModules.zed-editor = {...}: {
    home-manager.sharedModules = [self.homeModules.zed-editor];
  };

  flake.homeModules.zed-editor = {pkgs, ...}: {
    programs.zed-editor = {
      enable = true;
      enableMcpIntegration = true;
    };
  };
}
