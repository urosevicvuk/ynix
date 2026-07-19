{self, ...}: {
  # Self-registers into the `system` group (merged with the other system modules).
  flake.nixosModules.system.imports = [self.nixosModules.boot];

  flake.nixosModules.boot = {
    pkgs,
    lib,
    ...
  }: {
    boot = {
      initrd.kernelModules = ["amdgpu"];
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
    };

    # Shared default; hosts may override (e.g. anorLondo pins "performance").
    powerManagement.cpuFreqGovernor = lib.mkDefault "schedutil";
  };
}
