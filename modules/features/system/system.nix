# System group — universal foundation for every host. Pure aggregation.
# Home-manager wiring lives in infra/home-manager.nix; shell/ is its own
# importable domain that hosts add alongside system.
{self, ...}: {
  flake.nixosModules.system = {...}: {
    imports = [
      self.nixosModules.home-manager

      # Core
      self.nixosModules.boot
      self.nixosModules.locale
      self.nixosModules.nix
      self.nixosModules.environment
      self.nixosModules.direnv

      # Network
      self.nixosModules.network
      self.nixosModules.ssh
      self.nixosModules.tailscale

      # Security
      self.nixosModules.security
      self.nixosModules.users

      self.nixosModules.theme
    ];
  };
}
