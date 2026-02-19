{
  pkgs,
  lib,
  ...
}: {
  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/var/lib/sbctl";
  };

  # Lanzaboote wraps systemd-boot - disable both GRUB and systemd-boot
  boot.loader.grub.enable = lib.mkForce false;
  boot.loader.systemd-boot.enable = lib.mkForce false;

  environment.systemPackages = [pkgs.sbctl];
}
