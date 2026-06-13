# Comms — chat, mail, messaging.
{self, ...}: {
  flake.nixosModules.comms = {pkgs, ...}: {
    imports = [
      self.nixosModules.discord
      self.nixosModules.aerc
    ];

    environment.systemPackages = [pkgs.signal-desktop];
  };
}
