# File sharing — KDE Connect + LocalSend
{self, ...}: {
  # Self-registers into the `desktop` group (merged with the other desktop modules).
  flake.nixosModules.desktop.imports = [self.nixosModules.filesharing];

  flake.nixosModules.filesharing = {...}: {
    programs = {
      kdeconnect.enable = true;
      localsend.enable = true;
    };
  };
}
