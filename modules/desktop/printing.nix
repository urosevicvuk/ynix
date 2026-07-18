{self, ...}: {
  # Self-registers into the `desktop` group (merged with the other desktop modules).
  flake.nixosModules.desktop.imports = [self.nixosModules.printing];

  flake.nixosModules.printing = {...}: {
    services.printing.enable = true;

    services.avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };
  };
}
