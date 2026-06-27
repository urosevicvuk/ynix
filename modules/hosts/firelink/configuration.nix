{
  self,
  inputs,
  ...
}: {
  flake.nixosConfigurations.firelink = inputs.nixpkgs.lib.nixosSystem {
    modules = [self.nixosModules.firelink];
  };

  flake.nixosModules.firelink = {
    config,
    pkgs,
    ...
  }: {
    imports = [
      self.nixosModules.system
      self.nixosModules.shell
      self.nixosModules.neovim
      self.nixosModules.server

      self.nixosModules.sops
    ];

    networking.hostName = "firelink";
    system.stateVersion = "24.05";

    # --- Remote-resilience hardening (2026-06-27) ---
    # firelink hard-froze (silent hang, NO kernel panic) ~00:12 and sat dead ~11h
    # until a manual power-cycle. That boot logged a CORRECTED ECC memory error
    # (DIMM module 20, rank 0) + an MCE on socket 1 — a degrading DIMM on aging
    # x3650 M5 hardware is the prime suspect. We're remote with no physical access
    # for ~a month, so: (1) make the box auto-recover from a freeze, (2) auto-isolate
    # failing memory. ALL of this applies on `nixos-rebuild switch` WITHOUT a reboot.
    # (The LTS-kernel pin is deliberately NOT done here — it needs a reboot, which is
    #  too risky with no one on-site if it fails to boot. Do that when physically present.)

    # IMM2 (BMC) hardware watchdog: systemd pets /dev/watchdog; if the OS hangs and
    # stops petting, the BMC hard-resets the host — independent of the CPU, so it
    # recovers even a full hardware freeze. Turns "11h dead + call mom" into a
    # ~2min auto-reboot. (kvm-intel from hardware.nix merges into this list.)
    boot.kernelModules = ["ipmi_si" "ipmi_devintf" "ipmi_watchdog"];
    boot.extraModprobeConfig = "options ipmi_watchdog action=reset";
    systemd.settings.Manager = {
      RuntimeWatchdogSec = "2min"; # BMC resets if systemd stops petting for 2 min
      RebootWatchdogSec = "5min"; # if a clean reboot itself wedges, force-reset
    };

    # Auto-reboot on the software-detectable failures too.
    boot.kernel.sysctl = {
      "kernel.panic" = 10; # reboot 10s after a panic
      "kernel.panic_on_oops" = 1; # promote an oops to a panic -> reboot
      "kernel.hardlockup_panic" = 1; # panic -> reboot if the NMI detector sees a hard lockup
    };

    # rasdaemon: record ECC/MCE events and auto-offline memory pages that keep
    # faulting, isolating the bad DIMM's cells without touching the hardware.
    # Inspect later: `ras-mc-ctl --summary` and `ras-mc-ctl --errors`.
    hardware.rasdaemon.enable = true;

    # ipmitool: read the IMM2 hardware event log + find the BMC IP for remote access.
    #   sudo ipmitool sel elist          # historical hardware faults (DIMM/CPU/PSU/thermal)
    #   sudo ipmitool lan print 1        # IMM2 IP -> ssh -L 8443:<that-ip>:443 firelink
    #   sudo ipmitool sdr type Memory    # per-DIMM status / which slot is module 20
    environment.systemPackages = [pkgs.ipmitool];

    home-manager.users.${config.preferences.username} = {
      home.packages = with pkgs; [
      ];
    };

    sops = {
      age.sshKeyPaths = ["/home/vyke/.ssh/id_ed25519"];
      defaultSopsFormat = "yaml";

      secrets = {
        #"cloudflare-tunnel-token" = {
        #  sopsFile = ../../secrets/server/cloudflare.yaml;
        #  key = "tunnel_token";
        #  mode = "0400";
        #};

        #"cloudflare-ddns-token" = {
        #  sopsFile = ../../secrets/server/cloudflare.yaml;
        #  key = "dns_token";
        #  mode = "0400";
        #};

        #"cloudflare-zone-id" = {
        #  sopsFile = ../../secrets/server/cloudflare.yaml;
        #  key = "zone_id";
        #  mode = "0400";
        #};
      };
    };
  };
}
