{self, ...}: {
  # Self-registers into the `desktop` group (merged with the other desktop modules).
  flake.nixosModules.desktop.imports = [self.nixosModules.graphics];

  flake.nixosModules.graphics = {pkgs, ...}: {
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
