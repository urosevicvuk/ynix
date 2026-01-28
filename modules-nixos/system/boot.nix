{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (config.var) device;
in {
  boot = {
    initrd.kernelModules = ["amdgpu"];
    supportedFilesystems = ["ntfs"];
    bootspec.enable = true;
    loader = {
      efi.canTouchEfiVariables = true;
      #systemd-boot = lib.mkIf (device != "desktop") {
      #  enable = true;
      #  consoleMode = "auto";
      #  configurationLimit = 10;
      #  # Windows dual-boot works automatically via EFI boot entries
      #  # No need for OS Prober - systemd-boot will list all EFI boot entries
      #};
      grub = {
        enable = true;
        # GRUB disabled in favor of systemd-boot
        devices = ["nodev"];
        efiSupport = true;
        useOSProber = true;
      };
    };

    tmp.cleanOnBoot = true;
    kernelPackages = pkgs.linuxPackages_latest; # _zen, _hardened, _rt, _rt_latest, etc.

    # Silent boot
    #kernelParams = [
    #  "quiet"
    #  "splash"
    #  "vga=current"
    #  "rd.systemd.show_status=false"
    #  "rd.udev.log_level=3"
    #  "udev.log_priority=3"
    #];
    #consoleLogLevel = 0;
    #initrd.verbose = false;
    #extraModprobeConfig = "options bluetooth disable_ertm=1 ";
  };
}
