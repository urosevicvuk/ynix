{...}: {
  flake.nixosModules.desktop = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [blueman bluetuith];

    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
      package = pkgs.bluez;
    };

    services.blueman.enable = true;
    hardware.xpadneo.enable = false;
  };
}
