{self, ...}: {
  flake.nixosModules.davinciResolve = {...}: {
    home-manager.sharedModules = [self.homeModules.davinciResolve];
  };

  flake.homeModules.davinciResolve = {pkgs, ...}: {
    home.packages = with pkgs; [
      davinci-resolve
    ];
  };
}
