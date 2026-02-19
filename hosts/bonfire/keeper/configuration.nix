{config, ...}: {
  imports = [
    ../../../modules-nixos/core
    ../../../modules-nixos/cluster
    ../../../modules-nixos/server/ssh.nix
    ./variables.nix
  ];

  home-manager.users."${config.var.username}" = import ./home.nix;

  system.stateVersion = "24.05";
}
