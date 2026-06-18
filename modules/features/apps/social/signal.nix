{...}: {
  flake.nixosModules.signal = {pkgs, ...}: {
    environment.systemPackages = [pkgs.signal-desktop];
  };
}
