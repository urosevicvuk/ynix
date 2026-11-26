# Lenovo System x3650 M5: fan control.
#
# With third-party PCIe cards (Mellanox ConnectX-4 Lx, Samsung NVMe on an
# adapter) the IMM2 can't read their temperatures and runs every fan at
# ~7,700 RPM while the box idles at ~30 °C. IMM2 has no setting for that, so
# `fanctl` drives the fans from the CPU temperatures (same script as on the
# Proxmox install): idle ~2,200 RPM, full load ~5,400 RPM. It still reads
# the NIC/NVMe/PCH temperatures itself and goes to full speed if one gets hot.
# When the service stops, the IMM gets control back (loud, but safe).
{
  flake.nixosModules.x3650m5 = {
    lib,
    pkgs,
    ...
  }: let
    fanctl = pkgs.writeShellApplication {
      name = "fanctl";
      runtimeInputs = [pkgs.ipmitool pkgs.coreutils];
      # No errexit: a failed ipmitool call must not kill the loop.
      bashOptions = ["nounset" "pipefail"];
      text = builtins.readFile ./_fanctl.sh;
    };
  in {
    boot.kernelModules = ["coretemp" "ipmi_si" "ipmi_devintf"];
    environment.systemPackages = [pkgs.ipmitool pkgs.lm_sensors];

    systemd.services.fanctl = {
      description = "CPU-temperature-driven fan control (overrides IMM2 third-party-card fan policy)";
      wantedBy = ["multi-user.target"];
      after = ["systemd-modules-load.service"];
      serviceConfig = {
        ExecStart = lib.getExe fanctl;
        ExecStopPost = "${lib.getExe' pkgs.ipmitool "ipmitool"} mc reset cold";
        Restart = "always";
        RestartSec = 30;
      };
    };
  };
}
