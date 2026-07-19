# Work / office software
{self, ...}: {
  # Self-registers into the `work` group (merged with the other work modules).
  flake.nixosModules.work.imports = [self.nixosModules.office];

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
