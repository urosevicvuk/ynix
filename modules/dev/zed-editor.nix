{self, ...}: {
  # Self-registers into the `dev` group (merged with the other dev modules).
  flake.nixosModules.dev.imports = [self.nixosModules.zed-editor];

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
