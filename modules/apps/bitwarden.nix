{self, ...}: {
  # Self-registers into the `apps` group (merged with the other apps modules).
  flake.nixosModules.apps.imports = [self.nixosModules.bitwarden];

  flake.nixosModules.bitwarden = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      bitwarden-desktop
      bitwarden-cli
    ];
  };
}
