# System group — foundation for every host.
# Sets up home-manager and composes the core system sub-modules.
# (shell/ is now its own importable domain — hosts add it alongside system.)
{
  self,
  inputs,
  ...
}: {
  flake.nixosModules.system = {config, ...}: {
    imports = [
      inputs.home-manager.nixosModules.default

      self.nixosModules.network
      self.nixosModules.ssh
      self.nixosModules.tailscale
      self.nixosModules.boot
      self.nixosModules.locale
      self.nixosModules.nix
      self.nixosModules.security
      self.nixosModules.users
      self.nixosModules.environment
      self.nixosModules.direnv
      self.nixosModules.git
      self.nixosModules.theme
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
