{config, ...}: {
  imports = [
    ../../modules-nixos/core
    ../../modules-nixos/desktop
    ../../modules-nixos/hardware/peripherals.nix
    ../../modules-nixos/cluster
    ./variables.nix
    ./hardware-configuration.nix
  ];

  hardware.enableAllFirmware = true;

  home-manager.users."${config.var.username}" = import ./home.nix;

  # Don't touch this
  system.stateVersion = "24.05";
}
