# Base group — foundation for every host.
# Sets up home-manager and composes all base sub-modules.
{
  self,
  inputs,
  ...
}: {
  flake.nixosModules.base = {config, ...}: {
    imports = [
      inputs.home-manager.nixosModules.default

      self.nixosModules.shell
      self.nixosModules.network

      self.nixosModules.boot
      self.nixosModules.locale
      self.nixosModules.nix
      self.nixosModules.security
      self.nixosModules.users
      self.nixosModules.environment
      self.nixosModules.direnv
      self.nixosModules.git
      self.nixosModules.jj
    ];

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
