{...}: {
  flake.nixosModules.desktop = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [vulkan-tools];

    hardware.graphics = {
      enable = true;
      extraPackages = with pkgs; [
        rocmPackages.clr.icd
        libva
        libva-utils
        libva-vdpau-driver
        libvdpau-va-gl
      ];
    };
  };
}
