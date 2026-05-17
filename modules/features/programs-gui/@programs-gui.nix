{self, ...}: {
  flake.nixosModules.programs-gui = {pkgs, ...}: {
    imports = [
      self.nixosModules.browsers

      self.nixosModules.calibre
      self.nixosModules.discord
      self.nixosModules.spicetify
      self.nixosModules.obsidian
      self.nixosModules.qbitorrent
    ];

    environment.systemPackages = with pkgs; [
      nvtopPackages.amd
      signal-desktop
      vlc
    ];
  };
}
