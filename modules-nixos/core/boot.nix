{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (config.var) device;
  isDesktop = device == "desktop";
in {
  boot = {
    initrd.kernelModules = ["amdgpu"];
    supportedFilesystems = lib.mkIf isDesktop ["ntfs"];
    bootspec.enable = true;
    loader = {
      efi.canTouchEfiVariables = true;
      grub = {
        enable = true;
        devices = ["nodev"];
        efiSupport = true;
        useOSProber = isDesktop;
      };
    };

    tmp.cleanOnBoot = true;
    kernelPackages = pkgs.linuxPackages_latest;
  };

  powerManagement.cpuFreqGovernor = "schedutil";
}
