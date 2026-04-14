{
  flake.modules.nixos.core = [
    (
      { pkgs, ... }:
      {
        boot = {
          initrd.kernelModules = [ "amdgpu" ];
          bootspec.enable = true;
          loader = {
            efi.canTouchEfiVariables = true;
            grub = {
              enable = true;
              devices = [ "nodev" ];
              efiSupport = true;
            };
          };
          tmp.cleanOnBoot = true;
          kernelPackages = pkgs.linuxPackages_latest;
        };
        powerManagement.cpuFreqGovernor = "schedutil";
      }
    )
  ];
}
