{self, ...}: {
  flake.nixosModules.dolphin = {...}: {
    home-manager.sharedModules = [self.homeModules.dolphin];
  };

  flake.homeModules.dolphin = {pkgs, ...}: {
    home.packages = with pkgs; [
      kdePackages.dolphin
      kdePackages.dolphin-plugins
      kdePackages.ark
      kdePackages.kate
      kdePackages.kio
      kdePackages.kio-extras
      kdePackages.kio-fuse
      kdePackages.kio-admin
      kdePackages.ffmpegthumbs
      kdePackages.kdegraphics-thumbnailers
      kdePackages.qtimageformats
      kdePackages.svgpart
      p7zip
    ];

    home.file.".local/share/user-places.xbel".text = ''
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE xbel>
      <xbel xmlns:bookmark="http://www.freedesktop.org/standards/desktop-bookmarks" xmlns:mime="http://www.freedesktop.org/standards/shared-mime-info" version="1.0">
       <bookmark href="file:///home/vyke/Downloads">
        <title>Downloads</title>
        <info>
         <metadata owner="http://freedesktop.org">
          <bookmark:icon name="folder-download"/>
         </metadata>
        </info>
       </bookmark>
       <bookmark href="file:///home/vyke/Pictures">
        <title>Pictures</title>
        <info>
         <metadata owner="http://freedesktop.org">
          <bookmark:icon name="folder-pictures"/>
         </metadata>
        </info>
       </bookmark>
       <bookmark href="file:///home/vyke/.config/nixos">
        <title>NixOS</title>
        <info>
         <metadata owner="http://freedesktop.org">
          <bookmark:icon name="folder-blue"/>
         </metadata>
        </info>
       </bookmark>
       <bookmark href="file:///home/vyke/dev">
        <title>Development</title>
        <info>
         <metadata owner="http://freedesktop.org">
          <bookmark:icon name="folder-development"/>
         </metadata>
        </info>
       </bookmark>
      </xbel>
    '';
  };
}
