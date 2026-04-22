{self, ...}: {
  flake.nixosModules.bitwarden = {pkgs, ...}: {
    home-manager.sharedModules = [self.homeModules.bitwarden];

    environment.systemPackages = with pkgs; [
      bitwarden-desktop
      bitwarden-cli
    ];
  };

  flake.homeModules.bitwarden = {pkgs, ...}: {
    #home.packages = with pkgs; [
    #  bitwarden-desktop
    #  bitwarden-cli
    #];
  };
}
