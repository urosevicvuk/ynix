# fanctl: CPU-temperature-driven fan control for the Lenovo x3650 M5 (IMM2).
#
# Why: the IMM2 can't read the temperature of third-party PCIe cards (retail
# ConnectX-4 Lx, Samsung NVMe) and runs every fan at ~7,700 RPM to be safe,
# even with the whole box at 30 °C. This sets both fan zones from the CPU
# package temperature instead. Diagnosis: modules/hardware/x3650m5.nix.
#
# Zones (verified on firelink1): 0x01 = fans 1-3, 0x02 = fans 4-6.
# Command: ipmitool raw 0x3a 0x07 <zone> <speed 0x00-0xFF> 0x01
#
# Safety:
#   - CPU temp unreadable        -> full speed (0xFF)
#   - CPU >= CPU_FULL            -> full speed
#   - NVMe / NIC / PCH actually hot (a real reading, not "unknown") -> full speed
#   - service stops for any reason -> the unit's ExecStopPost cold-resets the
#                                     IMM, which takes back its own fan control
#   - re-sends every INTERVAL s, in case the IMM takes control back
#
# Environment (for tests): HWMON_ROOT, IPMITOOL, FANCTL_ONESHOT=1.

HWMON_ROOT="${HWMON_ROOT:-/sys/class/hwmon}"
IPMITOOL="${IPMITOOL:-ipmitool}"
INTERVAL="${FANCTL_INTERVAL:-10}"

# CPU package temp (°C) -> raw speed, linear between points.
CURVE_T=(40 50 60 70 78)
CURVE_S=(32 48 80 144 255) # 0x20 0x30 0x50 0x90 0xFF
CPU_FULL=78
# Emergency thresholds for non-CPU sensors (°C). Only real heat counts.
NVME_HOT=70
NIC_HOT=95
PCH_HOT=80

# Max temp1 (°C) across hwmon devices with the given name; empty if none.
hwmon_max() {
  local max="" h v
  for h in "$HWMON_ROOT"/hwmon*; do
    [ "$(cat "$h/name" 2>/dev/null)" = "$1" ] || continue
    v=$(cat "$h/temp1_input" 2>/dev/null) || continue
    [ -n "$v" ] || continue
    v=$((v / 1000))
    if [ -z "$max" ] || [ "$v" -gt "$max" ]; then max=$v; fi
  done
  echo "$max"
}

speed_for() {
  local t=$1 i n=${#CURVE_T[@]}
  if [ "$t" -le "${CURVE_T[0]}" ]; then
    echo "${CURVE_S[0]}"
    return
  fi
  for ((i = 1; i < n; i++)); do
    if [ "$t" -le "${CURVE_T[i]}" ]; then
      local t0=${CURVE_T[i - 1]} t1=${CURVE_T[i]} s0=${CURVE_S[i - 1]} s1=${CURVE_S[i]}
      echo $((s0 + (s1 - s0) * (t - t0) / (t1 - t0)))
      return
    fi
  done
  echo 255
}

set_fans() {
  local zone
  for zone in 0x01 0x02; do
    "$IPMITOOL" raw 0x3a 0x07 "$zone" "$(printf '0x%02X' "$1")" 0x01 >/dev/null 2>&1 ||
      echo "warning: ipmitool failed for zone $zone" >&2
  done
}

last=""
while true; do
  cpu=$(hwmon_max coretemp)
  nvme=$(hwmon_max nvme)
  nic=$(hwmon_max mlx5)
  pch=$(hwmon_max pch_wellsburg)
  reason=""

  if [ -z "$cpu" ]; then
    speed=255
    reason="CPU temp unreadable"
  elif [ "$cpu" -ge "$CPU_FULL" ]; then
    speed=255
    reason="CPU ${cpu}C >= ${CPU_FULL}C"
  else
    speed=$(speed_for "$cpu")
  fi
  if [ -n "$nvme" ] && [ "$nvme" -ge "$NVME_HOT" ]; then
    speed=255
    reason="NVMe ${nvme}C hot"
  fi
  if [ -n "$nic" ] && [ "$nic" -ge "$NIC_HOT" ]; then
    speed=255
    reason="NIC ${nic}C hot"
  fi
  if [ -n "$pch" ] && [ "$pch" -ge "$PCH_HOT" ]; then
    speed=255
    reason="PCH ${pch}C hot"
  fi

  set_fans "$speed"
  if [ "$speed" != "$last" ]; then
    echo "cpu=${cpu:-?}C nvme=${nvme:-?}C nic=${nic:-?}C pch=${pch:-?}C -> speed=$(printf '0x%02X' "$speed")${reason:+ ($reason)}"
    last=$speed
  fi

  [ "${FANCTL_ONESHOT:-0}" = 1 ] && exit 0
  sleep "$INTERVAL" &
  wait $!
done
