{self, ...}: {
  flake.nixosModules.cluster = {...}: {
    imports = [
      self.nixosModules.clusterFirewall
      self.nixosModules.k3s
      self.nixosModules.clusterStorage
    ];
  };
}
