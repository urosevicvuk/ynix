# Home-manager integration plumbing — sibling to sops/stylix.
# Composed by the universal `system` group (HM is mandatory, not opt-in per host).
{
  self,
  inputs,
  ...
}: {
  # Self-registers into the `system` group (merged with the other system modules).
  flake.nixosModules.system.imports = [self.nixosModules.home-manager];

  flake.nixosModules.home-manager = {config, ...}: {
    imports = [inputs.home-manager.nixosModules.default];

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      backupFileExtension = "hm-backup";
      users.${config.preferences.username} = {
        home.stateVersion = "26.05";
        home.username = config.preferences.username;
        home.homeDirectory = "/home/${config.preferences.username}";
        programs.home-manager.enable = true;
      };
    };
  };
}
