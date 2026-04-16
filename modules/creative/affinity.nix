{inputs, ...}: {
  flake.homeModules.affinity = {pkgs, ...}: {
    home.packages = [
      inputs.affinity-nix.packages.${pkgs.system}.v3
    ];
  };
}
