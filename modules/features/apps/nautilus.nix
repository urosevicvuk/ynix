{self, ...}: {
  # Self-registers into the `apps` group (merged with the other apps modules).
  flake.nixosModules.apps.imports = [self.nixosModules.nautilus];

  flake.nixosModules.nautilus = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      nautilus
      sushi
    ];

    services.gvfs.enable = true;
    services.tumbler.enable = true;
    programs.dconf.enable = true;

    home-manager.sharedModules = [self.homeModules.nautilus];
  };

  flake.homeModules.nautilus = {pkgs, ...}: {
    home.packages = with pkgs; [
      file-roller
      p7zip
      unrar
    ];

    home.file.".config/gtk-3.0/bookmarks".text = ''
      file:///home/vyke/Downloads Downloads
      file:///home/vyke/Pictures Pictures
      file:///home/vyke/.config/nixos NixOS
      file:///home/vyke/dev Development
    '';
  };
}
