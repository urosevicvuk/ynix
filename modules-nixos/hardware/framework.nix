{pkgs, ...}: {
  # Bounce WiFi after suspend — MT7925 resumes in a broken state where it
  # appears connected but can't pass traffic. Toggling radio off/on forces
  # a clean reconnect.
  systemd.services.wifi-resume-fix = {
    description = "Restart WiFi after suspend";
    after = ["suspend.target" "hibernate.target" "suspend-then-hibernate.target"];
    wantedBy = ["suspend.target" "hibernate.target" "suspend-then-hibernate.target"];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.kmod}/bin/modprobe -r mt7925e";
      ExecStartPost = [
        "${pkgs.coreutils}/bin/sleep 3"
        "${pkgs.kmod}/bin/modprobe mt7925e"
        "${pkgs.coreutils}/bin/sleep 2"
        "${pkgs.systemd}/bin/systemctl restart iwd.service"
        "${pkgs.coreutils}/bin/sleep 2"
        "${pkgs.systemd}/bin/systemctl restart NetworkManager.service"
      ];
    };
  };
}
