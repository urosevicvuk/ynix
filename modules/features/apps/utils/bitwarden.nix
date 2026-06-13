{...}: {
  flake.nixosModules.bitwarden = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      bitwarden-desktop
      bitwarden-cli
    ];
  };
}
