# firelink3: HPE ProLiant DL380 Gen9. Same setup as the old firelink (Tailscale,
# the `server` features, Cilium from ykube), plus:
#   - RKE2 as Kubernetes (features/server/rke2.nix; k3s is parked as
#     _k3s.nix), set up so firelink2/3 can join later;
#   - systemd-boot, as the graphical installer set it up (the M5 firmware
#     didn't boot ynix's GRUB setup; same choice here).
#
# Install: graphical installer, then on the machine:
#   sudo nixos-generate-config --show-hardware-config \
#     > modules/hosts/firelink3/_hardware-configuration.nix
#   set system.stateVersion below to the one in /etc/nixos/configuration.nix
#   nh os boot . -H firelink3   (or: sudo nixos-rebuild boot --flake .#firelink3)
{
  self,
  inputs,
  ...
}: {
  flake.nixosConfigurations.firelink3 = inputs.nixpkgs.lib.nixosSystem {
    modules = [self.nixosModules.firelink3];
  };

  flake.nixosModules.firelink3 = {
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
    ];

    networking.hostName = "firelink3";

    # RKE2 stays off until this node joins firelink1 (remote, over Tailscale):
    # copy firelink1:/var/lib/rancher/rke2/server/token to
    # /var/lib/rancher/rke2/token here, then replace these lines with
    #   services.rke2.serverAddr = "https://firelink1:9345";
    #   services.rke2.tokenFile = "/var/lib/rancher/rke2/token";
    # Started on its own it would create a separate one-node cluster.
    services.rke2.enable = lib.mkForce false;
    # Must match the installer's /etc/nixos/configuration.nix.
    system.stateVersion = "26.05";

    # Keep the bootloader the installer put on the disk (proven to boot here)
    # instead of ynix's default GRUB.
    boot.loader.grub.enable = lib.mkForce false;
    boot.loader.systemd-boot = {
      enable = true;
      configurationLimit = 10;
    };
    boot.loader.efi.canTouchEfiVariables = true;

    # Same as the old firelink: IPMI, hardware watchdog, panic -> reboot.
    # Remote console: kernel messages + a login prompt on COM2 (ttyS1), which
    # the IMM2 / iLO 4 expose as IPMI serial-over-LAN:
    #   ipmitool -I lanplus -H <bmc-ip> -U <user> -P <pass> sol activate
    # tty0 last = the screen stays the main console.
    # intel_iommu: VT-d for VMs / device passthrough later (KubeVirt).
    boot.kernelParams = ["console=ttyS1,115200n8" "console=tty0" "intel_iommu=on" "iommu=pt"];

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

    environment.systemPackages = [pkgs.ipmitool pkgs.pciutils];

    # The old firelink's nix cache (harmonia, from the `server` features) needs
    # your personal SSH key on the host to decrypt its signing key. Not wanted
    # on the cluster nodes, and its failing secret blocked activation.
    services.harmonia.cache.enable = lib.mkForce false;
    sops = {
      age.sshKeyPaths = ["/home/vyke/.ssh/id_ed25519"];
      defaultSopsFormat = "yaml";
      secrets = lib.mkForce {};
    };
  };
}
