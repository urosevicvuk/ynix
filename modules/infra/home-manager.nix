# Home-manager integration plumbing — sibling to sops/stylix.
# Composed by the universal `system` group (HM is mandatory, not opt-in per host).
{inputs, ...}: {
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
