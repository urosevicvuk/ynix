{self, ...}: {
  flake.nixosModules.desktop = {...}: {
    imports = [
      # Hardware
      self.nixosModules.audio
      self.nixosModules.bluetooth
      self.nixosModules.graphics
      self.nixosModules.keyd
      self.nixosModules.printing

      # Session
      self.nixosModules.niri
      self.nixosModules.noctalia
      self.nixosModules.tuigreet
      self.nixosModules.fonts

      # Services
      self.nixosModules.clipboard
      self.nixosModules.dbus
      self.nixosModules.filesharing
      self.nixosModules.mime
      self.nixosModules.udiskie
      self.nixosModules.xdg
    ];
  };
}
