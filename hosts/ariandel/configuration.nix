{config, ...}: {
  imports = [
    # System modules
    ../../modules-nixos/system/nix.nix
    ../../modules-nixos/system/boot.nix
    ../../modules-nixos/system/secure-boot.nix
    ../../modules-nixos/system/users.nix
    ../../modules-nixos/system/utils.nix
    ../../modules-nixos/system/home-manager.nix
    ../../modules-nixos/system/locale.nix
    ../../modules-nixos/system/environment.nix
    ../../modules-nixos/system/security.nix

    # Hardware
    ../../modules-nixos/hardware/audio.nix
    ../../modules-nixos/hardware/bluetooth.nix
    ../../modules-nixos/hardware/keyd.nix
    ../../modules-nixos/hardware/printing.nix
    # ../../modules-nixos/hardware/peripherals.nix

    # Desktop environment
    ../../modules-nixos/desktop/fonts.nix
    ../../modules-nixos/desktop/hyprland.nix
    ../../modules-nixos/desktop/sddm.nix
    ../../modules-nixos/desktop/services.nix
    #../../modules-nixos/desktop/tuigreet.nix
    ../../modules-nixos/desktop/xdg.nix

    # Programs
    ../../modules-nixos/programs/gaming.nix
    ../../modules-nixos/programs/filesharing.nix

    # Services
    ../../modules-nixos/services/docker.nix

    # Network
    ../../modules-nixos/network/networking.nix
    ../../modules-nixos/network/tailscale.nix

    # Host-specific configuration
    ./variables.nix
    ./hardware-configuration.nix
    #./disko.nix
  ];

  # Framework AMD suspend/resume fixes
  # These parameters address critical suspend issues not covered by nixos-hardware
  boot.kernelParams = [
    # Disable USB autosuspend globally (may not be needed if pcie_aspm=off fixes the root cause)
    # Uncomment if fingerprint reader still disconnects after suspend
    #"usbcore.autosuspend=-1"

    ## Fix PCIe ASPM issues causing suspend failures on AMD Framework (kernel 6.12+)
    ## This should fix the xHCI USB controller resume issue (and thus the fingerprint reader)
    ## Also fixes MT7925 WiFi 5GHz dropping to 0 while connected
    ## Reference: Framework Community reports of suspend hangs
    "pcie_aspm=off"

    ## Fix xHCI controller dying on resume (Framework AMD 7040 bug)
    ## XHCI_RESET_ON_RESUME quirk forces controller reset after every resume
    ## This fixes the fingerprint reader disconnecting after suspend
    ## Reference: https://tomlankhorst.nl/unresponsive-usb-unbind-bind-linux
    #"xhci_hcd.quirks=2"

    ## Prevent NVMe deep sleep issues during suspend
    ## Fixes intermittent cold boots and unsafe shutdowns from lid-closed suspend
    ## Reference: Framework AMD suspend best practices
    #"nvme_core.default_ps_max_latency_us=25000"
  ];

  hardware.enableRedistributableFirmware = true;

  hardware.framework.enableKmod = true;

  home-manager.users."${config.var.username}" = import ./home.nix;

  # Don't touch this
  system.stateVersion = "24.05";
}
