# firelink1: Lenovo System x3650 M5. Same setup as the old firelink (Tailscale,
# the `server` features, Cilium from ykube), plus:
#   - fan control for the M5 (modules/hardware/x3650m5.nix);
#   - RKE2 as Kubernetes (features/server/rke2.nix; k3s is parked as
#     _k3s.nix), set up so firelink2/3 can join later;
#   - systemd-boot, as the graphical installer set it up (the M5 firmware
#     didn't boot ynix's GRUB setup from the NVMe).
#
# Install: graphical installer, then on the machine:
#   sudo nixos-generate-config --show-hardware-config \
#     > modules/hosts/firelink1/_hardware-configuration.nix
#   set system.stateVersion below to the one in /etc/nixos/configuration.nix
#   nh os boot . -H firelink1   (or: sudo nixos-rebuild boot --flake .#firelink1)
{
  self,
  inputs,
  ...
}: {
  flake.nixosConfigurations.firelink1 = inputs.nixpkgs.lib.nixosSystem {
    modules = [self.nixosModules.firelink1];
  };

  flake.nixosModules.firelink1 = {
    config,
    lib,
    pkgs,
    ...
  }: {
    imports = [
      ./_hardware-configuration.nix

      self.nixosModules.system
      self.nixosModules.shell
      self.nixosModules.git
      self.nixosModules.llm-agents
      self.nixosModules.podman
      self.nixosModules.neovim
      self.nixosModules.server
      self.nixosModules.sops

      self.nixosModules.x3650m5
    ];

    networking.hostName = "firelink1";
    # Must match the installer's /etc/nixos/configuration.nix.
    system.stateVersion = "25.05";

    # Keep the bootloader the installer put on the disk (proven to boot here)
    # instead of ynix's default GRUB.
    boot.loader.grub.enable = lib.mkForce false;
    boot.loader.systemd-boot = {
      enable = true;
      configurationLimit = 10;
    };
    boot.loader.efi.canTouchEfiVariables = true;

    # Same as the old firelink: IPMI, hardware watchdog, panic -> reboot.
    boot.kernelModules = ["ipmi_si" "ipmi_devintf" "ipmi_watchdog"];
    boot.extraModprobeConfig = "options ipmi_watchdog action=reset";
    systemd.settings.Manager = {
      RuntimeWatchdogSec = "2min";
      RebootWatchdogSec = "5min";
    };

    # Defaults: RKE2's CIS hardening sets the same values itself.
    boot.kernel.sysctl = {
      "kernel.panic" = lib.mkDefault 10;
      "kernel.panic_on_oops" = lib.mkDefault 1;
      "kernel.hardlockup_panic" = 1;
    };

    hardware.rasdaemon.enable = true;

    environment.systemPackages = [pkgs.ipmitool];

    sops = {
      age.sshKeyPaths = ["/home/vyke/.ssh/id_ed25519"];
      defaultSopsFormat = "yaml";
    };
  };
}
