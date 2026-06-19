{self, ...}: {
  flake.nixosModules.gaming = {...}: {
    imports = [
      # Launchers
      self.nixosModules.steam
      #self.nixosModules.lutris

      # Games
      self.nixosModules.minecraft

      # Tweaks
      self.nixosModules.gamemode
    ];
  };
}
