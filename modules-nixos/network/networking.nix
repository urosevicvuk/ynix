{
  config,
  pkgs,
  ...
}: let
  inherit (config.var) hostname;
in {
  networking = {
    firewall = {
      enable = true;
      allowPing = false;
    };
    hostName = hostname;
    networkmanager = {
      enable = true;
      wifi = {
        backend = "iwd";
        # Disable power saving - this causes disconnects
        powersave = false;
        ## Reduce background scanning
        scanRandMacAddress = false;
        ## Disable MAC randomization completely
        macAddress = "preserve";
      };
    };
  };

  #systemd.services.NetworkManager-wait-online.enable = false;

  ## Keep WiFi active
  #powerManagement.enable = false;

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

  services.udev.extraRules = ''
    # Disable power management for WiFi
    ACTION=="add", SUBSYSTEM=="net", KERNEL=="wlp*", RUN+="${pkgs.iw}/bin/iw dev $name set power_save off"
  '';
}
