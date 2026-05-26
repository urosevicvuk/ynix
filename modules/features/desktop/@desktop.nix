{self, ...}: {
  flake.nixosModules.desktop = {...}: {
    imports = [
      self.nixosModules.audio
      self.nixosModules.bluetooth
      self.nixosModules.bitwarden
      self.nixosModules.clipboard
      self.nixosModules.dbus
      self.nixosModules.filesharing
      self.nixosModules.fonts
      self.nixosModules.graphics
      self.nixosModules.keyd
      self.nixosModules.kitty
      self.nixosModules.ghostty
      self.nixosModules.mime
      self.nixosModules.niri
      self.nixosModules.noctalia
      self.nixosModules.printing
      self.nixosModules.thunar
      self.nixosModules.tuigreet
      self.nixosModules.udiskie
      self.nixosModules.xdg
      self.nixosModules.zathura
    ];
  };
}
