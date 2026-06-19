{
  self,
  inputs,
  ...
}: {
  flake.nixosModules.hunk = {...}: {
    home-manager.sharedModules = [self.homeModules.hunk];
  };

  flake.homeModules.hunk = {pkgs, ...}: {
    imports = [
      inputs.hunk.homeManagerModules.default
    ];
    programs.hunk = {
      enable = true;
      enableGitIntegration = true;
    };
  };
}
