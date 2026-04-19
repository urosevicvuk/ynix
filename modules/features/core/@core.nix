{
  self,
  inputs,
  ...
}: {
  flake.nixosModules.core = {pkgs, ...}: {
    imports = [
      self.nixosModules.zen
      self.nixosModules.helium
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
