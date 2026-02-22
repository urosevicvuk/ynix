{pkgs, ...}: {
  # Fix fingerprint reader after suspend/resume
  #powerManagement.powerDownCommands = ''
  #  ${pkgs.systemd}/bin/systemctl stop fprintd.service 2>/dev/null || true
  #'';
  ## Reset xHCI controller after resume to recover fingerprint reader
  #powerManagement.resumeCommands = ''
  #  # Unbind the dead xHCI controller
  #  echo '0000:c1:00.4' > /sys/bus/pci/drivers/xhci_hcd/unbind 2>/dev/null || true

  #  # Rebind to reset it
  #  echo '0000:c1:00.4' > /sys/bus/pci/drivers/xhci_hcd/bind 2>/dev/null || true

  #  # fprintd will auto-start when needed
  #'';

  # Bounce WiFi after suspend — MT7925 resumes in a broken state where it
  # appears connected but can't pass traffic. Toggling radio off/on forces
  # a clean reconnect.
  #systemd.services.wifi-resume-fix = {
  #  description = "Restart WiFi after suspend";
  #  after = ["suspend.target" "hibernate.target" "suspend-then-hibernate.target"];
  #  wantedBy = ["suspend.target" "hibernate.target" "suspend-then-hibernate.target"];
  #  serviceConfig = {
  #    Type = "oneshot";
  #    ExecStart = "${pkgs.kmod}/bin/modprobe -r mt7925e";
  #    ExecStartPost = [
  #      "${pkgs.kmod}/bin/modprobe mt7925e"
  #      "${pkgs.systemd}/bin/systemctl restart iwd.service"
  #      "${pkgs.systemd}/bin/systemctl restart NetworkManager.service"
  #    ];
  #  };
  #};
}
