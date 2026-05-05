{self, ...}: {
  flake.nixosModules.gaming = {...}: {
    imports = [
      self.nixosModules.gamemode
      #self.nixosModules.lutris
      self.nixosModules.minecraft
      self.nixosModules.steam
    ];
  };
}
