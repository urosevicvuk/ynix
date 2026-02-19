{config, ...}: {
  imports = [
    ../../modules-nixos/core
    ../../modules-nixos/desktop
    #../../modules-nixos/hardware/secure-boot.nix
    ../../modules-nixos/hardware/framework.nix
    ./variables.nix
    ./hardware-configuration.nix
  ];

  hardware.enableRedistributableFirmware = true;
  hardware.framework.enableKmod = true;

  home-manager.users."${config.var.username}" = import ./home.nix;

  # Don't touch this
  system.stateVersion = "24.05";
}
