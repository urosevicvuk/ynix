{self, ...}: {
  flake.nixosModules.thunar = {pkgs, ...}: {
    programs.thunar = {
      enable = true;
      plugins = with pkgs; [
        thunar-archive-plugin
        xfce.thunar-volman
        xfce.thunar-media-tags-plugin
      ];
    };
    services.gvfs.enable = true;
    services.tumbler.enable = true;

    home-manager.sharedModules = [self.homeModules.thunar];
  };

  flake.homeModules.thunar = {pkgs, ...}: {
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
