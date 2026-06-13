{
  flake.nixosModules.boot = {
    pkgs,
    lib,
    ...
  }: {
    boot = {
      initrd.kernelModules = ["amdgpu"];
      bootspec.enable = true;
      loader = {
        efi.canTouchEfiVariables = true;
        grub = {
          enable = true;
          devices = ["nodev"];
          efiSupport = true;
        };
      };
      tmp.cleanOnBoot = true;
      kernelPackages = pkgs.linuxPackages_latest;

      # Raise inotify limits. File-watchers (snacks.nvim walking up the dir
      # tree, direnv, etc.) exhaust the kernel default and fail with ENOSPC -
      # a misleadingly-named "too many watches" error, not actual disk space.
      kernel.sysctl = {
        "fs.inotify.max_user_watches" = 524288;
        "fs.inotify.max_user_instances" = 1024;
      };
    };
    powerManagement.cpuFreqGovernor = "schedutil";
  };
}
