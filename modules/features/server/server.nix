{self, ...}: {
  flake.nixosModules.server = {...}: {
    imports = [
      # Orchestration
      self.nixosModules.k3s

      # Storage
      self.nixosModules.clusterStorage

      # Networking
      self.nixosModules.clusterFirewall
    ];
  };
}
