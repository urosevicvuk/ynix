{self, ...}: {
  # Self-registers into the `creative` group (merged with the other creative modules).
  flake.nixosModules.creative.imports = [self.nixosModules.davinciResolve];

  flake.nixosModules.davinciResolve = {...}: {
    home-manager.sharedModules = [self.homeModules.davinciResolve];
  };

  flake.homeModules.davinciResolve = {pkgs, ...}: {
    home.packages = with pkgs; [
      davinci-resolve
    ];
  };
}
