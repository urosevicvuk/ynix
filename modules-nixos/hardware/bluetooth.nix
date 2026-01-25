{pkgs, ...}: {
  environment.systemPackages = with pkgs; [blueman];
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    package = pkgs.bluez;
    settings.General.ClassicBondedOnly = false;
  };

  services.blueman.enable = true;
  # Disable xbox controller support because it's not working
  hardware.xpadneo.enable = false;
}
