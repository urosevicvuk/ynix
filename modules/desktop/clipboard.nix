{self, ...}: {
  # Self-registers into the `desktop` group (merged with the other desktop modules).
  flake.nixosModules.desktop.imports = [self.nixosModules.clipboard];

  flake.nixosModules.clipboard = {...}: {
    home-manager.sharedModules = [self.homeModules.clipboard];
  };

  flake.homeModules.clipboard = {pkgs, ...}: {
    services.wl-clip-persist = {
      enable = true;
    };

    services.cliphist = {
      enable = true;
      allowImages = true;
    };

    home.packages = with pkgs; [
      wl-clipboard
    ];
  };
}
