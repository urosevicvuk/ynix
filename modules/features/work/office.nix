{self, ...}: {
  flake.nixosModules.work.imports = [self.nixosModules.office];

  flake.nixosModules.office = {...}: {
    home-manager.sharedModules = [self.homeModules.office];
  };

  flake.homeModules.office = {pkgs, ...}: {
    home.packages = with pkgs; [
      libreoffice-stable
      onlyoffice-desktopeditors
      slack
    ];
  };
}
