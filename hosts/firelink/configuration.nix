{config, ...}: {
  imports = [
    ../../modules-nixos/core
    ../../modules-nixos/desktop/docker.nix
    ../../modules-nixos/cluster
    ../../modules-nixos/server/ssh.nix
    ../../secrets/server/nixos.nix
    ./variables.nix
    ./hardware-configuration.nix
  ];

  home-manager.users."${config.var.username}" = import ./home.nix;

  # Don't touch this
  system.stateVersion = "24.05";
}
