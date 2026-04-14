# Hardware peripherals support - gaming mice, RGB controllers, Logitech devices
{ pkgs, ... }:
{
  services = {
    ratbagd.enable = true;
    hardware.openrgb.enable = true;

    udev = {
      packages = [ pkgs.solaar ];
      extraRules = ''
        SUBSYSTEM=="hidraw", ATTRS{idVendor}=="046d", MODE="0664", GROUP="input"
        SUBSYSTEM=="hidraw", KERNELS=="*046D*", MODE="0664", GROUP="input"
      '';
    };
  };

  home-manager.users.vyke.home.packages = with pkgs; [
    solaar
    piper
  ];
}
