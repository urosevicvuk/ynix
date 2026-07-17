{self, ...}: {
  flake.nixosModules.server = {...}: {
    imports = [
      # Orchestration
      self.nixosModules.k3s

      # Storage
      self.nixosModules.clusterStorage

      # Networking
      self.nixosModules.clusterFirewall

      # Build farm + binary cache (server halves; clients live in the base group)
      self.nixosModules.buildServer
      self.nixosModules.cacheServer
    ];
  };
}
