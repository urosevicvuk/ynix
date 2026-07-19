{
  self,
  inputs,
  ...
}: {
  # Self-registers into the `dev` group (merged with the other dev modules).
  flake.nixosModules.dev.imports = [self.nixosModules.hunk];

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
