{ pkgs, ... }:
{
  # Fix fingerprint reader after suspend/resume
  powerManagement.powerDownCommands = ''
    ${pkgs.systemd}/bin/systemctl stop fprintd.service 2>/dev/null || true
  '';
  # Reset xHCI controller after resume to recover fingerprint reader
  powerManagement.resumeCommands = ''
    # Unbind the dead xHCI controller
    echo '0000:c1:00.4' > /sys/bus/pci/drivers/xhci_hcd/unbind 2>/dev/null || true

    # Rebind to reset it
    echo '0000:c1:00.4' > /sys/bus/pci/drivers/xhci_hcd/bind 2>/dev/null || true

    # fprintd will auto-start when needed
  '';
}
