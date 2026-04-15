{ ... }:
{
  flake.nixosModules.desktop = { pkgs, ... }:
      {
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
