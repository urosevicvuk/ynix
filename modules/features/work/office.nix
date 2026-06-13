# Work / office software
{self, ...}: {
  flake.nixosModules.office = {...}: {
    home-manager.sharedModules = [self.homeModules.office];
  };

  flake.homeModules.office = {pkgs, ...}: {
    home.packages = with pkgs; [
      libreoffice-fresh
      onlyoffice-desktopeditors
      slack
    ];
  };
}
